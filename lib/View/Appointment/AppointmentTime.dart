import 'package:app_hm/Component/StepBook.dart';
import 'package:app_hm/Controller/Appointment/AppointmentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class Appointmenttime extends StatelessWidget {
  const Appointmenttime({super.key});

  @override
  Widget build(BuildContext context) {
    final Appointmentcontroller controller = Get.put(Appointmentcontroller());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt dịch vụ'),
        backgroundColor: const Color(0xFF2D74FF),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepBook(currentStep: controller.currentStep.value),
            const SizedBox(height: 20),
            _buildLabel("NGÀY*"),
            _buildDateRow(context, controller),
            const SizedBox(height: 12),
            const Text("Bạn cần đặt lịch hẹn trước 06 tiếng",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
            const SizedBox(height: 12),
            _buildLabel("THỜI GIAN BẮT ĐẦU*"),
            const SizedBox(height: 8),
            _ViewTabs(controller),
            const SizedBox(height: 12),
            _ViewTimes(controller),
            const Spacer(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  // chọn ngày
  _selectDate(BuildContext context, Appointmentcontroller controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale("vi", "VN"),
    );
    if (picked != null && picked != controller.selectedDate.value) {
      controller.updateDate(picked);
    }
  }

  // Hiển thị ngày
  Widget _buildDateRow(BuildContext context, Appointmentcontroller controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 228, 228, 228),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Color.fromARGB(255, 0, 0, 0)),
          const SizedBox(width: 8),
          Expanded(
            child: Obx(() {
              String formattedDate = DateFormat("EEE, dd MMM yyyy", "vi")
                  .format(controller.selectedDate.value);
              return Text(
                formattedDate,
                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
              );
            }),
          ),
          TextButton(
            onPressed: () => _selectDate(context, controller),
            child: const Text("Sửa",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          ),
        ],
      ),
    );
  }

  Widget _ViewTabs(Appointmentcontroller controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSessionTab("Sáng", controller),
        const SizedBox(width: 20),
        _buildSessionTab("Chiều", controller),
      ],
    );
  }

  Widget _buildSessionTab(String session, Appointmentcontroller controller) {
    return GestureDetector(
      onTap: () {
        controller.selectedSession.value = session;
        controller.selectedTime.value = ''; // Reset thời gian khi chuyển tab
      },
      child: Obx(() {
        final isSelected = controller.selectedSession.value == session;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4A90E2) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(isSelected ? 0.3 : 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            session,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        );
      }),
    );
  }

  Widget _ViewTimes(Appointmentcontroller controller) {
    return Obx(() {
      final times = controller.selectedSession.value == 'Sáng'
          ? controller.morningTimes
          : controller.afternoonTimes;
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children:
            times.map((time) => _buildTimeSlot(time, controller)).toList(),
      );
    });
  }

  Widget _buildTimeSlot(String time, Appointmentcontroller controller) {
    return GestureDetector(
      onTap: () => controller.selectedTime.value = time,
      child: Obx(() {
        final isSelected = controller.selectedTime.value == time;
        return Container(
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4A90E2) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF4A90E2) : Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(isSelected ? 0.3 : 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              time,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildButtons() {
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
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(
                'cancel'.tr,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                final controller = Get.find<Appointmentcontroller>();
                controller.nextStep();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(
                'next'.tr,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
