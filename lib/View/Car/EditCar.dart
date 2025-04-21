import 'package:app_hm/Controller/Car/CarController.dart';
import 'package:app_hm/Model/Car/CarModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
        backgroundColor: const Color(0xFF2D74FF),
        title: const Text(
          'Chỉnh sửa xe',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Text(
                "Hủy",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Biển số'),
            _buildTextField(controller.textLicensePlate,
                hint: 'Nhập biển số xe'),
            const SizedBox(height: 16),
            _buildLabel('Tên xe'),
            _buildTextField(controller.textName, hint: 'Nhập tên xe'),
            const SizedBox(height: 16),
            _buildLabel('Hãng sản xuất'),
            _buildTextField(controller.textManufacturer,
                hint: 'Nhập hãng sản xuất'),
            const SizedBox(height: 16),
            _buildLabel('Năm sản xuất'),
            _buildTextField(controller.textYearManufacturer,
                hint: 'Nhập năm sản xuất'),
            const SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    controller.updateCar();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF068EFF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Lưu lại",
                      style: TextStyle(color: Colors.white)),
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
        color: Color(0xFF4B4B4B),
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
