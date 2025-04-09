import 'package:app_hm/Controller/DashboardController.dart';
import 'package:app_hm/Controller/Personal/PersonalController.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Personal extends StatelessWidget {
  const Personal({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Dashboardcontroller());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Obx(() {
          return controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 5),
                      child: GestureDetector(
                        onTap: () {
                          if (!controller.isLoggedIn.value) {
                            Get.toNamed(Routes.login);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.grey[300],
                                  child: controller.isLoggedIn.value &&
                                          controller.avatar.value.isNotEmpty
                                      ? Image.network(controller.avatar.value)
                                      : const Icon(Icons.person,
                                          size: 24, color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.isLoggedIn.value
                                        ? controller.username.value
                                        : 'login'.tr,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  if (controller.isLoggedIn.value)
                                    Text(
                                      controller.email.value,
                                      style: const TextStyle(
                                        color: Color.fromRGBO(119, 126, 144, 1),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildSectionTitle('personal'.tr),
                            _item(
                              title: 'personal_information'.tr,
                              svg: 'assets/icons/profile.svg',
                              onTap: () {
                                if (!controller.isLoggedIn.value) {
                                  Get.toNamed(Routes.login);
                                } else {
                                  Get.toNamed(Routes.personaldetail);
                                }
                              },
                            ),
                            const SizedBox(height: 5),
                            if (controller.loginMethod.value !=
                                LoginMethod.firebase) ...[
                              _item(
                                title: 'change_password'.tr,
                                svg: 'assets/icons/security.svg',
                                onTap: () {
                                  if (!controller.isLoggedIn.value) {
                                    Get.toNamed(Routes.login);
                                  } else {
                                    Get.toNamed(Routes.changepassword);
                                  }
                                },
                              ),
                            ],
                            _buildSectionTitle('appointment'.tr),
                            const SizedBox(height: 5),
                            _item(
                              title: 'Quản lý lịch hẹn',
                              svg: 'assets/icons/appointment.svg',
                              onTap: () {
                                if (!controller.isLoggedIn.value) {
                                  Get.toNamed(Routes.login);
                                } else {
                                  Get.toNamed(Routes.listappointment);
                                }
                              },
                            ),
                            _buildSectionTitle('setting_app'.tr),
                            const SizedBox(height: 5),
                            _item(
                              title: 'setting_all'.tr,
                              svg: 'assets/icons/setting.svg',
                              onTap: () {
                                Get.toNamed(Routes.setting);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (controller.isLoggedIn.value)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: _item(
                          svg: 'assets/icons/logout.svg',
                          title: 'log_out'.tr,
                          isLogout: true,
                          onTap: () {
                            Auth.backLogin(true);
                          },
                        ),
                      ),
                  ],
                );
        }),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, top: 10),
        child: Text(
          title.toUpperCase(),
          textAlign: TextAlign.left,
          style: const TextStyle(
            color: Color.fromARGB(179, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
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
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
