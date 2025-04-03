import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Services/Auth.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:get/get.dart';

class Splashcontroller extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    String accessToken =
        await Utils.getStringValueWithKey(Constant.ACCESS_TOKEN);
    if (accessToken.isEmpty) {
      Get.offAllNamed(Routes.onboarding);
    } else {
      await Auth.checkLogin();
    }
  }
}
