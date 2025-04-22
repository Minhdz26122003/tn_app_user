import 'package:app_hm/Controller/Appointment/AppointmentController.dart';
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
        title: Text('Danh sách dịch vụ', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2D74FF),
        centerTitle: false,
        leading: BackButton(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.appointmentList.isEmpty) {
          return Center(child: Text("Chưa có lịch hẹn nào"));
        }
        return ListView.builder(
          padding:
              EdgeInsets.only(top: 100), // Sửa lỗi cú pháp 'custom' thành 'top'
          itemCount: controller.appointmentList.length,
          itemBuilder: (c, i) {
            final appt = controller.appointmentList[i];
            return appointmentCard(
              model: appt,
              onTap: () => Get.toNamed('/detail', arguments: appt),
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
                backgroundColor: Color(0xFF2D74FF),
                minimumSize: Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Get.toNamed('/book'),
              child: Text("Đặt dịch vụ", style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.appointmenthistory),
              child: Text(
                "Lịch sử dịch vụ",
                style: TextStyle(
                  color: Color(0xFF2D74FF),
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
    // Xử lý an toàn việc phân tích ngày
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
                color: Color(0xFF2D74FF),
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
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tháng ${date.month}',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
            // Nội dung bên phải
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.gara_name ?? 'Unknown Garage',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      model.appointment_time ?? 'No Time',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
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
