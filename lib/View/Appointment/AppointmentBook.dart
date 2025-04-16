import 'package:app_hm/Component/StepBook.dart';
import 'package:app_hm/Controller/Appointment/AppointmentController.dart';
import 'package:app_hm/Model/Service/TypeServiceModel.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AppointmentBook extends StatelessWidget {
  const AppointmentBook({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Appointmentcontroller());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('book_service'.tr, style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF2D74FF),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            StepBook(currentStep: controller.currentStep.value),
            const SizedBox(height: 15),

            _buildTitle('select_service_type'.tr),
            // Danh sách loại dịch vụ
            Obx(
              () {
                if (controller.typeList.isEmpty) {
                  return Text(
                    'no_service_type'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<TypeServiceModel>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      value: controller.selectedType.value,
                      items: controller.typeList.map((type) {
                        return DropdownMenuItem<TypeServiceModel>(
                          value: type,
                          child: Text(type.type_name ?? "---"),
                        );
                      }).toList(),
                      onChanged: (type) {
                        controller.selectedType.value = type;
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 15),

            // Mô tả dịch vụ
            _buildAddDescription(controller, context),

            _buildTitle('select_service'.tr),
            // Danh sách dịch vụ theo loại
            Obx(() {
              if (controller.selectedType.value == null) {
                return Text(
                  'select_service_type_first'.tr,
                  style: TextStyle(fontSize: 14, color: Colors.red),
                );
              }
              final filteredServices = controller.serviceList
                  .where((s) =>
                      s.type_id == controller.selectedType.value!.type_id)
                  .toList();

              if (filteredServices.isEmpty) {
                return Text(
                  'no_services_of_type'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Text(
                      'selected'.tr +
                          "${controller.checkedValuesService.where((e) => e).length}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Colors.grey),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredServices.length,
                    itemBuilder: (context, index) {
                      final service = filteredServices[index];
                      final realIndex = controller.serviceList.indexOf(service);

                      return Column(
                        children: [
                          CheckboxListTile(
                            value: controller.checkedValuesService[realIndex],
                            onChanged: (bool? value) {
                              controller.checkedValuesService[realIndex] =
                                  value!;
                            },
                            title: Text(
                              service.service_name ?? '---',
                              style: const TextStyle(fontSize: 14),
                            ),
                            controlAffinity: ListTileControlAffinity.trailing,
                            activeColor: Colors.blue,
                          ),
                          const Divider(height: 1, color: Colors.grey),
                        ],
                      );
                    },
                  ),
                ],
              );
            }),
            const SizedBox(height: 15),

            Obx(() {
              return SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.hasSelectedService
                      ? () {
                          controller.nextStep();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    'next'.tr,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text(
          title.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _buildAddDescription(Appointmentcontroller controller, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle('detail_service'.tr),
        GestureDetector(
          onTap: () {
            _showDescriptionDialog(controller, context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFF5F5F5),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.add, color: Colors.blue),
                Text('add_description'.tr,
                    style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Obx(() {
          return Text(
            controller.description.value.isNotEmpty
                ? controller.description.value
                : '',
            style: TextStyle(fontSize: 16),
          );
        }),
        SizedBox(height: 20),
      ],
    );
  }

  void _showDescriptionDialog(Appointmentcontroller controller, context) {
    showDialog(
      context: context,
      builder: (_) => SafeArea(
        child: AlertDialog(
          title: Text('add_description'.tr),
          content: TextField(
            controller: controller.descriptionController,
            maxLines: 1,
            decoration: InputDecoration(hintText: 'enter_description'.tr),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () {
                controller.description.value =
                    controller.descriptionController.text;
                Navigator.pop(context);
              },
              child: Text('confirm'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
