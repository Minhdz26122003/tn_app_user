import 'package:app_hm/Controller/Appointment/Appointmentcontroller.dart';
import 'package:app_hm/Controller/ServiceC/ServiceController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Model/Service/TypeServiceModel.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Listservice extends StatelessWidget {
  const Listservice({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final int typeId = args['type_id'] as int;
    final String typeName = args['type_name'] as String? ?? 'Dịch vụ';

    final Servicecontroller controller = Get.put(Servicecontroller());
    final Appointmentcontroller Appointcontroller =
        Get.find<Appointmentcontroller>();

    final type = Appointcontroller.typeList.firstWhere(
      (t) => t.type_id == typeId,
      orElse: () =>
          TypeServiceModel(type_id: typeId, type_name: typeName, services: []),
    );
    final services = type.services ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorHex.total_color,
        elevation: 0,
        leading: const BackButton(color: ColorHex.white),
        title: Text(typeName,
            style: const TextStyle(color: ColorHex.white, fontSize: 17)),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            icon: const Icon(
              Icons.search_outlined,
              color: ColorHex.white,
            ),
            tooltip: 'Tìm kiếm',
            onPressed: () {
              controller.initFilters(); // Khởi tạo lại các bộ lọc về mặc định
              Get.toNamed(Routes.servicesearch);
            },
          )
        ],
      ),
      body: services.isEmpty
          ? const Center(child: Text('Không có dịch vụ nào'))
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: services.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, idx) {
                final s = services[idx];
                return _ServiceCard(context, s, controller);
              },
            ),
    );
  }

  Widget _ServiceCard(
      BuildContext context, Service service, Servicecontroller controller) {
    return Card(
      key: ValueKey(service.service_id),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1) Ảnh banner
          AspectRatio(
            aspectRatio: 12 / 5,
            child: Image.network(
              service.service_img ?? '',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: Colors.grey.shade300),
            ),
          ),
          // 2) Nội dung
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: Text(
                    service.service_name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.formatCurrency(service.price),
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed(Routes.servicedetail, arguments: service);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          'book_service'.tr,
                          style: const TextStyle(
                              color: ColorHex.white, fontSize: 13),
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
    );
  }
}
