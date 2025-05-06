import 'package:app_hm/Controller/DashboardController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/View/Personal/Personal.dart';
import 'package:app_hm/View/Book/Servicebook.dart';
import 'package:app_hm/View/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Dashboardcontroller());
    return Obx(
      () => controller.isLoading.value
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              key: controller.scaffoldKey,
              body: Obx(() {
                switch (controller.currentPageIndex.value) {
                  case 0:
                    return const Home();
                  case 1:
                    return const Servicebook();
                  case 2:
                    return const Personal();

                  default:
                    return const Home();
                }
              }),
              bottomNavigationBar: Obx(
                () => BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/icons/home.svg',
                        colorFilter: controller.currentPageIndex.value == 0
                            ? const ColorFilter.mode(
                                ColorHex.total_color,
                                BlendMode.srcIn,
                              )
                            : null,
                      ),
                      label: 'home'.tr,
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/icons/service.svg',
                        colorFilter: controller.currentPageIndex.value == 1
                            ? const ColorFilter.mode(
                                ColorHex.total_color,
                                BlendMode.srcIn,
                              )
                            : null,
                        width: 24,
                        height: 24,
                      ),
                      label: 'car_service'.tr,
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/icons/profile.svg',
                        colorFilter: controller.currentPageIndex.value == 2
                            ? const ColorFilter.mode(
                                ColorHex.total_color,
                                BlendMode.srcIn,
                              )
                            : null,
                        width: 24,
                        height: 24,
                      ),
                      label: 'personal'.tr,
                    ),
                  ],
                  currentIndex: controller.currentPageIndex.value,
                  selectedItemColor: ColorHex.applyColor,
                  type: BottomNavigationBarType.fixed,
                  onTap: (value) => controller.changePage(value),
                ),
              ),
            ),
    );
  }
}
