import 'package:app_hm/Controller/Appointment/Appointmentcontroller.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Model/Service/ServiceModel.dart';
import 'package:app_hm/Model/Service/TypeServiceModel.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Listservice extends StatelessWidget {
  const Listservice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final String typeId = args['type_id'] as String;
    final String typeName = args['type_name'] as String? ?? 'Dịch vụ';

    final controller = Get.find<Appointmentcontroller>();

    final type = controller.typeList.firstWhere(
      (t) => t.type_id == typeId,
      orElse: () =>
          TypeServiceModel(type_id: typeId, type_name: typeName, services: []),
    );
    final services = type.services ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorHex.total_color,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(typeName,
            style: const TextStyle(color: Colors.black, fontSize: 17)),
      ),
      body: services.isEmpty
          ? const Center(child: Text('Không có dịch vụ nào'))
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: services.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, idx) {
                final s = services[idx];
                return _ServiceCard(service: s);
              },
            ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Service service;
  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 12 / 5,
            child: Image.network(
              service.service_img ?? '',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: Colors.grey.shade300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        service.service_name ?? '',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      '${service.price ?? 'N/A'} đ', // Xử lý null cho price
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.servicedetail,
                          arguments: service.service_id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Book Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
