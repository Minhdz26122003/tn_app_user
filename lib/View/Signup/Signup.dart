import 'package:app_hm/Controller/Signup/SignupController.dart';
import 'package:app_hm/Services/Auth.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:app_hm/View/Login/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Welcome'.tr,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'sign_up'.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'fullname'.tr,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        TextField(
                          controller: controller.textFullName,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            hintText: 'fullname'.tr,
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(134, 133, 133, 1)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'username'.tr,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        TextField(
                          controller: controller.textUserName,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            hintText: 'username'.tr,
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(134, 133, 133, 1)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'email'.tr,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        TextField(
                          controller: controller.textEmail,
                          onChanged: (value) {},
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'email'.tr,
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(134, 133, 133, 1)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'phone_number'.tr,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        TextField(
                          controller: controller.textPhonenum,
                          onChanged: (value) {},
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'phone_number'.tr,
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(134, 133, 133, 1)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'password'.tr,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        TextField(
                          obscureText: controller.isHidePassword.value,
                          controller: controller.textPass,
                          onChanged: (value) {},
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'password'.tr,
                            hintStyle: const TextStyle(
                                color: Color.fromRGBO(134, 133, 133, 1)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            border: const OutlineInputBorder(),
                            suffixIcon: InkWell(
                              onTap: () {
                                controller.isHidePassword.value =
                                    !controller.isHidePassword.value;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
                                    controller.isHidePassword.value
                                        ? 'assets/icons/hidden.svg'
                                        : 'assets/icons/eye_login.svg',
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'confirm_password'.tr,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        TextField(
                          obscureText: controller.isHideConfirmPassword.value,
                          controller: controller.textConfirmPass,
                          onChanged: (value) {},
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'confirm_password'.tr,
                            hintStyle: const TextStyle(
                                color: Color.fromRGBO(134, 133, 133, 1)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            border: const OutlineInputBorder(),
                            suffixIcon: InkWell(
                              onTap: () {
                                controller.isHideConfirmPassword.value =
                                    !controller.isHideConfirmPassword.value;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
                                    controller.isHideConfirmPassword.value
                                        ? 'assets/icons/hidden.svg'
                                        : 'assets/icons/eye_login.svg',
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (!controller.isLoading.value) {
                                if (controller.textPass.text !=
                                    controller.textConfirmPass.text) {
                                  Utils.showSnackBar(
                                    title: 'Thông báo',
                                    message: 'password_not_match'.tr,
                                  );
                                  return;
                                }

                                controller.isLoading.value = true;

                                // Gọi API đăng ký
                                await controller.registerWithPHP(
                                  userName: controller.textUserName.text,
                                  password: controller.textPass.text,
                                  email: controller.textEmail.text,
                                  fullName: controller.textFullName.text,
                                  phonenum: controller.textPhonenum.text,
                                );

                                controller.isLoading.value = false;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.center,
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 130, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                            ),
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'sign_up'.tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'already_have_account'.tr,
                              style: TextStyle(fontSize: 12),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(() => const Login());
                              },
                              child: Text(
                                'login_now'.tr,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
