import 'dart:convert';
import 'package:app_hm/Controller/DashboardController.dart';
import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Global/GlobalValue.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Services/APICaller.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PushNotifications {
  static final firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // request notification permission
  static Future init() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );
    if (await Utils.getStringValueWithKey(Constant.FCMTOKEN) == '') {
      String? token = await firebaseMessaging.getToken();
      Utils.saveStringWithKey(Constant.FCMTOKEN, token!);
    }
    //print('device token ''${await Utils.getStringValueWithKey(Constant.FCMTOKEN)}');
  }

  Future<void> saveFcmToken(String userId) async {
    DateTime timeNow = DateTime.now();
    String? token = await FirebaseMessaging.instance.getToken();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    if (token != null) {
      var body = {
        "uid": userId,
        "fcm_token": token,
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
      };
      try {
        var data =
            await APICaller.getInstance().post('Auth/save_token.php', body);
        if (data != null && data["error"]["code"] == 0) {
          print('Response data: $data');
        } else {
          print('Token cant save');
        }
      } catch (e) {
        debugPrint("Lỗi Token: $e", wrapWidth: 1024);
      }
    }
  }

  static Future localNotiInit() async {
    //  Định nghĩa channel Android 8.0+
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'demo1-4b8c1',
      'Demo1 Notifications',
      description: 'Kênh thông báo demo1',
      importance: Importance.max,
    );

    // Tạo channel trên hệ thống
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Khởi tạo plugin với channel mặc định
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    final InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  // khi chạm vào thông báo cục bộ ở nền trước
  static onNotificationTap(NotificationResponse notificationResponse) {
    Map<String, dynamic> data = jsonDecode(notificationResponse.payload!);
    navigationInNotification(data);
  }

  // chuyển hướng đến trang tương ứng khi nhấn vào thông báo
  static navigationInNotification(dynamic data) async {
    Get.offAllNamed(Routes.dashboard);
    final controller = Get.put(Dashboardcontroller());
    controller.textSearch.text = data['MacNumber'];
    controller.teamSelectList.add(data['TeamUuid']);
  }

  // hiển thị thông báo cục bộ
  static Future showSimpleNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'demo1-4b8c1',
      'Demo1 Notifications',
      channelDescription: 'Kênh thông báo demo1',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      ongoing: false,
      fullScreenIntent: false,
      autoCancel: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      details,
      payload: '', // nếu cần data
    );
  }
}
