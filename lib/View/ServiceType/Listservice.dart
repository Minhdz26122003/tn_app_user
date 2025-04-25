import 'package:app_hm/Controller/Appointment/Appointmentcontroller.dart';
import 'package:app_hm/Model/Service/ServiceModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Listservice extends StatelessWidget {
  const Listservice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // arguments từ Get.toNamed(...)
    final args = Get.arguments as Map<String, dynamic>;
    final String typeId = args['type_id'] as String;
    final String typeName = args['type_name'] as String? ?? 'Dịch vụ';

    final controller = Get.find<Appointmentcontroller>();

    final services = controller.serviceList
        .where((s) => s.type_id?.trim() == typeId.trim())
        .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black),
        title: Text(
          typeName,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
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
  final ServiceModel service;
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
          // 1) Ảnh banner
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              service.service_img ?? '',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey),
            ),
          ),

          // 2) Nội dung
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề & giá
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        service.service_name ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '\$${double.tryParse(service.pirce ?? '')?.toStringAsFixed(0) ?? '--'}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Mô tả ngắn
                if (service.description != null)
                  Text(
                    service.description!,
                    style: const TextStyle(fontSize: 14),
                  ),

                const SizedBox(height: 12),

                // Nút Book Now
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // action book service
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
