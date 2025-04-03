import 'dart:convert';
import 'dart:io';

import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Model/Account/AccountModel.dart';
import 'package:app_hm/Services/APICaller.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Personalcontroller extends GetxController {
  RxBool isLoading = true.obs;
  DateTime timeNow = DateTime.now();
  int uidAcc = 0;

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

  Future<void> onInit() async {
    super.onInit();
    uidAcc = await Utils.getIntValueWithKey(Constant.UUID_USER_ACC);

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
      "uid": uidAcc,
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
    textFullName.text = account.fullname ?? '';
    textPhone.text = account.phonenum ?? '';
    textAddress.text = account.address ?? '';
    textEmail.text = account.email ?? '';
    textGender.text = setGender(account.gender ?? 0);
    if (account.birthday != null) {
      setDateOfBirth(DateTime.parse(account.birthday!));
    }
    textRole.text = getRoleAccount(account.status ?? 2);
  }

  setDateOfBirth(DateTime dateTime) {
    textDateOfBirth.text = DateFormat('dd/MM/yyyy').format(dateTime);
  }

//   updateAccount() async {
//   if (textFullName.text.trim().isEmpty) {
//     Utils.showSnackBar(title: 'notification'.tr, message: 'enter_full_name'.tr);
//   } else if (textFullName.text.trim().length > 50) {
//     Utils.showSnackBar(title: 'notification'.tr, message: 'full_name_50_characters'.tr);
//   } else if (textPhone.text.trim().isNotEmpty && !RegExp(r'^(0?)(3[2-9]|5[2689]|7[06-9]|8[1-689]|9[0-46-9])[0-9]{7}$').hasMatch(textPhone.text.trim())) {
//     Utils.showSnackBar(title: 'notification'.tr, message: 'phone_number_format'.tr);
//   } else if (textAddress.text.trim().isNotEmpty && textAddress.text.trim().length > 255) {
//     Utils.showSnackBar(title: 'notification'.tr, message: 'address_255_characters'.tr);
//   } else {
//     // Biến để lưu Cloudinary public ID hoặc URL
//     String cloudinaryImage = "";

//     if (imageFile.value.path != '') {
//       await pushFile();
//       cloudinaryImage = responseFileApi.value;
//     }

//     String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
//     var param = {
//       "keyCert": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
//       "time": formattedTime,
//       "uuid": uuidAcc,
//       "roleUuid": roleUuid,
//       "imagesUuid": cloudinaryImage, // Sử dụng Cloudinary publicId hoặc URL
//       "fullName": textFullName.text.trim(),
//       "gender": typeRadio.value,
//       "phone": textPhone.text.trim(),
//       "birthday": DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(textDateOfBirth.text)),
//       "address": textAddress.text.trim(),
//       "regencyUuid": regencyUuid,
//       "email": textEmail.text
//     };

//     print(param);
//     try {
//       var response = await APICaller.getInstance().post('v1/Account/Update_account_login', param);
//       if (response != null) {
//         Utils.saveStringWithKey(Constant.FULL_NAME, textFullName.text.trim());
//         if (Get.isRegistered<DashboardController>()) {
//           final controller = Get.find<DashboardController>();
//           controller.fullName.value = textFullName.text.trim();

//           // Cập nhật avatar - tùy theo bạn lưu publicId hay URL đầy đủ
//           if (cloudinaryImage.isNotEmpty) {
//             // Nếu bạn lưu publicId thì cần cấu hình để hiển thị ảnh
//             // Ví dụ: https://res.cloudinary.com/your_cloud_name/image/upload/publicId
//             String cloudinaryUrl = "https://res.cloudinary.com/your_cloud_name/image/upload/$cloudinaryImage";
//             controller.avatar.value = cloudinaryUrl;
//           }
//         }
//         Get.back();
//         Utils.showSnackBar(title: 'notification'.tr, message: 'account_updated_successfully'.tr);
//       }
//     } catch (e) {
//       Utils.showSnackBar(title: 'notification'.tr, message: '$e');
//     }
//   }
// }

// Hàm upload file lên Cloudinary
// Future<void> pushFile() async {
//   try {
//     // Tạo CloudinaryFile từ path
//     final cloudinaryFile = CloudinaryFile.fromFile(
//       imageFile.value.path,
//       resourceType: CloudinaryResourceType.Image,
//       folder: 'user_profiles', // Tùy chọn thư mục lưu trữ
//     );

//     // Upload lên Cloudinary
//     final response = await cloudinary.uploadFile(cloudinaryFile);

//     // Lưu lại publicId hoặc URL trả về
//     responseFileApi.value = response.publicId; // Hoặc lấy response.secureUrl nếu bạn muốn lưu URL đầy đủ

//     print('Cloudinary upload success: ${response.secureUrl}');
//   } catch (e) {
//     print('Cloudinary upload error: $e');
//     Utils.showSnackBar(title: 'notification'.tr, message: 'Image upload failed: $e');
//   }
// }
}
