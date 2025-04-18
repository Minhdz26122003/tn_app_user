import 'package:app_hm/Controller/DashboardController.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ServiceCar extends StatelessWidget {
  const ServiceCar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Dashboardcontroller());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('DỊCH VỤ XE'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _item(
                    title: 'Đặt dịch vụ',
                    svg: 'assets/icons/appointment.svg',
                    onTap: () {
                      if (!controller.isLoggedIn.value) {
                        Get.toNamed(Routes.appointmentbook);
                      } else {
                        Get.toNamed(Routes.appointmentbook);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  // _item(
                  //   title: 'Đặt dịch vụ',
                  //   svg: 'assets/icons/service.svg',
                  //   onTap: () {
                  //     if (!controller.isLoggedIn.value) {
                  //       Get.toNamed(Routes.login);
                  //     } else {
                  //       Get.toNamed(Routes.home);
                  //     }
                  //   },
                  // ),
                  // const SizedBox(height: 8),
                ],
              ),
            ),
          ],
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
          color: const Color.fromRGBO(244, 244, 244, 0.996),
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
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color.fromARGB(179, 0, 0, 0),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
