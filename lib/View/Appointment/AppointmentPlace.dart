import 'package:app_hm/Component/StepBook.dart';
import 'package:app_hm/Controller/Appointment/Appointmentcontroller.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class Appointmentplace extends StatelessWidget {
  const Appointmentplace({super.key});

  @override
  Widget build(BuildContext context) {
    final Appointmentcontroller controller = Get.put(Appointmentcontroller());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'book_service'.tr,
          style: const TextStyle(color: ColorHex.white, fontSize: 17),
        ),
        backgroundColor: ColorHex.total_color,
        automaticallyImplyLeading: false, // Ẩn nút quay lại
      ),
      body: Obx(() => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                StepBook(currentStep: controller.currentStep.value),
                const SizedBox(height: 16),
                Expanded(child: _buildLocationList()),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            final controller =
                                Get.find<Appointmentcontroller>();
                            controller.previousStep();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorHex.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: const Size(double.infinity, 45),
                          ),
                          child: Text(
                            'cancel'.tr,
                            style: const TextStyle(
                                fontSize: 16, color: ColorHex.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: controller.selectedAddress.value != null
                              ? () {
                                  controller.nextStep();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorHex.total_color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            minimumSize: const Size(double.infinity, 45),
                          ),
                          child: Text(
                            'next'.tr,
                            style: const TextStyle(
                                fontSize: 16, color: ColorHex.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildLocationList() {
    final controller = Get.find<Appointmentcontroller>();
    return Obx(() => ListView.builder(
          itemCount: controller.centerList.length,
          itemBuilder: (context, index) {
            final loc = controller.centerList[index];
            final isSelected = controller.selectedAddress.value == loc;
            return GestureDetector(
              onTap: () {
                if (controller.selectedAddress.value == loc) {
                  controller.selectedAddress.value = null;
                } else {
                  controller.selectedAddress.value = loc;
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      isSelected ? ColorHex.selectplace : ColorHex.disableplace,
                  borderRadius: BorderRadius.circular(15),
                  border: isSelected
                      ? Border.all(color: ColorHex.total_color, width: 2)
                      : Border.all(color: ColorHex.grey, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(loc.gara_name!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(loc.gara_address!,
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle,
                          color: ColorHex.total_color),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
