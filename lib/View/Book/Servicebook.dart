import 'package:app_hm/Controller/DashboardController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Servicebook extends StatelessWidget {
  const Servicebook({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Dashboardcontroller());
    return Scaffold(
      backgroundColor: ColorHex.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: 20, top: 40, right: 10, bottom: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'car_service'.tr.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Hãy đặt lịch dịch vụ cho xe của bạn một cách nhanh chóng!',
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Danh sách các lựa chọn
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _itemCard(
                    title: 'book_service'.tr,
                    svg: 'assets/icons/appointment.svg',
                    color: ColorHex.background,
                    onTap: () {
                      if (!controller.isLoggedIn.value) {
                        Get.toNamed(Routes.login);
                      } else {
                        Get.toNamed(Routes.appointmentbook);
                      }
                    },
                  ),
                  // Thêm nhiều dịch vụ khác tại đây nếu cần
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemCard({
    required String title,
    required String svg,
    required GestureTapCallback onTap,
    bool isLogout = false,
    Color color = Colors.white,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 4),
                  ],
                ),
                child: SvgPicture.asset(
                  svg,
                  width: 28,
                  height: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (!isLogout)
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: ColorHex.textContent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 20, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: ColorHex.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
