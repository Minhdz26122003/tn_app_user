import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Model/Notification/NotificationModel.dart';
import 'package:app_hm/Services/APICaller.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationController extends GetxController {
  RxBool isLoading = false.obs;

  int totalCount = 0;
  int page = 1;
  int pageSize = 10;
  int totalPage = 0;
  RxList<NotificationModel> notificationList = RxList<NotificationModel>();
  ScrollController scrollController = ScrollController();
  DateTime timeNow = DateTime.now();
  int uid = 0;
  // thông báo chưa đọc
  int get unreadCount => notificationList.where((n) => n.status == 0).length;
  @override
  void onInit() async {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (totalPage > page) {
          page++;
          getNotification();
        }
      }
    });
    uid = await Utils.getIntValueWithKey(Constant.UUID_USER_ACC);
    await getNotification();
    super.onInit();
  }

  refreshData() async {
    page = 1;
    notificationList.clear();
    await getNotification();
  }

  getNotification() async {
    if (uid != 0) {
      try {
        DateTime timeNow = DateTime.now();
        String formattedTime =
            DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
        if (page == 1) {
          isLoading.value = true;
        }
        //print("time now: $timeNow");
        var param = {
          "keyCert":
              Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
          "time": formattedTime,
          "pageSize": pageSize,
          "page": page,
          "uid": uid
        };
        var data =
            await APICaller.getInstance().post('Notify/get_notify.php', param);
        //print("data: $data");
        if (data != null) {
          totalCount = data['data']['pagination']['totalCount'];
          totalPage = data['data']['pagination']['totalPage'];
          List<dynamic> list = data['data']['items'];
          var listItem = list
              .map((dynamic json) => NotificationModel.fromJson(json))
              .toList();
          notificationList.addAll(listItem);

          if (page == 1) {
            isLoading.value = false;
          }
        } else {
          isLoading.value = false;
        }
      } catch (e) {
        //debugPrint(" Lỗi API: $e", wrapWidth: 1024);
        Utils.showSnackBar(title: 'notification'.tr, message: '$e');
        isLoading.value = false;
      }
    }
  }

  readAll() async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    var param = {
      "keyCert":
          Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "uid": uid
    };
    try {
      var response =
          await APICaller.getInstance().post('Notify/read_all.php', param);
      if (response != null && response['status'] == 'success') {
        for (var notification in notificationList) {
          notification.status = 1;
        }
        notificationList.refresh();
      }
    } catch (e) {
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  readOnly({required int index}) async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    var param = {
      "keyCert":
          Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "uid": uid,
      "noti_id": notificationList[index].noti_id
    };
    try {
      var response =
          await APICaller.getInstance().post('Notify/read_only.php', param);
      //print('Body: ${param}');
      if (response != null && response['status'] == 'success') {
        notificationList[index].status = 1;
        notificationList.refresh();
      }
    } catch (e) {
      debugPrint(" Lỗi API: $e", wrapWidth: 1024);
      //Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  String timeAgo(String dateTimeString) {
    DateTime inputDate = DateTime.parse(dateTimeString);
    DateTime now = DateTime.now();
    Duration difference = now.difference(inputDate);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} ${'seconds_ago'.tr}';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${'minutes_ago'.tr}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${'hours_ago'.tr}';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm:ss').format(inputDate);
    }
  }
}
