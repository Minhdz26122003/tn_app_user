import 'package:app_hm/Component/DialogCustom.dart';
import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Global/GlobalValue.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Services/Auth.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splashcontroller extends GetxController {
  @override
  void onInit() async {
    super.onInit();

    _checkAuthAndRedirect();
  }

  Future<void> _checkAuthAndRedirect() async {
    // Kiểm tra token hợp lệ
    bool isValid = await Auth.checkLogin();

    if (isValid) {
      String token = await Utils.getStringValueWithKey(Constant.ACCESS_TOKEN);
      GlobalValue.getInstance().setToken('Bearer $token');
      Get.offAllNamed(Routes.dashboard);
    } else {
      Get.dialog(
        DialogCustom(
          title: 'Phiên đăng nhập hết hạn',
          description:
              'Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại.',
          svg: 'assets/icons/info.svg',
          svgColor: Colors.red,
          btnColor: Colors.blue,
          onTap: () {
            Get.back(); // đóng dialog
            Get.offAllNamed(Routes.login);
          },
          showCancel: false,
        ),
        barrierDismissible: false,
      );
    }
  }
}
