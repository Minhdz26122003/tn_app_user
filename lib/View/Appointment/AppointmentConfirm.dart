import 'package:app_hm/Component/StepBook.dart';
import 'package:app_hm/Controller/Appointment/AppointmentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Appointmentconfirm extends StatelessWidget {
  const Appointmentconfirm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Appointmentcontroller());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D74FF),
        elevation: 0,
        title: Text('book_service'.tr),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                "04:55",
                style: const TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepBook(currentStep: controller.currentStep.value),
            const SizedBox(height: 20),
            _buildSectionTitle("BIỂN SỐ XE", onEdit: () {}),
            _buildTextBox("Nhập biển số xe"),
            const SizedBox(height: 20),
            _buildSectionTitle("LIÊN HỆ*", onEdit: () {}),
            _buildContactBox(),
            const SizedBox(height: 20),
            _buildSectionTitle("DỊCH VỤ*", editText: "Thay đổi", onEdit: () {}),
            _buildServiceBox(),
            const Spacer(),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    final steps = ["Dịch vụ", "Địa điểm", "Thời gian", "Xác nhận"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(steps.length, (index) {
        final isCompleted = index < 4;
        return Column(
          children: [
            Icon(Icons.check_circle,
                color: isCompleted ? Colors.blue : Colors.grey),
            const SizedBox(height: 4),
            Text(
              steps[index],
              style: TextStyle(
                  color: isCompleted ? Colors.white : Colors.grey.shade500,
                  fontSize: 12),
            )
          ],
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title,
      {VoidCallback? onEdit, String editText = "Sửa"}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: onEdit,
          child: Text(editText, style: const TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  Widget _buildTextBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white70)),
    );
  }

  Widget _buildContactBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tên", style: TextStyle(color: Colors.grey)),
          Text("Nguyen Van A", style: TextStyle(color: Colors.white)),
          SizedBox(height: 12),
          Text("Số điện thoại", style: TextStyle(color: Colors.grey)),
          Text("+84 123 456 789", style: TextStyle(color: Colors.white)),
          SizedBox(height: 12),
          Text("Địa chỉ email", style: TextStyle(color: Colors.grey)),
          Text("abc@mail.com", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildServiceBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F2F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Bảo dưỡng", style: TextStyle(color: Colors.white)),
          Text("Brakes", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 12),
          Text("Sửa chữa chung", style: TextStyle(color: Colors.white)),
          Text("Thay dầu, sửa phanh", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () {
                final controller = Get.find<Appointmentcontroller>();
                controller.previousStep();
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child:
                  const Text("Quay lại", style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // Gửi thông tin đặt lịch
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child:
                  const Text("Đặt lịch", style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }
}
