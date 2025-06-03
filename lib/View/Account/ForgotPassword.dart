import 'package:app_hm/Controller/Login/LoginController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Forgotpassword extends StatelessWidget {
  const Forgotpassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_outlined),
              onPressed: () {
                Get.back();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, right: 30, bottom: 30, left: 30),
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'forgot_password'.tr,
                      style: const TextStyle(
                        color: ColorHex.total_color,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'we_send_password'.tr,
                      style:
                          const TextStyle(color: ColorHex.black, fontSize: 13),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'email'.tr,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.start,
                    ),
                    TextField(
                      controller: controller.textEmail,
                      onChanged: (value) {
                        controller.isButtonDisabled.value = value.isEmpty;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        hintText: 'email'.tr,
                        hintStyle: const TextStyle(color: ColorHex.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        border: const OutlineInputBorder(),
                      ),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: controller.isButtonDisabled.value
                            ? null
                            : () {
                                controller.sendEmail();
                              },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: ColorHex.white,
                          backgroundColor: controller.isButtonDisabled.value
                              ? ColorHex.selectplace
                              : ColorHex.total_color,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          'send_link'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      }),
    );
  }
}
