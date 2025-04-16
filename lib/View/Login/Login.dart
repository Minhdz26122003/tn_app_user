import 'package:app_hm/Controller/Login/LoginController.dart';
import 'package:app_hm/Services/Auth.dart';
import 'package:app_hm/View/Account/ForgotPassword.dart';
import 'package:app_hm/View/Account/SendOTP.dart';
import 'package:app_hm/View/Signup/Signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
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
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'welcome'.tr,
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
                              'login'.tr,
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
                                  'account'.tr,
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                                TextField(
                                  controller: controller.textUserName,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    hintText: 'account'.tr,
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(134, 133, 133, 1)),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    border: OutlineInputBorder(),
                                  ),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 30,
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
                                        color:
                                            Color.fromRGBO(134, 133, 133, 1)),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => const Forgotpassword());
                                    },
                                    child: Text(
                                      'forgot_password'.tr,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.blue),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () => Get.to(const Signup()),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 12),
                                        children: [
                                          TextSpan(
                                            text:
                                                'You_do_not_have_an_account'.tr,
                                          ),
                                          TextSpan(
                                            text: 'sign_up'.tr,
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (!controller.isLoading.value) {
                                        controller.isLoading.value = true;

                                        await Auth.loginWithPHP(
                                            userName:
                                                controller.textUserName.text,
                                            password: controller.textPass.text);
                                        controller.isLoading.value = false;
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      alignment: Alignment.center,
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blue,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 110, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 5,
                                    ),
                                    child: Text(
                                      'login'.tr,
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
                                Center(
                                  child: Text('or'.tr),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (!controller.isLoading.value) {
                                        controller.isLoading.value = true;
                                        await Auth.loginWithFirebase();
                                        controller.isLoading.value = false;
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 130, vertical: 7),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: SvgPicture.asset(
                                        'assets/icons/google.svg',
                                        fit: BoxFit.cover),
                                  ),
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
      ),
    );
  }
}
