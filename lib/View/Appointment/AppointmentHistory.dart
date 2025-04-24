import 'package:app_hm/Controller/Appointment/AppointmentController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Model/Appointment/ApointmentModel.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:get/get.dart';

class Appointmenthistory extends StatelessWidget {
  const Appointmenthistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Appointmentcontroller());

    return Scaffold(
      appBar: AppBar(
        title: Text('booking_history'.tr,
            style: const TextStyle(color: ColorHex.white, fontSize: 16)),
        backgroundColor: ColorHex.total_color,
        centerTitle: false,
        leading: const BackButton(color: ColorHex.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.appointmentList.isEmpty) {
          return Center(child: Text('book_service'.tr));
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 5),
          itemCount: controller.appointmentList.length,
          itemBuilder: (c, i) {
            final appt = controller.appointmentList[i];
            return appointmentCard(
              model: appt,
              onTap: () => Get.toNamed(Routes.appoointmentdetail,
                  arguments: {'appointment_id': appt.appointment_id}),
            );
          },
        );
      }),
    );
  }

  Widget appointmentCard({
    required AppointmentModel model,
    required VoidCallback onTap,
  }) {
    final date =
        DateTime.tryParse(model.appointment_time ?? '') ?? DateTime.now();

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Row(
          children: [
            // Phần date box
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: const BoxDecoration(
                color: ColorHex.border_5,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 24,
                      color: ColorHex.disableplace,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'month'.tr + '${date.month}',
                    style: TextStyle(fontSize: 15, color: ColorHex.white),
                  ),
                ],
              ),
            ),
            // Nội dung bên phải
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.gara_name ?? 'not_yet'.tr,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/clock.svg',
                          color: ColorHex.textContent,
                          width: 16,
                          height: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          model.appointment_time ?? 'not_yet'.tr,
                          style: TextStyle(
                              fontSize: 14, color: ColorHex.grey_shade600),
                        ),
                      ],
                    ),
                    Text(
                      'ấn vào để xem chi tiết >',
                      style: TextStyle(fontSize: 11, color: ColorHex.status_0),
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
}
