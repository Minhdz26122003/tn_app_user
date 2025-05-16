import 'dart:async';
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
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class PushNotifications {
  static final firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static int uid = 0;
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
      uid = await Utils.getIntValueWithKey(Constant.UUID_USER_ACC);
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
    const InitializationSettings initSettings = InitializationSettings(
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
    Get.toNamed(Routes.dashboard);
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
      payload: '',
    );
  }

  // Hàm lưu thông báo vào CSDL
  static Future<void> saveNotification(
    int uid,
    String title,
    String body,
  ) async {
    final now = DateTime.now();
    final formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(now);
    final keyCert =
        Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime);

    final payload = {
      'uid': uid,
      'title': title,
      'body': body,
      'keyCert': keyCert,
      'time': formattedTime,
    };

    final data = await APICaller.getInstance().post(
      'Notify/add_notify.php',
      payload,
    );
    if (data != null && data['status'] == 'success') {
      print('Notification saved: $data');
    } else {
      print('Failed to save notification');
    }
  }

  // static Future<void> scheduleQuickTest({
  //   required String title,
  //   String? body,
  // }) async {
  //   final plugin = _flutterLocalNotificationsPlugin;
  //   final now = tz.TZDateTime.now(tz.local);
  //   final fireTime = now.add(const Duration(seconds: 10));
  //   print('Now: $now, schedule test for: $fireTime');
  //   await plugin.zonedSchedule(
  //     12345,
  //     title,
  //     body ?? title,
  //     fireTime,
  //     NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'demo1-4b8c1',
  //         'Demo1 Notifications',
  //         channelDescription: 'Kênh test',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //       ),
  //     ),
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     androidAllowWhileIdle: true,
  //   );
  //   final pending =
  //       await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  //   print('🔔 Pending notifications: $pending');
  // }

  // Thông báo định kỳ
  static Future<void> scheduleReminders(
    int uid, // uid người dùng
    DateTime appointmentDateTime, // thời điểm lịch hẹn
    {
    required String title,
    String? body,
  }) async {
    final plugin = _flutterLocalNotificationsPlugin;
    final now = tz.TZDateTime.now(tz.local);

    // Các khoảng cần nhắc
    final reminders = [
      const Duration(hours: 1),
      const Duration(minutes: 30),
    ];

    for (var dur in reminders) {
      // Tính thời điểm firing
      final fireTime = tz.TZDateTime.from(
        appointmentDateTime.subtract(dur),
        tz.local,
      );

      // Chỉ schedule nếu thời điểm còn nằm trong tương lai
      if (fireTime.isAfter(now)) {
        final label = dur.inMinutes >= 60 ? '1 giờ trước' : '30 phút trước';
        final notifTitle = title;
        final notifBody = body ?? '$title ($label)';

        // 1) Schedule local notification
        await plugin.zonedSchedule(
          fireTime.hashCode, // id
          notifTitle,
          notifBody,
          fireTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'demo1-4b8c1', // channel ID
              'Demo1 Notifications',
              channelDescription: 'Kênh thông báo demo1',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
        );

        // 2) Lưu bản ghi notification vào database
        //    để luôn hiển thị được trong app
        await saveNotification(uid, notifTitle, notifBody);
      }
    }
  }
}
