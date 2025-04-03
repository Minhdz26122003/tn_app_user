import 'package:app_hm/Controller/Login/SplashController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      final controller = Get.put(Splashcontroller());
    });

    return WillPopScope(
      onWillPop: () async {
        // Trả về `false` để ngăn người dùng quay lại
        return false;
      },
      child: Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [-0.1908, 0.9109],
                transform: GradientRotation(115 * 3.1415926535897932 / 180),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/logocar.svg',
                  width: 100,
                  height: 100,
                ),
                Lottie.asset('assets/json/loading.json'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
