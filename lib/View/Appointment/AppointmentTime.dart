import 'package:app_hm/Component/StepBook.dart';
import 'package:app_hm/Controller/Appointment/Appointmentcontroller.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Appointmenttime extends StatelessWidget {
  const Appointmenttime({super.key});

  @override
  Widget build(BuildContext context) {
    final Appointmentcontroller controller = Get.put(Appointmentcontroller());
    return Scaffold(
      appBar: AppBar(
        title: Text('book_service'.tr,
            style: const TextStyle(color: ColorHex.white, fontSize: 17)),
        backgroundColor: ColorHex.total_color,
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
            _buildLabel('select_date'.tr),
            const SizedBox(height: 8),
            _buildDateRow(context, controller),
            const SizedBox(height: 12),
            Text('book_6h_in_advance'.tr,
                style: const TextStyle(color: ColorHex.status_0, fontSize: 11)),
            const SizedBox(height: 12),
            _buildLabel('start_time'.tr),
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
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text.toUpperCase(),
            style: const TextStyle(
                fontSize: 16,
                color: ColorHex.black,
                fontWeight: FontWeight.bold),
          ),
          const TextSpan(
            text: ' *',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: ColorHex.status_0),
          ),
        ],
      ),
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
    if (picked != null) {
      controller.updateDate(picked);
      controller.selectedTime.value = '';
    }
  }

  // Hiển thị ngày
  Widget _buildDateRow(BuildContext context, Appointmentcontroller controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorHex.grey_shade300,
        border: Border.all(color: ColorHex.grey, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month_outlined, color: ColorHex.black),
          const SizedBox(width: 8),
          Expanded(
            child: Obx(() {
              String formattedDate = DateFormat("EEE, dd MMM yyyy", "vi")
                  .format(controller.selectedDate.value);
              return Text(
                formattedDate,
                style: const TextStyle(color: ColorHex.black),
              );
            }),
          ),
          TextButton(
            onPressed: () => _selectDate(context, controller),
            child:
                Text('edit'.tr, style: const TextStyle(color: ColorHex.black)),
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
        Flexible(child: _buildSessionTab('morning'.tr, controller)),
        const SizedBox(width: 20),
        Flexible(child: _buildSessionTab('afternoon'.tr, controller)),
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
            color: isSelected ? ColorHex.total_color : ColorHex.grey_shade300,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? ColorHex.total_color : ColorHex.grey_shade300,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorHex.grey.withOpacity(isSelected ? 0.3 : 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            session,
            style: TextStyle(
              color: isSelected ? ColorHex.white : ColorHex.black,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        );
      }),
    );
  }

  // Widget hiển thị thời gian
  Widget _ViewTimes(Appointmentcontroller controller) {
    return Obx(() {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: controller.slots
            .map((slot) => _buildTimeSlot(slot, controller))
            .toList(),
      );
    });
  }

  // Widget cho từng time slot
  Widget _buildTimeSlot(TimeSlot slot, Appointmentcontroller controller) {
    final bool isEnabled = !slot.isPast && !slot.isBooked;
    Color bg, fg, borderColor;

    if (slot.isSelected) {
      bg = ColorHex.total_color;
      fg = Colors.white;
      borderColor = ColorHex.total_color;
    } else if (slot.isBooked) {
      bg = ColorHex.grey_shade300;
      fg = ColorHex.grey;
      borderColor = ColorHex.grey;
    } else if (slot.isPast) {
      bg = ColorHex.grey;
      fg = ColorHex.grey_shade600;
      borderColor = ColorHex.grey_shade400;
    } else {
      bg = Colors.white;
      fg = Colors.black;
      borderColor = ColorHex.grey_shade400;
    }

    return GestureDetector(
      onTap: isEnabled ? () => controller.pickTime(slot.label) : null,
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              slot.label,
              style: TextStyle(color: fg),
            ),
            if (slot.isBooked) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.lock,
                size: 16,
                color: fg,
              ),
            ],
          ],
        ),
      ),
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
                backgroundColor: ColorHex.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(
                'cancel'.tr,
                style: const TextStyle(fontSize: 16, color: ColorHex.white),
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
                onPressed: controller.selectedTime.value.isNotEmpty
                    ? () {
                        controller.nextStep();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorHex.total_color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  'next'.tr,
                  style: const TextStyle(fontSize: 16, color: ColorHex.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
