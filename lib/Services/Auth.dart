import 'package:app_hm/Controller/DashboardController.dart';
import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Global/GlobalValue.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Services/APICaller.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

enum LoginMethod {
  firebase,
  php,
}

class Auth {
  static String textemail = "";

  static Future<void> backLogin(bool isRun) async {
    if (!isRun) return;

    try {
      clearData();
      await FirebaseAuth.instance.signOut();
      final controller = Get.find<Dashboardcontroller>();

      controller.username.value = '';
      controller.email.value = '';
      controller.avatar.value = '';
      controller.loginMethod.value = null;
      controller.updateIsLoggedIn();

      Utils.showSnackBar(title: 'Thông báo', message: 'log_out_success'.tr);
      Get.offAllNamed(Routes.dashboard);
    } catch (e) {
      print("Lỗi khi đăng xuất: $e");
    }
  }

  // static Future<void> login({
  //   required String username,
  //   required String password,
  //   required LoginMethod method,
  // }) async {
  //   final controller = Get.find<Dashboardcontroller>();
  //   controller.loginMethod.value = method;

  //   if (method == LoginMethod.firebase) {
  //     await loginWithFirebase();
  //   } else {
  //     await loginWithPHP(userName: username, password: password);
  //   }
  // }

  static checkLogin() async {
    String? token = await Utils.getStringValueWithKey(Constant.ACCESS_TOKEN);

    if (token != null && token.isNotEmpty) {
      GlobalValue.getInstance().setToken('Bearer $token');
      Get.offAllNamed(Routes.dashboard);
    } else {
      Get.offAllNamed(Routes.onboarding);
    }
  }

  static Future<void> loginWithFirebase() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        Utils.showSnackBar(title: 'Thông báo', message: 'Đăng nhập bị hủy.');
        return;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = userCredential.user;
      if (user != null) {
        final controller = Get.find<Dashboardcontroller>();

        controller.loginMethod.value = LoginMethod.firebase;
        controller.username.value = user.displayName ?? '';
        controller.email.value = user.email ?? '';
        controller.avatar.value = user.photoURL ?? '';

        await Utils.saveStringWithKey(
            Constant.USERNAME, user.displayName ?? '');
        await Utils.saveStringWithKey(Constant.EMAIL, user.email ?? '');
        await Utils.saveStringWithKey(
            Constant.AVATAR_USER, user.photoURL ?? '');

        await Utils.saveStringWithKey(
            Constant.AVATAR_USER, user.photoURL ?? '');

        Utils.showSnackBar(
            title: 'Thông báo', message: 'Đăng nhập thành công.');
        Get.offAllNamed(Routes.dashboard);
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi đăng nhập', message: e.toString());
    }
  }

  static loginWithPHP({String? userName, String? password}) async {
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);

    String userNamePreferences =
        await Utils.getStringValueWithKey(Constant.USERNAME);
    String passwordPreferences =
        await Utils.getStringValueWithKey(Constant.PASSWORD);

    var param = {
      "keyCert":
          Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "username": userName,
      "password": password ?? passwordPreferences,
    };

    try {
      var data = await APICaller.getInstance().post('Auth/login.php', param);

      if (data != null) {
        GlobalValue.getInstance().setToken('Bearer ${data['data']['token']}');
        Utils.saveStringWithKey(Constant.ACCESS_TOKEN, data['data']['token']);

        DateTime newExpiryTime = timeNow.add(const Duration(minutes: 10));
        String formattedExpiryTime =
            DateFormat('MM/dd/yyyy HH:mm:ss').format(newExpiryTime);
        Utils.saveStringWithKey(Constant.TOKEN_EXPIRY, formattedExpiryTime);

        Utils.saveIntWithKey(
            Constant.UUID_USER_ACC, (data['data']['uid'] ?? 0));
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
            Constant.BIRTHDAY, data['data']['birthday'] ?? '');
        Utils.saveIntWithKey(Constant.GENDER, (data['data']['gender'] ?? 0));
        Utils.saveStringWithKey(
            Constant.AVATAR_USER, data['data']['avatar'] ?? '');
        Utils.saveIntWithKey(Constant.STATUS, data['data']['status'] ?? 0);
        Utils.saveStringWithKey(
            Constant.PASSWORD, password ?? passwordPreferences);

        final controller = Get.find<Dashboardcontroller>();
        controller.isPhpLoggedIn.value = true;
        controller.updateIsLoggedIn();

        Utils.showSnackBar(
            title: 'Thông báo', message: 'Đăng nhập thành công.');
        Get.offAllNamed(Routes.dashboard);
      }
    } catch (e) {
      debugPrint("Lỗi API: $e", wrapWidth: 1024);
    }
  }

  static clearData() async {
    await Utils.removeKey(Constant.UUID_USER_ACC);
    await Utils.removeKey(Constant.GENDER);
    await Utils.removeKey(Constant.STATUS);
    await Utils.removeKey(Constant.USERNAME);
    await Utils.removeKey(Constant.FULL_NAME);
    await Utils.removeKey(Constant.EMAIL);
    await Utils.removeKey(Constant.ADDRESS);
    await Utils.removeKey(Constant.PHONENUM);
    await Utils.removeKey(Constant.BIRTHDAY);
    await Utils.removeKey(Constant.AVATAR_USER);
    await Utils.removeKey(Constant.ACCESS_TOKEN);
  }
}
