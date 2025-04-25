import 'package:app_hm/Controller/Appointment/Appointmentcontroller.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Model/Appointment/ApointmentModel.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Appointmentlist extends StatelessWidget {
  const Appointmentlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Appointmentcontroller());

    return Scaffold(
      appBar: AppBar(
        title: Text('list_appointment'.tr,
            style: TextStyle(color: ColorHex.white, fontSize: 17)),
        backgroundColor: ColorHex.total_color,
        centerTitle: false,
        leading: BackButton(color: ColorHex.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.appointmentList.isEmpty) {
          return Center(child: Text('book_service'.tr));
        }
        return ListView.builder(
          padding: EdgeInsets.only(top: 5),
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
      bottomSheet: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorHex.total_color,
                minimumSize: Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Get.toNamed(Routes.appointmentbook),
              child: Text('book'.tr,
                  style: TextStyle(fontSize: 16, color: ColorHex.white)),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.appointmenthistory),
              child: Text(
                'booking_history'.tr,
                style: TextStyle(
                  color: ColorHex.status_0,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
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
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Row(
          children: [
            // Phần date box
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
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
