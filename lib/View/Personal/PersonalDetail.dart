import 'package:app_hm/Controller/DashboardController.dart';
import 'package:app_hm/Controller/Personal/PersonalController.dart';
import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_check_box_rounded/flutter_check_box_rounded.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Personaldetail extends StatelessWidget {
  const Personaldetail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Personalcontroller());
    final controller2 = Get.put(Dashboardcontroller());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF2D74FF),
        title: Text('details'.tr, style: TextStyle(color: Colors.white)),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  popupTakeImage(context: context, controller: controller);
                },
                child: Obx(
                  () => Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: controller.imageFile.value.path.isNotEmpty
                              ? Image.file(
                                  controller.imageFile.value,
                                  width: 86,
                                  height: 86,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  controller2.avatar.value.isNotEmpty
                                      ? controller2.avatar.value
                                      : 'https://via.placeholder.com/150',
                                  height: 38,
                                  width: 38,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Container(
                                      height: 38,
                                      width: 38,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey,
                                      ),
                                      child: Icon(Icons.person,
                                          color: Colors.white),
                                    );
                                  },
                                )),
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle(
              'personal_information'.tr,
            ),
            _buildTextField(
                icon: Icons.person,
                hintText: 'username'.tr,
                controller: controller.textUserName),
            _buildTextField(
                icon: Icons.person,
                hintText: 'full_name'.tr,
                controller: controller.textFullName),
            _buildDateField(
                icon: Icons.calendar_today,
                hintText: 'date_of_birth'.tr,
                controller: controller.textDateOfBirth,
                isDatePicker: true),
            _buildGenderSelection(),
            _buildTextField(
                icon: Icons.phone,
                hintText: 'phone_number'.tr,
                controller: controller.textPhone),
            _buildTextField(
                icon: Icons.email,
                hintText: 'email'.tr,
                controller: controller.textEmail),
            const SizedBox(height: 16),
            _buildSectionTitle('address'.tr),
            _buildTextField(
                icon: Icons.location_on,
                hintText: 'specific_address'.tr,
                controller: controller.textAddress),
            const SizedBox(height: 16),
            _buildSectionTitle('account_information'.tr),
            _buildTextFormField(
              icon: Icons.email,
              hintText: '',
              controller: controller.textEmail,
            ),
            _buildTextFormField(
                icon: Icons.admin_panel_settings,
                hintText: '',
                controller: controller.textRole),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () async {
                  await controller.updateAccount();
                },
                child: Text('update'.tr, style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hintText,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required IconData icon,
    required String hintText,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        enabled: false, // Vô hiệu hóa field
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDateField({
    required IconData icon,
    required String hintText,
    TextEditingController? controller,
    bool isDatePicker = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: isDatePicker,
        onTap: isDatePicker
            ? () async {
                DateTime? pickedDate = await showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  controller?.text = DateFormat('dd/MM/yyyy')
                      .format(pickedDate); // hoặc định dạng khác
                }
              }
            : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    final controller = Get.find<Personalcontroller>();
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 8,
            top: 5,
            bottom: 5,
          ),
          child: Row(
            children: [
              Text('select_gender'.tr + ": ", style: TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Obx(() => CheckBoxRounded(
                    isChecked: controller.selectedGender.value == 'male'.tr,
                    onTap: (bool? value) {
                      controller.selectedGender.value = 'male'.tr;
                    },
                    borderColor: Colors.grey,
                    size: 20,
                    checkedColor: const Color.fromARGB(255, 0, 34, 255),
                  )),
              const SizedBox(width: 5),
              Text('male'.tr),
              const SizedBox(width: 10),
              Obx(() => CheckBoxRounded(
                    isChecked: controller.selectedGender.value == 'female'.tr,
                    onTap: (bool? value) {
                      controller.selectedGender.value = 'female'.tr;
                    },
                    borderColor: Colors.grey,
                    size: 20,
                    checkedColor: const Color.fromARGB(255, 0, 34, 255),
                  )),
              const SizedBox(width: 5),
              Text('female'.tr),
              const SizedBox(width: 10),
              Obx(() => CheckBoxRounded(
                    isChecked: controller.selectedGender.value == 'other'.tr,
                    onTap: (bool? value) {
                      controller.selectedGender.value = 'other'.tr;
                    },
                    borderColor: Colors.grey,
                    size: 20,
                    checkedColor: const Color.fromARGB(255, 0, 34, 255),
                  )),
              const SizedBox(width: 5),
              Text('other'.tr),
            ],
          ),
        ),
      ],
    );
  }

  popupTakeImage(
      {required BuildContext context, required Personalcontroller controller}) {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      )),
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // GestureDetector(
                //   onTap: () {
                //     Get.back();
                //     controller.getImage(1);
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.all(20),
                //     color: Colors.white,
                //     child: Row(
                //       children: [
                //         const Icon(Icons.camera_alt_rounded,
                //             color: Color.fromRGBO(55, 114, 255, 1)),
                //         const SizedBox(
                //           width: 10,
                //         ),
                //         Expanded(
                //             child: Text(
                //           'take_photo'.tr,
                //           style: const TextStyle(
                //               fontWeight: FontWeight.w500, fontSize: 14),
                //         ))
                //       ],
                //     ),
                //   ),
                // ),
                Container(
                  height: 0.2,
                  width: double.infinity,
                  color: const Color(0xff29303C),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    controller.getImage(2);
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Icon(Icons.photo_rounded,
                            color: Color.fromRGBO(55, 114, 255, 1)),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          'gallery'.tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ))
                      ],
                    ),
                  ),
                )
              ],
            )),
          ),
        );
      },
    );
  }
}
