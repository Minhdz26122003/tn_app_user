import 'package:app_hm/Component/StepBook.dart';
import 'package:app_hm/Controller/Appointment/AppointmentController.dart';
import 'package:app_hm/Controller/DashboardController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Model/Car/CarModel.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class Appointmentconfirm extends StatelessWidget {
  const Appointmentconfirm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Appointmentcontroller());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorHex.total_color,
        title: Text('book_service'.tr,
            style: const TextStyle(color: ColorHex.white)),
        elevation: 0,
        automaticallyImplyLeading: false, // Ẩn nút quay lại
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(DateFormat('HH:mm:ss').format(DateTime.now()),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: ColorHex.white)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepBook(currentStep: controller.currentStep.value),
              const SizedBox(height: 20),
              _buildTitle('license_plate'.tr, onEdit: () {
                Get.toNamed(Routes.car);
              }),
              _buildCarBox(controller),
              const SizedBox(height: 20),
              _buildTitle('contact'.tr, onEdit: () async {
                var result = await Get.toNamed(Routes.personaldetail);
                if (result == true) {
                  controller.getAccount();
                }
              }),
              _buildContactBox(controller),
              const SizedBox(height: 20),
              _buildTitle('service'.tr, onEdit: () {
                controller.currentStep.value = 1;
                controller.resetService();
                controller.navigateToStep();
              }),
              _buildServiceBox(controller),
              const SizedBox(height: 20),
              _buildTitle('address'.tr, onEdit: () {
                controller.currentStep.value = 2;
                controller.resetService();
                controller.navigateToStep();
              }),
              _buildAddressBox(controller),
              const SizedBox(height: 20),
              _buildTitle('time'.tr, onEdit: () {
                controller.currentStep.value = 3;
                controller.resetService();
                controller.navigateToStep();
              }),
              _buildTimeBox(controller),
              const SizedBox(height: 20),
              _buildButtons(controller),
            ],
          ),
        ),
      ),
    );
  }
}

// Tiêu đề
Widget _buildTitle(String title, {VoidCallback? onEdit}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: ColorHex.black),
          children: [
            TextSpan(
              text: title.toUpperCase(),
              style: TextStyle(fontSize: 16, color: ColorHex.black),
            ),
            TextSpan(
              text: ' *',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: ColorHex.status_0),
            ),
          ],
        ),
      ),
      TextButton(
        onPressed: onEdit,
        child: Text('change'.tr,
            style: const TextStyle(fontSize: 13, color: ColorHex.status_0)),
      ),
    ],
  );
}

// Hiển thị xe
Widget _buildCarBox(Appointmentcontroller controller) {
  return Obx(
    () {
      if (controller.carList.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ColorHex.grey_shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'no_car'.tr,
            style: const TextStyle(
              fontSize: 13,
              color: ColorHex.textContent,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<CarModel>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            value: controller.selectedCar.value,
            items: controller.carList.map((car) {
              return DropdownMenuItem<CarModel>(
                value: car,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(car.license_plate ?? "---",
                        style: const TextStyle(
                            color: ColorHex.black, fontSize: 13)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (car) {
              controller.selectedCar.value = car;
            },
          ),
        ],
      );
    },
  );
}

// Hiển thị thông tin liên hệ
Widget _buildContactBox(Appointmentcontroller controller) {
  return Obx(
    () => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorHex.grey_shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('full_name'.tr,
              style: const TextStyle(
                fontSize: 11,
                color: ColorHex.grey_shade600,
              )),
          Text(controller.account.value.fullname ?? 'not_updated'.tr,
              style: const TextStyle(fontSize: 13, color: ColorHex.black)),
          const SizedBox(height: 12),
          Text('phone_number'.tr,
              style: const TextStyle(
                fontSize: 11,
                color: ColorHex.grey_shade600,
              )),
          Text(controller.account.value.phonenum ?? 'not_updated'.tr,
              style: const TextStyle(fontSize: 13, color: ColorHex.black)),
          const SizedBox(height: 12),
          Text('email'.tr,
              style: const TextStyle(
                fontSize: 11,
                color: ColorHex.grey_shade600,
              )),
          Text(controller.account.value.email ?? 'not_updated'.tr,
              style: const TextStyle(fontSize: 13, color: ColorHex.black)),
        ],
      ),
    ),
  );
}

