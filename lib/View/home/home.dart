import 'package:app_hm/Controller/Appointment/Appointmentcontroller.dart';
import 'package:app_hm/Controller/DashboardController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final Dashboardcontroller dashC = Get.put(Dashboardcontroller());
    final Appointmentcontroller apptC = Get.put(Appointmentcontroller());

    return Scaffold(
      backgroundColor: ColorHex.total_color,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Obx(() => Text(
              'welcome, ${dashC.username.value}',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: dashC.avatar.value.isNotEmpty
                      ? NetworkImage(dashC.avatar.value)
                      : null,
                  backgroundColor: Colors.grey.shade200,
                  child: dashC.avatar.value.isEmpty
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
              )),
        ],
      ),
      body: Obx(() {
        if (apptC.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // banner
              CarouselSlider(
                items: dashC.banners.map((path) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      path,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.85,
                  aspectRatio: 16 / 9,
                  autoPlayInterval: const Duration(seconds: 4),
                ),
              ),
              const SizedBox(height: 24),

              // Với mỗi type dịch vụ
              Column(
                children: List.generate(apptC.typeList.length, (typeIdx) {
                  final type = apptC.typeList[typeIdx];
                  final services = type.services ?? [];
                  final preview =
                      services.length > 5 ? services.sublist(0, 5) : services;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tiêu đề + nút View All
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  type.type_name ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ColorHex.black,
                                  ),
                                ),
                              ),
                              if (services.length > preview.length)
                                TextButton(
                                  onPressed: () {
                                    print(
                                        'type_id: ${type.type_id}, type_name: ${type.type_name}');
                                    Get.toNamed(
                                      Routes.listservice,
                                      arguments: {
                                        'type_id': type.type_id,
                                        'type_name': type.type_name,
                                      },
                                    );
                                  },
                                  child: const Text(
                                    'View All',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Grid preview
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: preview.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.9,
                            ),
                            itemBuilder: (context, svcIdx) {
                              final s = preview[svcIdx];
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Image.network(
                                      s.service_img ?? '',
                                      width: 28,
                                      height: 28,
                                      color: Colors.orange,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.broken_image),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    s.service_name ?? '',
                                    style: const TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }
}
