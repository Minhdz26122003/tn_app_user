import 'package:app_hm/Controller/Car/CarController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddCar extends StatelessWidget {
  const AddCar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Carcontroller());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorHex.total_color,
        title: const Text(
          'Thêm xe ',
          style: TextStyle(fontSize: 17, color: ColorHex.white),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      buildTextField(
                          tittle: "Nhập biển số xe",
                          hint: "Vd: 34A9 12345",
                          controller: controller.textLicensePlate),
                      const SizedBox(
                        height: 12,
                      ),
                      //
                      buildTextField(
                          tittle: "Nhập tên xe",
                          hint: "Vd: Mazda CX5",
                          controller: controller.textName),
                      const SizedBox(
                        height: 12,
                      ),
                      //
                      buildTextField(
                          tittle: "Nhập hãng xe",
                          hint: "Vd: Mazda",
                          controller: controller.textManufacturer),
                      const SizedBox(
                        height: 12,
                      ),

                      //
                      buildTextField(
                          tittle: "Nhập năm sản xuất xe",
                          hint: "Vd: 2011",
                          controller: controller.textYearManufacturer,
                          keyboardType:
                              TextInputType.number, // Chỉ cho phép bàn phím số
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly // Chỉ cho phép nhập số
                          ]),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller.AddCar();
                      //Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorHex.total_color,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Lưu lại",
                      style: TextStyle(fontSize: 14, color: ColorHex.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Thêm các tham số mới vào hàm buildTextField
  Widget buildTextField({
    required String tittle,
    required String hint,
    TextEditingController? controller,
    TextInputType? keyboardType, // Thêm tham số này
    List<TextInputFormatter>? inputFormatters, // Thêm tham số này
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: ColorHex.black),
            children: [
              TextSpan(
                text: tittle,
                style: const TextStyle(fontSize: 16, color: ColorHex.black),
              ),
              const TextSpan(
                text: '*',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorHex.status_0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType, // Sử dụng tham số keyboardType
          inputFormatters: inputFormatters, // Sử dụng tham số inputFormatters
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: ColorHex.grey_shade600),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: ColorHex.grey_shade300, width: 0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        )
      ],
    );
  }
}