// Hiển thị thông tin dịch vụ
Widget _buildServiceBox(Appointmentcontroller controller) {
  return Obx(() {
    if (controller.selectedServices.isEmpty) {
      return Text('no_service'.tr,
          style: TextStyle(color: ColorHex.textContent));
    }
    final String typeName = controller.selectedType.value?.type_name ?? '---';
    final String servicesText = controller.selectedServices
        .map((service) => service.service_name ?? '')
        .where((name) => name.isNotEmpty)
        .join(', ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorHex.grey_shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('service_type'.tr,
              style: TextStyle(fontSize: 11, color: ColorHex.grey_shade600)),
          Text(typeName,
              style: const TextStyle(fontSize: 13, color: ColorHex.black)),
          const SizedBox(height: 10),
          Text('service'.tr,
              style: TextStyle(fontSize: 11, color: ColorHex.grey_shade600)),
          Text(servicesText,
              style: const TextStyle(fontSize: 13, color: ColorHex.black)),
        ],
      ),
    );
  });
}

// Hiển thị thông tin địa điểm
Widget _buildAddressBox(Appointmentcontroller controller) {
  return Obx(() {
    final center = controller.selectedAddress.value;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorHex.grey_shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: center == null
          ? Text('no_address'.tr, style: TextStyle(color: ColorHex.textContent))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('center_name'.tr,
                    style:
                        TextStyle(fontSize: 11, color: ColorHex.grey_shade600)),
                Text(center.gara_name ?? 'not_yet'.tr,
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 8),
                Text('address'.tr,
                    style:
                        TextStyle(fontSize: 11, color: ColorHex.grey_shade600)),
                Text(center.gara_address ?? 'not_yet'.tr,
                    style: const TextStyle(fontSize: 13)),
              ],
            ),
    );
  });
}

Widget _buildTimeBox(Appointmentcontroller controller) {
  return Obx(() {
    final hasTime = controller.selectedTime.value != null;
    final hasDate = controller.selectedDate.value != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorHex.grey_shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- NGÀY ---
          if (hasDate) ...[
            Text(
              'date'.tr,
              style: TextStyle(
                fontSize: 11,
                color: ColorHex.grey_shade600,
              ),
            ),
            Text(
              //dd/MM/yyyy
              DateFormat('dd/MM/yyyy').format(controller.selectedDate.value),
              style: const TextStyle(
                fontSize: 13,
                color: ColorHex.black,
              ),
            ),
            const SizedBox(height: 8),
          ] else ...[
            Text(
              'no_date_selected'.tr,
              style: TextStyle(color: ColorHex.grey_shade300),
            ),
            const SizedBox(height: 8),
          ],

          // --- THỜI GIAN ---
          if (hasTime) ...[
            Text(
              'time'.tr,
              style: TextStyle(
                fontSize: 11,
                color: ColorHex.grey_shade600,
              ),
            ),
            Text(
              controller.selectedTime.value!,
              style: const TextStyle(
                fontSize: 13,
                color: ColorHex.black,
              ),
            ),
          ] else ...[
            Text(
              'no_time_selected'.tr,
              style: TextStyle(color: ColorHex.grey),
            ),
          ],
        ],
      ),
    );
  });
}

// Hiển thị nút
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
                borderRadius: BorderRadius.circular(15),
              ),
              minimumSize: const Size(double.infinity, 45),
            ),
            child: Text('cancel'.tr,
                style: const TextStyle(color: ColorHex.white)),
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: controller.checkdetail
                ? () {
                    controller.nextStep();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorHex.total_color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text('book'.tr, style: TextStyle(color: ColorHex.white)),
          ),
        ),
      ),
    ],
  );
}
