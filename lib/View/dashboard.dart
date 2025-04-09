import 'package:app_hm/Controller/DashboardController.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Services/Auth.dart';
import 'package:app_hm/View/Account/CreatePassword.dart';
import 'package:app_hm/View/Appointment/ListAppointment.dart';
import 'package:app_hm/View/Login/Login.dart';
import 'package:app_hm/View/Personal/Personal.dart';
import 'package:app_hm/View/ServiceCar/ServiceCar.dart';
import 'package:app_hm/View/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
              // drawer: CustomDrawer(
              //   avatar: controller.avatar.value,
              //   fullName: controller.username.value,
              //   email: controller.email.value,
              // ),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0xFF2D74FF),
                title: Obx(
                  () => controller.isLoggedIn.value
                      ? Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(1),
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  shape: BoxShape.circle),
                              child: ClipOval(
                                child: Image.network(
                                  controller.avatar.value,
                                  height: 38,
                                  width: 38,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Container(
                                      height: 38,
                                      width: 38,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'welcome'.tr,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    controller.username.value,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'welcome'.tr,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              DateFormat('HH:mm:ss').format(
                                  DateTime.now()), // Hiển thị giờ hiện tại
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_rounded),
                    tooltip: 'notification'.tr,
                    onPressed: () {
                      Get.toNamed(Routes.notification);
                    },
                  )
                ],
              ),
              body: Obx(() {
                switch (controller.currentPageIndex.value) {
                  case 0:
                    return const Home();
                  case 1:
                    return const ServiceCar();
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
                                Color.fromRGBO(14, 93, 250, 1),
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
                                Color.fromRGBO(14, 93, 250, 1),
                                BlendMode.srcIn,
                              )
                            : null,
                        width: 24,
                        height: 24,
                      ),
                      label: 'service_car'.tr,
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/icons/setting.svg',
                        colorFilter: controller.currentPageIndex.value == 2
                            ? const ColorFilter.mode(
                                Color.fromRGBO(14, 93, 250, 1),
                                BlendMode.srcIn,
                              )
                            : null,
                        width: 24,
                        height: 24,
                      ),
                      label: 'setting'.tr,
                    ),
                  ],
                  currentIndex: controller.currentPageIndex.value,
                  selectedItemColor: const Color.fromRGBO(45, 116, 255, 1),
                  type: BottomNavigationBarType.fixed,
                  onTap: (value) => controller.changePage(value),
                ),
              ),
            ),
    );
  }
}
