import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Services/Auth.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboardcontroller extends GetxController {
  RxInt currentPageIndex = 0.obs;
  RxString username = ''.obs;
  RxString fullname = ''.obs;
  RxString avatar = ''.obs;
  RxString email = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString birthDate = ''.obs;
  RxString gender = ''.obs;
  RxString address = ''.obs;
  RxBool isLoading = true.obs;

  Rxn<User> firebaseUser = Rxn<User>();

  RxBool isPhpLoggedIn = false.obs;
  // phương thức đăng nhâp
  Rx<LoginMethod?> loginMethod = Rx<LoginMethod?>(null);
  RxBool isLoggedIn = false.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Future<void> onInit() async {
    super.onInit();

    // firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());

    checkPhpToken();
    // Mỗi khi firebaseUser thay đổi, cập nhật isLoggedIn
    ever<User?>(firebaseUser, (_) => updateIsLoggedIn());

    super.onInit();
    try {
      isLoading.value = true;
      username.value =
          await Utils.getStringValueWithKey(Constant.USERNAME) ?? '';
      avatar.value =
          await Utils.getStringValueWithKey(Constant.AVATAR_USER) ?? '';
      email.value = await Utils.getStringValueWithKey(Constant.EMAIL) ?? '';
      phoneNumber.value =
          await Utils.getStringValueWithKey(Constant.PHONENUM) ?? '';
      birthDate.value =
          await Utils.getStringValueWithKey(Constant.BIRTHDAY) ?? '';
      gender.value = await Utils.getStringValueWithKey(Constant.GENDER) ?? '';
      address.value = await Utils.getStringValueWithKey(Constant.ADDRESS) ?? '';
    } catch (e) {
      print("Lỗi khi tải dữ liệu: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void checkPhpToken() async {
    String token = await Utils.getStringValueWithKey(Constant.ACCESS_TOKEN);
    isPhpLoggedIn.value = token.isNotEmpty;
    updateIsLoggedIn();
  }

  // void updateIsLoggedIn() {
  //   // Nếu firebaseUser đã đăng nhâp HOẶC có token PHP => đã đăng nhập
  //   isLoggedIn.value = (firebaseUser.value != null) || isPhpLoggedIn.value;
  //   // Utils.showSnackBar(title: 'Thông báo', message: '$isLoggedIn');
  // }
  void updateIsLoggedIn() {
    if (firebaseUser.value != null) {
      isLoggedIn.value = true;
      loginMethod.value ??= LoginMethod.firebase;
    } else if (isPhpLoggedIn.value && loginMethod.value == null) {
      isLoggedIn.value = true;
      loginMethod.value ??= LoginMethod.php;
    } else {
      isLoggedIn.value = false;
    }
  }

  void changePage(int index) {
    currentPageIndex.value = index;
  }
}
