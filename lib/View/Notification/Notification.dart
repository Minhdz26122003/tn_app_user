import 'package:app_hm/Component/DialogCustom.dart';
import 'package:app_hm/Component/EmptyList.dart';
import 'package:app_hm/Controller/Notification/NotificationController.dart';
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
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2D74FF),
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
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
                            color: Color.fromRGBO(244, 247, 250, 1)),
                        itemBuilder: (context, index) {
                          if (index == controller.notificationList.length - 1 &&
                              controller.totalPage != controller.page) {
                            return const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            );
                          }
                          return GestureDetector(
                            onTap: () async {
                              await controller.readOnly(index: index);
                            },
                            child: Container(
                              color:
                                  controller.notificationList[index].status == 0
                                      ? const Color.fromRGBO(247, 251, 255, 1)
                                      : Colors.white,
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
                                        ? const Color.fromRGBO(45, 116, 255, 1)
                                        : const Color.fromRGBO(
                                            234, 238, 243, 1),
                                    size: 10,
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
                                            color: Color.fromRGBO(
                                                153, 162, 179, 1),
                                            size: 12,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            controller.timeAgo(controller
                                                .notificationList[index]
                                                .timeCreated!),
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(
                                                    153, 162, 179, 1)),
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
}
