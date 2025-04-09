import 'package:app_hm/Controller/DashboardController.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Dashboardcontroller());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2D74FF),
        title: Text('setting_all'.tr, style: TextStyle(color: Colors.black)),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Obx(() {
          return controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 5),
                      child: Expanded(
                          child: Column(
                        children: [
                          _item(
                            title: 'language'.tr,
                            svg: 'assets/icons/language_icon.svg',
                            onTap: () {
                              Get.toNamed(Routes.language);
                            },
                          ),
                          const SizedBox(height: 5),
                          _item(
                            title: 'notification'.tr,
                            svg: 'assets/icons/notification.svg',
                            onTap: () {
                              if (!controller.isLoggedIn.value) {
                                Get.toNamed(Routes.notification);
                              } else {
                                Get.toNamed(Routes.login);
                              }
                            },
                          ),
                        ],
                      )),
                    ),
                  ],
                );
        }),
      ),
    );
  }

  _item({
    required String title,
    required String svg,
    required GestureTapCallback onTap,
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(244, 244, 244, 0.996),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              svg,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: isLogout ? const Color.fromRGBO(248, 80, 80, 1) : null,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (!isLogout)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Color.fromRGBO(146, 154, 169, 1),
              )
          ],
        ),
      ),
    );
  }
}
