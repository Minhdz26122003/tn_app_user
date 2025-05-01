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
      body: Obx(() {
        if (apptC.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipPath(
                clipper: _HeaderClipper(),
                child: Container(
                  height: 230,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/header.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: 30,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // row avatar + tên + icon
                      Row(
                        children: [
                          Obx(() => CircleAvatar(
                                radius: 20,
                                backgroundImage: dashC.avatar.value.isNotEmpty
                                    ? NetworkImage(dashC.avatar.value)
                                    : null,
                                backgroundColor: Colors.white54,
                                child: dashC.avatar.value.isEmpty
                                    ? const Icon(
                                        Icons.person,
                                      )
                                    : null,
                              )),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(() => Text(
                                  'Hello, ${dashC.username.value}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications_rounded),
                            tooltip: 'notification'.tr,
                            color: Colors.white,
                            onPressed: () {
                              Get.toNamed(Routes.notification);
                            },
                          )
                        ],
                      ),

                      const SizedBox(
                        height: 65,
                      ),

                      // search bar
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Nhập dịch vụ bạn muốn tìm',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white70,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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

              // Với mỗi type dịch vụ
              SafeArea(
                child: Column(
                  children: List.generate(apptC.typeList.length, (typeIdx) {
                    final type = apptC.typeList[typeIdx];
                    final services = type.services ?? [];
                    final preview =
                        services.length > 3 ? services.sublist(0, 3) : services;

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
                          const SizedBox(height: 5),
                          // Grid preview
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: preview.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, // 3 cột
                                mainAxisSpacing:
                                    10, // khoảng cách giữa các hàng
                                crossAxisSpacing:
                                    10, // khoảng cách giữa các cột
                                childAspectRatio:
                                    0.9, // cao hơn (0.75 = cao hơn 1.0)
                              ),
                              itemBuilder: (context, i) {
                                final s = preview[i];
                                final url = (s.service_img ?? '').trim();
                                return GestureDetector(
                                  onTap: () => Get.toNamed(Routes.servicedetail,
                                      arguments: s),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Tăng kích thước ảnh lên 60×60
                                      SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                            url,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                Container(
                                                    color:
                                                        Colors.grey.shade300),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: 70,
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
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2, size.height, // điểm điều khiển
      size.width, size.height - 50, // điểm kết thúc
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_HeaderClipper oldClipper) => false;
}
