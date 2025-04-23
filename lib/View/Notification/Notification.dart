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
          style: const TextStyle(fontSize: 14, color: ColorHex.white),
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
                                            color: ColorHex.textContent,
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
}
