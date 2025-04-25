import 'package:app_hm/Controller/Appointment/Appointmentcontroller.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Model/Appointment/ApointmentModel.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Appointmenthistory extends StatelessWidget {
  const Appointmenthistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Appointmentcontroller>();

    return Scaffold(
      appBar: AppBar(
        title: Text('booking_history'.tr,
            style: const TextStyle(color: Colors.white, fontSize: 17)),
        backgroundColor: ColorHex.total_color,
        leading: const BackButton(color: Colors.white),
      ),
      backgroundColor: ColorHex.background,
      body: Obx(() {
        final list = controller.appointmentList;
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (list.isEmpty) {
          return Center(child: Text('no_history'.tr));
        }

        // 1) Nhóm theo month/year
        final Map<String, List<AppointmentModel>> groups = {};
        for (var appt in list) {
          final dt =
              DateTime.tryParse(appt.appointment_date!) ?? DateTime.now();
          final key = DateFormat('MM/yyyy').format(dt);
          groups.putIfAbsent(key, () => []).add(appt);
        }

        final children = <Widget>[];
        final sortedKeys = groups.keys.toList()
          ..sort((a, b) {
            final da = DateFormat('MM/yyyy').parse(a);
            final db = DateFormat('MM/yyyy').parse(b);
            return db.compareTo(da);
          });

        for (var key in sortedKeys) {
          final parts = key.split('/');
          final month = int.parse(parts[0]);
          final year = parts[1];
          children.add(
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
              child: Text(
                '${'month'.tr} $month, $year',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ColorHex.black,
                ),
              ),
            ),
          );

          for (var appt in groups[key]!) {
            children.add(_historyCard(appt));
          }
        }

        return ListView(
          padding: EdgeInsets.zero,
          children: children,
        );
      }),
    );
  }

  Widget _historyCard(AppointmentModel m) {
    final date = DateTime.tryParse(m.appointment_date!) ?? DateTime.now();

    // Trạng thái
    final status = m.currentStatusIndex;
    final isCancelled = status == 7; // hủy
    final isCompleted = status == 6; // hthanh
    final icon = isCompleted
        ? Icons.check_circle
        : isCancelled
            ? Icons.cancel
            : Icons.hourglass_bottom;
    final statusText = isCompleted
        ? 'completed'.tr
        : isCancelled
            ? 'cancelled'.tr
            : Utils.steps[status].tr;

    final statusColor = isCompleted
        ? ColorHex.border_5
        : isCancelled
            ? ColorHex.status_0
            : ColorHex.status_1;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: ColorHex.grey_shade300,
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.appoointmentdetail,
              arguments: {'appointment_id': m.appointment_id});
        },
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Date box
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: ColorHex.status_1,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.gara_name ?? 'not_yet'.tr,
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
                        Text(m.appointment_time ?? 'not_yet'.tr,
                            style:
                                const TextStyle(color: ColorHex.grey_shade600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(icon, size: 16, color: statusColor),
                        const SizedBox(width: 6),
                        Text(
                          statusText,
                          style: TextStyle(
                              color: statusColor, fontWeight: FontWeight.bold),
                        ),
                      ],
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
