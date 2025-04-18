import 'package:app_hm/Component/EmptyList.dart';
import 'package:app_hm/Controller/Appointment/AppointmentController.dart';
import 'package:app_hm/Model/Appointment/ApointmentModel.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentList extends StatelessWidget {
  const AppointmentList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Appointmentcontroller());
    return Scaffold(
      appBar: AppBar(
        title: Text('book_service'.tr,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2D74FF),
        titleSpacing: 0,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.directions_car),
        //     onPressed: () {},
        //   ),
        // ],
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.appointmentList.isEmpty) {
                return Center(
                  child: EmptyList(
                    imgSrc: 'assets/icons/empty_appoint.svg',
                    title: 'no_schedule'.tr,
                    content: 'appointment_booking_instructions'.tr,
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: controller.appointmentList.length,
                  itemBuilder: (context, index) {
                    final appointment = controller.appointmentList[index];
                    return buildAppointmentCard(appointment);
                  },
                );
              }
            }),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, bottom: 24, top: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        Get.toNamed(Routes.servicecar);
                      },
                      child: const Text(
                        'Đặt dịch vụ',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        // Xử lý chuyển sang trang lịch sử dịch vụ
                      },
                      child: const Text(
                        'Lịch sử dịch vụ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppointmentCard(AppointmentModel appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Xưởng dịch vụ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              appointment.gara_address ?? '',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              appointment.appointment_time ?? '',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
