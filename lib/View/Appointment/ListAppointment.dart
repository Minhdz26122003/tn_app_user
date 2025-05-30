import 'package:app_hm/Component/EmptyList.dart';
import 'package:app_hm/Controller/Appointment/Appointmentcontroller.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Model/Appointment/ApointmentModel.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Appointmentlist extends StatelessWidget {
  const Appointmentlist();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Appointmentcontroller>();
    return Scaffold(
      appBar: AppBar(
        title: Text('list_appointment'.tr,
            style: const TextStyle(color: ColorHex.white, fontSize: 17)),
        backgroundColor: ColorHex.total_color,
        centerTitle: false,
        //leading: const BackButton(color: Colors.white),
        leading: GestureDetector(
          onTap: () {
            Get.offAndToNamed(Routes.personal);
          },
          child: const Icon(Icons.arrow_back, color: ColorHex.white),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.pendingAppointments.isEmpty) {
          return Center(
            child: EmptyList(
              imgSrc: 'assets/icons/empty_appoint.svg',
              title: 'Không có lịch hẹn nào',
              content: 'appointment_booking_instructions'.tr,
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 5),
          itemCount: controller.pendingAppointments.length,
          itemBuilder: (c, i) {
            final appt = controller.pendingAppointments[i];
            return appointmentCard(
              model: appt,
              onTap: () async {
                // Nếu status = 5 thì load settlement trước
                if (appt.status == 5) {
                  if (appt.appointment_id != null) {
                    await controller.getSettlementUser(appt.appointment_id!);
                  }
                }
                // Sau đó mới navigate sang trang chi tiết
                Get.toNamed(
                  Routes.appoointmentdetail,
                  arguments: {'appointment_id': appt.appointment_id},
                );
              },
            );
          },
        );
      }),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorHex.total_color,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Get.toNamed(Routes.appointmentbook),
              child: Text('book'.tr,
                  style: const TextStyle(fontSize: 16, color: ColorHex.white)),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.appointmenthistory),
              child: Text(
                'booking_history'.tr,
                style: const TextStyle(
                  color: ColorHex.status_0,
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
    final date = DateTime.tryParse(model.appointment_date!) ?? DateTime.now();
    // Trạng thái
    final status = model.currentStatusIndex;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Row(
          children: [
            // Date box
            Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 12),
              decoration: const BoxDecoration(
                color: ColorHex.status_update_vote_5,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${date.day}',
                    style: const TextStyle(
                      fontSize: 24,
                      color: ColorHex.disableplace,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${'month'.tr}${date.month}',
                    style: const TextStyle(fontSize: 15, color: ColorHex.white),
                  ),
                ],
              ),
            ),
            // Nội dung bên phải
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.gara_name ?? 'not_yet'.tr,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/clock.svg',
                          color: ColorHex.textContent,
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(model.appointment_time ?? 'not_yet'.tr,
                            style:
                                const TextStyle(color: ColorHex.grey_shade600)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.car_crash_outlined,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          Utils.steps[status].tr,
                          style: const TextStyle(
                              color: ColorHex.status_0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Text(
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
