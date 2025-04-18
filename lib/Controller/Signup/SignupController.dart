import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Global/GlobalValue.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Services/APICaller.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SignupController extends GetxController {
  TextEditingController textUserName = TextEditingController();
  TextEditingController textPass = TextEditingController();
  TextEditingController textConfirmPass = TextEditingController();
  TextEditingController textEmail = TextEditingController();
  TextEditingController textFullName = TextEditingController();
  TextEditingController textPhonenum = TextEditingController();

  final isHidePassword = true.obs;
  final isHideConfirmPassword = true.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    textUserName.dispose();
    textPass.dispose();
    textConfirmPass.dispose();
    textEmail.dispose();
    textFullName.dispose();
    textPhonenum.dispose();
    super.onClose();
  }

  Future<void> registerWithPHP({
    required String userName,
    required String password,
    required String email,
    required String fullName,
    String? address,
    String? phonenum,
    String? birthday,
    String? gender,
  }) async {
    if (textPass.text.isEmpty) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'enter_new_password'.tr);
    } else if (textConfirmPass.text.isEmpty) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 're_enter_new_password'.tr);
    } else if (textPass.text.length < 6) {
      Utils.showSnackBar(title: 'notification'.tr, message: '6_characters'.tr);
    } else if (textPass.text.length > 50) {
      Utils.showSnackBar(title: 'notification'.tr, message: '50_characters'.tr);
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).*$')
        .hasMatch(textPass.text)) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'password_contain'.tr);
    } else if (textPass.text != textConfirmPass.text) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'password_not_match'.tr);
    } else {
      DateTime timeNow = DateTime.now().toUtc();
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);

      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "username": userName,
        "password": password,
        "email": email,
        "fullname": fullName,
        "address": address ?? "",
        "phonenum": phonenum ?? "",
        "birthday": birthday ?? "",
        "gender": gender ?? "",
      };

      try {
        var data =
            await APICaller.getInstance().post('/Auth/signup.php', param);

        if (data != null) {
          // Lưu thông tin người dùng đăng ký thành công
          GlobalValue.getInstance().setToken('Bearer ${data['data']['token']}');
          Utils.saveStringWithKey(Constant.ACCESS_TOKEN, data['data']['token']);

          // Thiết lập thời gian hết hạn token
          DateTime newExpiryTime = timeNow.add(const Duration(minutes: 10));
          String formattedExpiryTime =
              DateFormat('MM/dd/yyyy HH:mm:ss').format(newExpiryTime);
          Utils.saveStringWithKey(Constant.TOKEN_EXPIRY, formattedExpiryTime);

          // Lưu thông tin người dùng
          Utils.saveStringWithKey(
              Constant.UUID_USER_ACC, data['data']['uid'].toString());
          Utils.saveStringWithKey(
              Constant.USERNAME, data['data']['username'] ?? '');
          Utils.saveStringWithKey(
              Constant.FULL_NAME, data['data']['fullname'] ?? '');
          Utils.saveStringWithKey(Constant.EMAIL, data['data']['email'] ?? '');
          Utils.saveStringWithKey(
              Constant.ADDRESS, data['data']['address'] ?? '');
          Utils.saveStringWithKey(
              Constant.PHONENUM, data['data']['phonenum'] ?? '');
          Utils.saveStringWithKey(
              Constant.AVATAR_USER, data['data']['avatar'] ?? '');
          Utils.saveStringWithKey(
              Constant.STATUS, data['data']['status']?.toString() ?? '');
          Utils.saveStringWithKey(Constant.PASSWORD, password);

          Utils.showSnackBar(
              title: 'Thông báo', message: 'Đăng ký tài khoản thành công.');

          // Chuyển đến trang dashboard
          Get.offAllNamed(Routes.login);
        }
      } catch (e) {
        Utils.showSnackBar(title: 'Thông báo', message: '$e');
        //debugPrint("Lỗi API đăng ký: $e", wrapWidth: 1024);
      }
    }
  }
}
