import 'package:app_hm/Component/StepBook.dart';
import 'package:app_hm/Controller/Appointment/AppointmentController.dart';
import 'package:app_hm/Router/AppPage.dart';
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
        title: Text('book_service'.tr, style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2D74FF),
        elevation: 0,
        automaticallyImplyLeading: false, // Ẩn nút quay lại
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
                style: TextStyle(color: Colors.red, fontSize: 11)),
            const SizedBox(height: 12),
            _buildLabel("THỜI GIAN BẮT ĐẦU*"),
            const SizedBox(height: 8),
            _ViewTabs(controller),
            const SizedBox(height: 12),
            _ViewTimes(controller),
            const Spacer(),
            _buildButtons(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
    );
  }

  // chọn ngày
  _selectDate(BuildContext context, Appointmentcontroller controller) async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2100),
      locale: const Locale("vi", "VN"),
    );

    // if (picked != null) {
    //   if (picked.isBefore(DateTime(now.year, now.month, now.day))) {
    //     // Hiển thị thông báo nếu người dùng cố gắng chọn ngày trong quá khứ (phòng trường hợp lách giới hạn)
    //     Get.snackbar(
    //       "Lỗi",
    //       "Không thể chọn ngày trong quá khứ.",
    //       backgroundColor: Colors.redAccent,
    //       colorText: Colors.white,
    //       snackPosition: SnackPosition.TOP,
    //     );
    //   } else if (picked != controller.selectedDate.value) {
    //     controller.updateDate(picked);
    //   }
    // }
  }

  // Hiển thị ngày
  Widget _buildDateRow(BuildContext context, Appointmentcontroller controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 231, 231, 231),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month_outlined,
              color: Color.fromARGB(255, 0, 0, 0)),
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

  // Hiển thị tab sáng chiều
  Widget _ViewTabs(Appointmentcontroller controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: _buildSessionTab("Sáng", controller)),
        const SizedBox(width: 20),
        Flexible(child: _buildSessionTab("Chiều", controller)),
      ],
    );
  }

  // Widget tabtab
  Widget _buildSessionTab(String session, Appointmentcontroller controller) {
    return GestureDetector(
      onTap: () {
        controller.selectedSession.value = session;
        controller.selectedTime.value = ''; // Reset thời gian khi chuyển tab
      },
      child: Obx(() {
        final isSelected = controller.selectedSession.value == session;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF4A90E2)
                : Color.fromARGB(255, 231, 231, 231),
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

  // Hiển thị thời gian
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

  // Widget thời gian
  Widget _buildTimeSlot(String time, Appointmentcontroller controller) {
    return GestureDetector(
      onTap: () => controller.selectedTime.value = time,
      child: Obx(() {
        final isSelected = controller.selectedTime.value == time;
        return Container(
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF4A90E2)
                : Color.fromARGB(255, 231, 231, 231),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF4A90E2) : Colors.grey!,
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

  Widget _buildButtons(Appointmentcontroller controller) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () {
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
        Obx(
          () => Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: !controller.selectedTime.value.isEmpty
                    ? () {
                        controller.nextStep();
                      }
                    : null,
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
        ),
      ],
    );
  }
}
