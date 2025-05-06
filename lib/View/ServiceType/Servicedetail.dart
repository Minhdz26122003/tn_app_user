import 'package:app_hm/Controller/ServiceControl/ServiceController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Model/Service/TypeServiceModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Servicedetail extends StatelessWidget {
  const Servicedetail({super.key});

  @override
  Widget build(BuildContext context) {
    final Servicecontroller controller = Get.put(Servicecontroller());
    final service = Get.arguments as Service;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorHex.total_color,
        title: Text(
          service.service_name ?? 'service_details'.tr,
          style: const TextStyle(fontSize: 17, color: ColorHex.white),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      service.service_img ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey.shade300),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.service_name ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.formatCurrency(service.price),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'service_infor'.tr,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            service.description ?? '',
                            style: const TextStyle(fontSize: 12),
                            maxLines: controller.isDescriptionExpanded.value
                                ? null
                                : 3,
                            overflow: controller.isDescriptionExpanded.value
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                          ),

                          if (!controller.isDescriptionExpanded.value)
                            TextButton(
                              onPressed: () {
                                controller.isDescriptionExpanded.value = true;
                              },
                              child: const Text(
                                'Xem thêm',
                                style: TextStyle(
                                    fontSize: 11, color: ColorHex.total_color),
                              ),
                            ),
                          if (controller.isDescriptionExpanded.value)
                            TextButton(
                              onPressed: () {
                                controller.isDescriptionExpanded.value = false;
                              },
                              child: const Text(
                                'Thu gọn',
                                style: TextStyle(
                                    fontSize: 11, color: ColorHex.total_color),
                              ),
                            ),

                          const SizedBox(height: 16),
                          const Text(
                            'Đánh giá và bình luận',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // if (service.comments != null &&
                          //     service.comments.isNotEmpty)
                          //   ListView.builder(
                          //     shrinkWrap: true,
                          //     physics: const NeverScrollableScrollPhysics(),
                          //     itemCount: service.comments.length,
                          //     itemBuilder: (context, index) {
                          //       final comment = service.comments[index];
                          //       return Card(
                          //         child: Padding(
                          //           padding: const EdgeInsets.all(8.0),
                          //           child: Column(
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             children: [
                          //               Text(
                          //                 comment.userName,
                          //                 style: const TextStyle(
                          //                     fontWeight: FontWeight.bold),
                          //               ),
                          //               Row(
                          //                 children: List.generate(5, (i) {
                          //                   return Icon(
                          //                     i < comment.rating
                          //                         ? Icons.star
                          //                         : Icons.star_border,
                          //                     color: Colors.yellow,
                          //                     size: 16,
                          //                   );
                          //                 }),
                          //               ),
                          //               const SizedBox(height: 4),
                          //               Text(comment.commentText),
                          //             ],
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //   )
                          // else
                          //   const Text('Chưa có đánh giá nào.'),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Xử lý book service
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'book_service'.tr,
                  style: const TextStyle(fontSize: 16, color: ColorHex.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
