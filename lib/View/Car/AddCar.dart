import 'package:app_hm/Controller/Car/CarController.dart';
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
        backgroundColor: const Color(0xFF2D74FF),
        title: Text(
          'Thêm xe ',
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
                'Cancel'.tr,
                style: TextStyle(
                  color: Colors.white,
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
                        backgroundColor: const Color.fromARGB(255, 6, 142, 253),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 130),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Lưu lại",
                        style: TextStyle(fontSize: 14, color: Colors.white),
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
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: [
              TextSpan(
                text: tittle,
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 18, 18, 18)),
              ),
              const TextSpan(
                text: '*',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
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
            hintStyle:
                const TextStyle(color: Color.fromARGB(255, 209, 208, 208)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 211, 210, 210), width: 0),
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
