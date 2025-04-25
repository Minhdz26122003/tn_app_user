import 'package:app_hm/Controller/Car/CarController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_check_box_rounded/flutter_check_box_rounded.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AddCar extends StatelessWidget {
  const AddCar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Carcontroller());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorHex.total_color,
        title: Text(
          'Thêm xe ',
          style: TextStyle(fontSize: 17, color: ColorHex.white),
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
                'Cancel'.tr,
                style: TextStyle(
                  color: ColorHex.white,
                  fontSize: 13,
                ),
              ),
            ),
          ),
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
                          controller: controller.textYearManufacturer),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Positioned(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        controller.AddCar();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorHex.total_color,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 130),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required String tittle,
    required String hint,
    TextEditingController? controller,
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
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: ColorHex.grey_shade300),
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
