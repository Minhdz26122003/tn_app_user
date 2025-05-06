import 'package:app_hm/Controller/DashboardController.dart';
import 'package:app_hm/Controller/Login/LoginController.dart';
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

enum LoginMethod { firebase, php }

class Auth {
  static String textemail = "";
  static DateTime timeNow = DateTime.now();

  static Future<void> backLogin(bool isRun) async {
    if (!isRun) return;

    try {
      clearData();

      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      final controller = Get.isRegistered<Dashboardcontroller>()
          ? Get.find<Dashboardcontroller>()
          : Get.put(Dashboardcontroller());
      controller
        ..username.value = ''
        ..email.value = ''
        ..avatar.value = ''
        ..loginMethod.value = null
        ..isPhpLoggedIn.value = false
        ..isLoggedIn.value = false
        ..updateIsLoggedIn();

      Utils.showSnackBar(
          title: 'notification'.tr, message: 'log_out_success'.tr);
      Get.offAllNamed(Routes.dashboard);
    } catch (e) {
      print("Lỗi khi đăng xuất: $e");
    }
  }

  static Future<bool> checkLogin() async {
    // Lấy phương thức đăng nhập từ bộ nhớ
    String? loginMethodStr =
        await Utils.getStringValueWithKey(Constant.LOGIN_METHOD);
    String timesaved = await Utils.getStringValueWithKey(Constant.TOKEN_EXPIRY);
    final expiryUtc = DateTime.tryParse(timesaved)?.toUtc();
    final nowUtc = DateTime.now().toUtc();

    if (loginMethodStr == 'php') {
      // Kiểm tra đăng nhập bằng PHP
      String? token = await Utils.getStringValueWithKey(Constant.ACCESS_TOKEN);
      if (token == null || token.isEmpty) return false;
      if (timesaved.isEmpty) {
        await Utils.removeKey(Constant.ACCESS_TOKEN);
        return false;
      }
      if (expiryUtc == null || nowUtc.isAfter(expiryUtc)) {
        // token đã hết hạn
        await Utils.removeKey(Constant.ACCESS_TOKEN);
        await Utils.removeKey(Constant.TOKEN_EXPIRY);
        return false;
      }

      return true;
    } else if (loginMethodStr == 'firebase') {
      // Kiểm tra đăng nhập bằng Firebase
      // return FirebaseAuth.instance.currentUser != null;

      if (FirebaseAuth.instance.currentUser == null) return false;
      // Kiểm tra thời gian hết hạn
      if (timesaved.isEmpty) {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        return false;
      }
      if (expiryUtc == null || nowUtc.isAfter(expiryUtc)) {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        await Utils.removeKey(Constant.TOKEN_EXPIRY);
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  static Future<void> loginWithFirebase() async {
    final login = Get.find<LoginController>();
    login.isLoading.value = true;

    try {
      await FirebaseAuth.instance.signOut();
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) await googleSignIn.signOut();

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        Utils.showSnackBar(title: 'Thông báo', message: 'Đăng nhập bị hủy.');
        return;
      }

      final googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        Utils.showSnackBar(title: 'Lỗi', message: 'Không thể xác thực Google.');
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
        final keyCert =
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime);
        final param = {
          "email": user.email ?? '',
          "username": user.displayName ?? 'Unknown',
          "avatar": user.photoURL ?? '',
          "keyCert": keyCert,
          "time": formattedTime,
        };

        final data =
            await APICaller.getInstance().post('Auth/check_user.php', param);
        if (data != null) {
          final controller = Get.isRegistered<Dashboardcontroller>()
              ? Get.find<Dashboardcontroller>()
              : Get.put(Dashboardcontroller());

          controller
            ..loginMethod.value = LoginMethod.firebase
            ..username.value = user.displayName ?? ''
            ..fullname.value = user.displayName ?? ''
            ..email.value = user.email ?? ''
            ..avatar.value = user.photoURL ?? ''
            ..phoneNumber.value = '';
          final d = data['data'];
          // 1 giờ

          final idTokenResult = await user.getIdTokenResult();
          final DateTime expiryUtc = idTokenResult.expirationTime!.toUtc();
          await Utils.saveStringWithKey(
              Constant.TOKEN_EXPIRY, expiryUtc.toIso8601String());

          await Utils.saveStringWithKey(Constant.LOGIN_METHOD, 'firebase');
          await Utils.saveIntWithKey(Constant.UUID_USER_ACC, d['uid'] ?? 0);
          await Utils.saveStringWithKey(
              Constant.USERNAME, controller.username.value);
          await Utils.saveStringWithKey(
              Constant.FULL_NAME, controller.fullname.value);
          await Utils.saveStringWithKey(Constant.EMAIL, controller.email.value);
          await Utils.saveStringWithKey(
              Constant.AVATAR_USER, controller.avatar.value);
          await Utils.saveStringWithKey(
              Constant.PHONENUM, controller.phoneNumber.value);

          Get.offAllNamed(Routes.dashboard);
          Utils.showSnackBar(
              title: 'Thông báo', message: 'Đăng nhập thành công.');
        } else {
          Utils.showSnackBar(
              title: 'Lỗi',
              message: 'Không thể xác thực người dùng từ server.');
        }
      }
    } catch (e) {
      debugPrint("Lỗi API: $e", wrapWidth: 1024);
    } finally {
      login.isLoading.value = false;
    }
  }

  static Future<void> loginWithPHP({String? userName, String? password}) async {
    final login = Get.find<LoginController>();
    login.isLoading.value = true;
    if (login.textUserName.text.trim().isEmpty) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'enter_username'.tr);
    } else if (login.textPass.text.trim().isEmpty) {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'enter_current_password'.tr);
    } else {
      try {
        final timeNow = DateTime.now().toUtc();
        final formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);

        final param = {
          "keyCert":
              Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
          "time": formattedTime,
          "username": userName,
          "password": password,
        };

        final data =
            await APICaller.getInstance().post('Auth/login.php', param);
        if (data == null) throw Exception('API trả về null');

        final token = data['data']['token'];
        await Utils.saveStringWithKey(Constant.ACCESS_TOKEN, token);
        GlobalValue.getInstance().setToken('Bearer $token');

        final DateTime nowUtc = DateTime.now().toUtc();
        final DateTime expiryUtc = nowUtc.add(const Duration(hours: 1));
        final String expiryString = expiryUtc.toIso8601String();
        await Utils.saveStringWithKey(Constant.TOKEN_EXPIRY, expiryString);

        final d = data['data'];
        await Utils.saveStringWithKey(Constant.LOGIN_METHOD, 'php');
        await Utils.saveIntWithKey(Constant.UUID_USER_ACC, d['uid'] ?? 0);
        await Utils.saveStringWithKey(Constant.USERNAME, d['username'] ?? '');
        await Utils.saveStringWithKey(Constant.FULL_NAME, d['fullname'] ?? '');
        await Utils.saveStringWithKey(Constant.EMAIL, d['email'] ?? '');
        await Utils.saveStringWithKey(Constant.ADDRESS, d['address'] ?? '');
        await Utils.saveStringWithKey(Constant.PHONENUM, d['phonenum'] ?? '');
        await Utils.saveStringWithKey(Constant.BIRTHDAY, d['birthday'] ?? '');
        await Utils.saveIntWithKey(Constant.GENDER, d['gender'] ?? 0);
        await Utils.saveStringWithKey(Constant.AVATAR_USER, d['avatar'] ?? '');
        await Utils.saveIntWithKey(Constant.STATUS, d['status'] ?? 0);

        final dashboardCtrl = Get.isRegistered<Dashboardcontroller>()
            ? Get.find<Dashboardcontroller>()
            : Get.put(Dashboardcontroller());

        dashboardCtrl
          ..isPhpLoggedIn.value = true
          ..updateIsLoggedIn();
        Get.offAllNamed(Routes.dashboard);
        Utils.showSnackBar(
            title: 'Thông báo', message: 'Đăng nhập thành công.');
      } catch (e) {
        //debugPrint("Lỗi API: $e", wrapWidth: 1024);
        //Utils.showSnackBar(title: 'Lỗi đăng nhập', message: e.toString());
        Utils.showSnackBar(title: 'notification'.tr, message: 'Error Login');
      } finally {
        login.isLoading.value = false;
      }
    }
  }

  static Future<void> clearData() async {
    await Future.wait([
      Utils.removeKey(Constant.USERNAME),
      Utils.removeKey(Constant.EMAIL),
      Utils.removeKey(Constant.AVATAR_USER),
      Utils.removeKey(Constant.ACCESS_TOKEN),
      Utils.removeKey(Constant.PASSWORD),
      Utils.removeKey(Constant.TOKEN_EXPIRY),
      Utils.removeKey(Constant.FULL_NAME),
      Utils.removeKey(Constant.UUID_USER_ACC),
      Utils.removeKey(Constant.ADDRESS),
      Utils.removeKey(Constant.PHONENUM),
      Utils.removeKey(Constant.BIRTHDAY),
      Utils.removeKey(Constant.GENDER),
      Utils.removeKey(Constant.STATUS),
    ]);
  }
}
