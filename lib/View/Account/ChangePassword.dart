import 'package:app_hm/Controller/Personal/PersonalController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Changepassword extends StatelessWidget {
  const Changepassword({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Personalcontroller());
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
        width: MediaQuery.of(context).size.width, // Chiều rộng màn hình
        height: MediaQuery.of(context).size.height,

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Text(
                    'change_password'.tr,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'validate_password'.tr,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
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
                          'old_password'.tr,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        TextField(
                          controller: controller.textPasswordOld,
                          obscureText: controller.isHidePasswordOld.value,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            hintText: 'old_password'.tr,
                            hintStyle: const TextStyle(
                                color: Color.fromRGBO(134, 133, 133, 1)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            border: const OutlineInputBorder(),
                            suffixIcon: InkWell(
                              onTap: () {
                                controller.isHidePasswordOld.value =
                                    !controller.isHidePasswordOld.value;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
                                    controller.isHidePasswordOld.value
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
                          height: 30,
                        ),
                        Text(
                          'new_password'.tr,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        TextField(
                          controller: controller.textPasswordNew,
                          obscureText: controller.isHidePasswordNew.value,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            hintText: 'new_password'.tr,
                            hintStyle: const TextStyle(
                                color: Color.fromRGBO(134, 133, 133, 1)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            border: const OutlineInputBorder(),
                            suffixIcon: InkWell(
                              onTap: () {
                                controller.isHidePasswordNew.value =
                                    !controller.isHidePasswordNew.value;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
                                    controller.isHidePasswordNew.value
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
                          height: 30,
                        ),
                        Text(
                          'confirm_password'.tr,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        TextField(
                          obscureText: controller.isHidePasswordConfirm.value,
                          controller: controller.textPasswordConfirm,
                          onChanged: (value) {},
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            hintText: 'confirm_password'.tr,
                            hintStyle: const TextStyle(
                                color: Color.fromRGBO(134, 133, 133, 1)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            border: const OutlineInputBorder(),
                            suffixIcon: InkWell(
                              onTap: () {
                                controller.isHidePasswordConfirm.value =
                                    !controller.isHidePasswordConfirm.value;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
                                    controller.isHidePasswordConfirm.value
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
                          height: 10,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () async {
                              controller.changePassword();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 110, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              'change_password'.tr,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
    );
  }
}
