import 'package:app_hm/Component/DialogCustom.dart';
import 'package:app_hm/Component/EmptyList.dart';
import 'package:app_hm/Controller/Notification/NotificationController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class Notification extends StatelessWidget {
  const Notification({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'notification'.tr,
          style: const TextStyle(fontSize: 17, color: ColorHex.white),
        ),
        backgroundColor: ColorHex.total_color,
        titleSpacing: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_outlined, color: ColorHex.white),
          onPressed: () => Get.back(),
          color: Colors.white,
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            icon: const Icon(Icons.done_all_rounded),
            tooltip: 'mark_all_read'.tr,
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => DialogCustom(
                  svg: 'assets/icons/notification.svg',
                  title: 'mark_all_read'.tr,
                  description: 'all_notifications'.tr,
                  onTap: () async {
                    await controller.readAll();
                    Navigator.pop(context);
                  },
                ),
              );
            },
          )
        ],
      ),
      body: Obx(() => RefreshIndicator(
            onRefresh: () => controller.refreshData(),
            child: controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : controller.notificationList.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            width: Get.width,
                            height: Get.height * 0.5,
                            child: EmptyList(
                                title: 'no_announcements'.tr,
                                imgSrc: 'assets/icons/notification.svg',
                                content: ''.tr),
                          ),
                        ],
                      )
                    : ListView.separated(
                        controller: controller.scrollController,
                        itemCount: controller.notificationList.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => const Divider(
                            height: 1,
                            thickness: 0,
                            indent: 0,
                            endIndent: 0,
                            color: ColorHex.grey_shade300),
                        itemBuilder: (context, index) {
                          if (index == controller.notificationList.length - 1 &&
                              controller.totalPage != controller.page) {
                            return const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: ColorHex.white,
                              ),
                            );
                          }
                          return GestureDetector(
                            onTap: () async {
                              await controller.readOnly(index: index);
                              final noti = controller.notificationList[index];
                              showNotificationDetailsBottomSheet(
                                context: context,
                                title: noti.title ?? '',
                                body: noti.body ?? '',
                                timeCreated: noti.time_created ?? '',
                              );
                            },
                            child: Container(
                              color:
                                  controller.notificationList[index].status == 0
                                      ? ColorHex.grey_shade300
                                      : ColorHex.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  Icon(
                                    Icons.fiber_manual_record_rounded,
                                    color: controller.notificationList[index]
                                                .status ==
                                            0
                                        ? ColorHex.total_color
                                        : ColorHex.grey_shade300,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Html(
                                        data:
                                            """${controller.notificationList[index].body}""",
                                        style: {
                                          "body": Style(
                                            padding: HtmlPaddings.all(0),
                                            margin: Margins.all(0),
                                            fontSize: FontSize(13),
                                          ),
                                        },
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.schedule_rounded,
                                            color: ColorHex.textContent,
                                            size: 12,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            controller.timeAgo(controller
                                                .notificationList[index]
                                                .time_created!),
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: ColorHex.textContent),
                                          )
                                        ],
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          )),
    );
  }

  void showNotificationDetailsBottomSheet({
    required BuildContext context,
    required String title,
    required String body,
    required String timeCreated,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh kéo
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                body,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    timeCreated,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
