import 'package:app_hm/Controller/Login/LoginController.dart';
import 'package:app_hm/View/Account/CreatePassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Sentotp extends StatelessWidget {
  const Sentotp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, right: 30, bottom: 30, left: 30),
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/email.svg',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(height: 30),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                          color: Colors.black, fontSize: 13), // Định dạng chung
                      children: [
                        TextSpan(
                          text: 'we_send_password'.tr,
                        ),
                        TextSpan(
                          text: controller.textEmail.text,
                          style: const TextStyle(
                              color: Colors.blue), // Màu cho phần email
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text('otp_code'.tr,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.start),
                  TextField(
                    controller: controller.textOTP,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      controller.isButtonDisabled.value = value.isEmpty;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.shield_outlined),
                      hintText: 'otp_code'.tr,
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(134, 133, 133, 1)),
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
                              controller.enterOTP();
                            },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: controller.isButtonDisabled.value
                            ? const Color.fromARGB(255, 146, 192, 237)
                            : Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 115, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'confirm'.tr,
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
      ),
    );
  }
}
