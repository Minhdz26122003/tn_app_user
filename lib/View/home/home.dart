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
      backgroundColor: ColorHex.grey_shade300,
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: preview.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.9,
                            ),
                            itemBuilder: (context, i) {
                              final s = preview[i];
                              final url = (s.service_img ?? '').trim();
                              return GestureDetector(
                                onTap: () {
                                  // Truyền nguyên ServiceModel
                                  Get.toNamed(Routes.servicedetail,
                                      arguments: s);
                                },
                                child: Column(
                                  children: [
                                    Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 28,
                                      errorBuilder: (_, __, ___) => const Icon(
                                          Icons.broken_image,
                                          size: 28),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: 60,
                                      child: Text(
                                        s.service_name ?? '',
                                        style: const TextStyle(fontSize: 12),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
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
