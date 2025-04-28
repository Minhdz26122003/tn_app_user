import 'package:app_hm/Controller/DashboardController.dart';
import 'package:app_hm/Controller/Personal/PersonalController.dart';
import 'package:app_hm/Global/ColorHex.dart';
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
      backgroundColor: ColorHex.white,
      // Thay container đỏ bằng AppBar
      appBar: AppBar(
        title: Text('Cá nhân'.tr),
        backgroundColor: const Color(0xFFFF0000), // Màu đỏ
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Obx(() {
          return controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    // Avatar và thông tin người dùng
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 5),
                      child: GestureDetector(
                        onTap: () {
                          if (!controller.isLoggedIn.value) {
                            Get.toNamed(Routes.login);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: ColorHex.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: ColorHex.grey.withOpacity(0.5),
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
                                  backgroundColor: ColorHex.grey_shade300,
                                  child: controller.isLoggedIn.value &&
                                          controller.avatar.value.isNotEmpty
                                      ? Image.network(controller.avatar.value)
                                      : const Icon(
                                          Icons.person,
                                          size: 24,
                                          color: ColorHex.white,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.isLoggedIn.value
                                          ? controller.username.value
                                          : 'Đăng nhập'.tr,
                                      style: const TextStyle(
                                        color: ColorHex.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    if (controller.isLoggedIn.value)
                                      Text(
                                        controller.email.value,
                                        style: const TextStyle(
                                          color: ColorHex.textContent,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Danh sách các mục
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Thông tin cá nhân'.tr),
                            _item(
                              title: 'Thông tin cá nhân'.tr,
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
                            _item(
                              title: 'Xe của tôi'.tr,
                              svg: 'assets/icons/car.svg',
                              onTap: () {
                                if (!controller.isLoggedIn.value) {
                                  Get.toNamed(Routes.login);
                                } else {
                                  Get.toNamed(Routes.car);
                                }
                              },
                            ),
                            const SizedBox(height: 5),
                            if (controller.loginMethod.value !=
                                LoginMethod.firebase)
                              _item(
                                title: 'Đổi mật khẩu'.tr,
                                svg: 'assets/icons/security.svg',
                                onTap: () {
                                  if (!controller.isLoggedIn.value) {
                                    Get.toNamed(Routes.login);
                                  } else {
                                    Get.toNamed(Routes.changepassword);
                                  }
                                },
                              ),
                            const SizedBox(height: 20),
                            _buildSectionTitle('Lịch hẹn'.tr),
                            _item(
                              title: 'Danh sách lịch hẹn'.tr,
                              svg: 'assets/icons/appointment.svg',
                              onTap: () {
                                if (!controller.isLoggedIn.value) {
                                  Get.toNamed(Routes.login);
                                } else {
                                  Get.toNamed(Routes.appointmentlist);
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildSectionTitle('Cài đặt'.tr),
                            _item(
                              title: 'Cài đặt chung'.tr,
                              svg: 'assets/icons/setting.svg',
                              onTap: () {
                                Get.toNamed(Routes.setting);
                              },
                            ),
                            const SizedBox(height: 5),
                            if (controller.isLoggedIn.value)
                              _item(
                                svg: 'assets/icons/logout.svg',
                                title: 'Đăng xuất'.tr,
                                isLogout: true,
                                onTap: () {
                                  Auth.backLogin(true);
                                },
                              ),
                          ],
                        ),
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
            color: ColorHex.black,
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
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: ColorHex.disableplace,
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
                  color: isLogout ? ColorHex.status_0 : null,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (!isLogout)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: ColorHex.textContent,
              )
          ],
        ),
      ),
    );
  }
}
