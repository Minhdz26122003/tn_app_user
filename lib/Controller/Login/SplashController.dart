import 'package:app_hm/Component/DialogCustom.dart';
import 'package:app_hm/Controller/DashboardController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Global/GlobalValue.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Services/Auth.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splashcontroller extends GetxController {
  @override
  void onInit() async {
    super.onInit();

    _checkAuthAndRedirect();
  }

  Future<void> _checkAuthAndRedirect() async {
    bool isValid = await Auth.checkLogin();

    if (isValid) {
      String? loginMethod =
          await Utils.getStringValueWithKey(Constant.LOGIN_METHOD);

      if (loginMethod == 'php') {
        String? token =
            await Utils.getStringValueWithKey(Constant.ACCESS_TOKEN);
        if (token != null && token.isNotEmpty) {
          GlobalValue.getInstance().setToken('Bearer $token');
        } else {
          isValid = false;
        }
      } else if (loginMethod == 'firebase') {
        // API cần token Firebase, idToken:
        String? firebaseToken =
            await FirebaseAuth.instance.currentUser?.getIdToken();
        if (firebaseToken != null) {
          GlobalValue.getInstance().setToken('Bearer $firebaseToken');
        }
      } else {
        isValid = false;
      }

      if (isValid) {
        Get.offAllNamed(Routes.dashboard);
      } else {
        _showSessionExpiredDialog();
      }
    } else {
      _showSessionExpiredDialog();
    }
  }

  void _showSessionExpiredDialog() {
    Get.dialog(
      DialogCustom(
        title: 'Phiên đăng nhập hết hạn',
        description:
            'Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại.',
        svg: 'assets/icons/info.svg',
        svgColor: ColorHex.status_0,
        btnColor: ColorHex.total_color,
        onTap: () async {
          await Auth.backLogin(true);
          Get.back(); // đóng dialog
          Get.offAllNamed(Routes.dashboard);
        },
        showCancel: false,
      ),
      barrierDismissible: false,
    );
  }
}
