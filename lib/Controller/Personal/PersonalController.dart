import 'dart:convert';
import 'dart:io';

import 'package:app_hm/Controller/DashboardController.dart';
import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Model/Account/AccountModel.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Services/APICaller.dart';
import 'package:app_hm/Services/Cloudiary.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Personalcontroller extends GetxController {
  RxBool isLoading = true.obs;
  DateTime timeNow = DateTime.now();
  int uidAcc = 0;
  String emailAcc = "";
  String UsernameAcc = "";

  RxString selectedGender = ''.obs;
  Rx<File> imageFile = File('').obs;
  RxString responseFileApi = ''.obs;

  AccountModel account = AccountModel();
  TextEditingController textUserName = TextEditingController();
  TextEditingController textFullName = TextEditingController();
  TextEditingController textDateOfBirth = TextEditingController();
  TextEditingController textPhone = TextEditingController();
  TextEditingController textAddress = TextEditingController();
  TextEditingController textEmail = TextEditingController();
  TextEditingController textRole = TextEditingController();
  TextEditingController textGender = TextEditingController();

  TextEditingController textPasswordOld = TextEditingController();
  TextEditingController textPasswordNew = TextEditingController();
  TextEditingController textPasswordConfirm = TextEditingController();
  RxBool isHidePasswordNew = true.obs;
  RxBool isHidePasswordConfirm = true.obs;
  RxBool isHidePasswordOld = true.obs;

  Future<void> onInit() async {
    super.onInit();
    uidAcc = await Utils.getIntValueWithKey(Constant.UUID_USER_ACC);
    emailAcc = await Utils.getStringValueWithKey(Constant.EMAIL);
    UsernameAcc = await Utils.getStringValueWithKey(Constant.USERNAME);
    textEmail.text = emailAcc;
    textUserName.text = UsernameAcc;

    await getAccount();
    setAccount();
    isLoading.value = false;
  }

  getImage(int source) async {
    final file = await Utils.getImagePicker(source);
    if (file != null) {
      imageFile.value = file;
    }
  }

  closeImage() {
    imageFile.value = File('');
    responseFileApi.value = '';
  }

  String getRoleAccount(int status) {
    switch (status) {
      case 1:
        return 'Admin';
      case 2:
        return 'User';
      default:
        return 'Guest';
    }
  }

  String setGender(int genderValue) {
    switch (genderValue) {
      case 0:
        selectedGender.value = 'male'.tr; // 0 -> male
        return selectedGender.value;
      case 1:
        selectedGender.value = 'female'.tr; // 1 -> female
        return selectedGender.value;
      default:
        selectedGender.value = 'other'.tr; // 2 -> other
        return selectedGender.value;
    }
  }

  getAccount() async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);

    var param = {
      "keyCert":
          Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "email": emailAcc,
    };
    try {
      var response = await APICaller.getInstance()
          .post('/Account/account_detail.php', param);
      if (response != null) {
        account = AccountModel.fromJson(response['data']);
      }
    } catch (e) {
      debugPrint(" Lỗi API: $e", wrapWidth: 1024);
    }
  }

  setAccount() {
    textUserName.text =
        (account.username != null && account.username!.isNotEmpty)
            ? account.username!
            : UsernameAcc;

    textFullName.text = account.fullname ?? '';
    textPhone.text = account.phonenum ?? '';
    textAddress.text = account.address ?? '';
    // Nếu account.email rỗng thì giữ lại emailAcc đã có
    textEmail.text = (account.email != null && account.email!.isNotEmpty)
        ? account.email!
        : emailAcc;
    textGender.text = setGender(account.gender ?? 0);
    if (account.birthday != null) {
      setDateOfBirth(DateTime.parse(account.birthday!));
    }
    textRole.text = getRoleAccount(account.status ?? 2);
  }

  // setAccount() {
  //   textUserName.text = account.username ?? '';
  //   textFullName.text = account.fullname ?? '';
  //   textPhone.text = account.phonenum ?? '';
  //   textAddress.text = account.address ?? '';
  //   textEmail.text = account.email ?? '';
  //   textGender.text = setGender(account.gender ?? 0);
  //   if (account.birthday != null) {
  //     setDateOfBirth(DateTime.parse(account.birthday!));
  //   }
  //   textRole.text = getRoleAccount(account.status ?? 2);
  // }

  setDateOfBirth(DateTime dateTime) {
    textDateOfBirth.text = DateFormat('dd/MM/yyyy').format(dateTime);
  }

  changePassword() async {
    if (textPasswordOld.text.isEmpty) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'enter_old_password'.tr);
    } else if (textPasswordNew.text.isEmpty) {
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
        "uid": uidAcc,
        "oldPassword": textPasswordOld.text.trim(),
        "newPassword": textPasswordConfirm.text.trim(),
        "confirmPassword": textPasswordConfirm.text.trim(),
      };
      try {
        var response = await APICaller.getInstance()
            .post('/Account/change_pass.php', param);
        if (response != null) {
          textPasswordNew.clear();
          textPasswordConfirm.clear();
          Get.offAllNamed(Routes.personal);
          Utils.showSnackBar(
              title: 'notification'.tr,
              message: 'password_changed_successfully'.tr);
        }
      } catch (e) {
        debugPrint("Lỗi API: $e", wrapWidth: 1024);
      }
    }
  }

  Future<void> updateAccount() async {
    if (textUserName.text.trim().isEmpty) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'enter_username'.tr);
      return;
    } else if (textFullName.text.trim().isEmpty) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'enter_full_name'.tr);
      return;
    } else if (textFullName.text.trim().length > 50) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'full_name_50_characters'.tr);
      return;
    } else if (textPhone.text.trim().isNotEmpty &&
        !RegExp(r'^(0?)(3[2-9]|5[2689]|7[06-9]|8[1-689]|9[0-46-9])[0-9]{7}$')
            .hasMatch(textPhone.text.trim())) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'phone_number_format'.tr);
      return;
    } else if (textAddress.text.trim().isNotEmpty &&
        textAddress.text.trim().length > 255) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'address_255_characters'.tr);
      return;
    } else {
      // lưu Cloudinary publicId hoặc URL
      String cloudinaryImage = "";

      if (imageFile.value.path.isNotEmpty) {
        await pushFile();
        cloudinaryImage = responseFileApi.value;
      }

      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "uid": uidAcc ?? "",
        "username": textUserName.text.trim(),
        "avatar": cloudinaryImage,
        "fullname": textFullName.text.trim(),
        "gender": textGender.text.trim(),
        "phonenum": textPhone.text.trim(),
        "birthday": DateFormat('yyyy-MM-dd')
            .format(DateFormat('dd/MM/yyyy').parse(textDateOfBirth.text)),
        "address": textAddress.text.trim(),
        "email": textEmail.text.trim()
      };

      print(param);
      try {
        var response = await APICaller.getInstance()
            .post('/Account/edit_account.php', param);
        if (response != null) {
          Utils.saveStringWithKey(Constant.FULL_NAME, textFullName.text.trim());

          if (Get.isRegistered<Dashboardcontroller>()) {
            final controllerDashboard = Get.find<Dashboardcontroller>();
            controllerDashboard.username.value = textUserName.text.trim();
            controllerDashboard.email.value = textEmail.text.trim();
            // controllerDashboard.avatar.value = imageFile.value.path;
            if (cloudinaryImage.isNotEmpty) {
              // Nếu lưu URL đầy đủ từ Cloudinary thì sử dụng luôn
              controllerDashboard.avatar.value = cloudinaryImage;
            }
          }
          Get.back();
          Utils.showSnackBar(
              title: 'notification'.tr,
              message: 'account_updated_successfully'.tr);
        }
      } catch (e) {
        // Utils.showSnackBar(title: 'notification'.tr, message: '$e');
        debugPrint("Lỗi API: $e", wrapWidth: 1024);
      }
    }
  }

  // Hàm upload file lên Cloudinary
  Future<void> pushFile() async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.value.path,
          resourceType: CloudinaryResourceType.Image,
          folder: 'user_profiles',
        ),
      );
      // Lưu lại publicId hoặc secureUrl (tuỳ chọn)
      responseFileApi.value = response.secureUrl;
      print('Cloudinary tải lên thành công: ${response.secureUrl}');
    } catch (e) {
      print('Cloudinary tải lên lỗi: $e');
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'Ảnh tải lên lỗi: $e');
    }
  }
}
