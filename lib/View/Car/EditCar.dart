import 'package:app_hm/Controller/Car/CarController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Model/Car/CarModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditCar extends StatelessWidget {
  const EditCar({super.key});
  @override
  Widget build(BuildContext context) {
    final CarModel car = Get.arguments as CarModel;
    final controller = Get.put(Carcontroller());
    controller.car = car;
    controller.setCar();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorHex.total_color,
        title: Text(
          'edit_car'.tr,
          style: const TextStyle(fontSize: 17, color: ColorHex.white),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            icon: const Icon(
              Icons.clear,
              color: ColorHex.white,
            ),
            tooltip: 'Quay lại',
            onPressed: () {
              Get.back();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('license_plate'.tr),
            _buildTextField(controller.textLicensePlate,
                hint: 'enter_license_plate'.tr),
            const SizedBox(height: 16),
            _buildLabel('name_car'.tr),
            _buildTextField(controller.textName, hint: 'enter_name_car'.tr),
            const SizedBox(height: 16),
            _buildLabel('manufacturer'.tr),
            _buildTextField(controller.textManufacturer,
                hint: 'enter_manufacture'.tr),
            const SizedBox(height: 16),
            _buildLabel('year_manufacture'.tr),
            _buildTextField(controller.textYearManufacturer,
                hint: 'enter_year_manufacture'.tr),
            const SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.updateCar();
                    //Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorHex.total_color,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('save'.tr,
                      style: const TextStyle(color: ColorHex.white)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: ColorHex.grey_shade600,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {String hint = ''}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
