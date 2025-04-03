import 'dart:async';
import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Services/APICaller.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:app_hm/View/Account/ChangePassword.dart';
import 'package:app_hm/View/Account/SendOTP.dart';
import 'package:app_hm/View/Login/Login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LoginController extends GetxController {
  TextEditingController textUserName = TextEditingController();
  TextEditingController textPass = TextEditingController();
  RxBool isHidePassword = true.obs;
  RxBool isLoading = false.obs;
  DateTime timeNow = DateTime.now();

  // Forgot password
  RxBool isOTP = false.obs;
  RxBool isButtonDisabled = true.obs;
  RxInt timerValue = 60.obs;
  Timer? timer;
  RxBool isHidePasswordNew = true.obs;
  RxBool isHidePasswordConfirm = true.obs;
  RxBool isForgotPasswordLoading = false.obs;
  TextEditingController textEmail = TextEditingController();
  TextEditingController textOTP = TextEditingController();
  TextEditingController textPasswordNew = TextEditingController();
  TextEditingController textPasswordConfirm = TextEditingController();

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  startTimer() {
    isButtonDisabled.value = true;
    timerValue.value = 60;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerValue.value > 0) {
        timerValue.value--;
      } else {
        timer.cancel();
        isButtonDisabled.value = false;
      }
    });
  }

  sendEmail() async {
    if (textEmail.text.trim().isEmpty) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'enter_email_address'.tr);
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
        .hasMatch(textEmail.text.trim())) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'email_formatted'.tr);
    } else {
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "email": textEmail.text.trim()
      };
      try {
        var response =
            await APICaller.getInstance().post('/Account/send_otp.php', param);
        // if (response != null) {
        //   startTimer();
        // }
        if (response != null && response["error"]["code"] == 0) {
          startTimer();
          Utils.showSnackBar(
              title: 'notification'.tr, message: "Đã gửi mã OTP thành công");
          Get.to(() => const Sentotp());
        } else {
          Utils.showSnackBar(
              title: 'notification'.tr, message: response["error"]["message"]);
        }
      } catch (e) {
        // Utils.showSnackBar(title: 'notification'.tr, message: '$e');
        debugPrint("Lỗi API: $e", wrapWidth: 1024);
      }
    }
  }

  enterOTP() async {
    if (textEmail.text.trim().isEmpty) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'enter_email_address'.tr);
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
        .hasMatch(textEmail.text.trim())) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'email_formatted'.tr);
    } else if (textOTP.text.trim().isEmpty) {
      Utils.showSnackBar(title: 'notification'.tr, message: 'enter_otp'.tr);
    } else {
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "otp": textOTP.text.trim(),
        "email": textEmail.text.trim()
      };
      try {
        var response = await APICaller.getInstance()
            .post('/Account/verify_otp.php', param);

        if (response != null && response["error"]["code"] == 0) {
          Utils.showSnackBar(
              title: 'notification'.tr, message: "Xác thực OTP thành công");
          Get.to(() => const Changepassword());
        } else {
          Utils.showSnackBar(
              title: 'notification'.tr, message: response["error"]["message"]);
        }
      } catch (e) {
        Utils.showSnackBar(title: 'notification'.tr, message: '$e');
      }
    }
  }

  changePassword() async {
    if (textPasswordNew.text.isEmpty) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'enter_new_password'.tr);
    } else if (textPasswordConfirm.text.isEmpty) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 're_enter_new_password'.tr);
    } else if (textPasswordNew.text.length < 6) {
      Utils.showSnackBar(title: 'notification'.tr, message: '6_characters'.tr);
    } else if (textPasswordNew.text.length > 50) {
      Utils.showSnackBar(title: 'notification'.tr, message: '50_characters'.tr);
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).*$')
        .hasMatch(textPasswordNew.text)) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'password_contain'.tr);
    } else if (textPasswordNew.text != textPasswordConfirm.text) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'password_not_match'.tr);
    } else {
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "otp": textOTP.text.trim(),
        "email": textEmail.text.trim(),
        "newPassword": textPasswordConfirm.text.trim()
      };
      try {
        var response = await APICaller.getInstance()
            .post('/Account/change_pass_forget.php', param);
        if (response != null) {
          textEmail.clear();
          textOTP.clear();
          textPasswordNew.clear();
          textPasswordConfirm.clear();
          isOTP.value = !isOTP.value;
          Get.offAllNamed(Routes.login);
          Utils.showSnackBar(
              title: 'notification'.tr,
              message: 'password_changed_successfully'.tr);
        }
      } catch (e) {
        Utils.showSnackBar(title: 'notification'.tr, message: '$e');
      }
    }
  }
}
