import 'package:app_hm/Controller/Appointment/Appointmentcontroller.dart';
import 'package:app_hm/Controller/DashboardController.dart';
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
    final apct = Get.find<Appointmentcontroller>();
    return Scaffold(
      backgroundColor: ColorHex.white,
      body: Obx(() {
        return controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ClipPath(
                      clipper: _HeaderClipper(),
                      child: Container(
                        height: 250,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/header2.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          top: 60,
                          left: 16,
                          right: 16,
                          bottom: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 60,
                            ),
                            // Card login
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 5,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (!controller.isLoggedIn.value) {
                                    Get.toNamed(Routes.login);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorHex.grey_shade300,
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: ColorHex.white,
                                          child: controller.isLoggedIn.value &&
                                                  controller
                                                      .avatar.value.isNotEmpty
                                              ? Image.network(
                                                  controller.avatar.value)
                                              : const Icon(
                                                  Icons.person,
                                                  size: 20,
                                                ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('personal_information'.tr),
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
                              _item(
                                title: 'mycar'.tr,
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
                              const SizedBox(height: 20),
                              _buildSectionTitle('appointment'.tr),
                              _item(
                                title: 'list_appointment'.tr,
                                svg: 'assets/icons/appointment.svg',
                                onTap: () {
                                  if (!controller.isLoggedIn.value) {
                                    Get.toNamed(Routes.login);
                                  } else {
                                    apct.GetAppointmentList();
                                    Get.toNamed(Routes.appointmentlist);
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildSectionTitle('setting'.tr),
                              _item(
                                title: 'setting'.tr,
                                svg: 'assets/icons/setting.svg',
                                onTap: () {
                                  Get.toNamed(Routes.setting);
                                  // PushNotifications.scheduleQuickTest(
                                  //     title: 'Test 10 s',
                                  //     body: 'Bạn sẽ thấy sau 10s');
                                },
                              ),
                              const SizedBox(height: 5),
                              _item(
                                title: 'hương dan',
                                svg: 'assets/icons/setting.svg',
                                onTap: () {
                                  Get.toNamed(Routes.permissionguide);
                                },
                              ),
                              const SizedBox(height: 5),
                              if (controller.isLoggedIn.value)
                                _item(
                                  svg: 'assets/icons/logout.svg',
                                  title: 'log_out'.tr,
                                  isLogout: true,
                                  onTap: () {
                                    Auth.backLogin(true);
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
      }),
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

  Widget _item({
    required String title,
    required String svg,
    required GestureTapCallback onTap,
    bool isLogout = false,
  }) {
    return Material(
      color: const Color.fromARGB(255, 252, 252, 252),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        splashColor: Colors.grey.withOpacity(0.3),
        highlightColor: Colors.grey.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                    color: isLogout ? ColorHex.status_0 : ColorHex.black,
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
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2, size.height, // điểm điều khiển
      size.width, size.height - 50, // điểm kết thúc
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_HeaderClipper oldClipper) => false;
}
