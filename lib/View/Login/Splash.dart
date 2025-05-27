import 'package:app_hm/Controller/Login/SplashController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      // Giảm thời gian hiển thị xuống 3 giây
      final controller = Get.put(Splashcontroller());
    });

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorHex.total_color,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/car_logo.png',
              ),
              Lottie.asset(
                'assets/json/loading.json',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
