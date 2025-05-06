import 'dart:convert';
import 'package:app_hm/Router/AppPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

// Top-level background handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await PushNotifications._showLocalNotification(message);
}

class PushNotifications {
  PushNotifications._();
  static final instance = PushNotifications._();

  final _fcm = FirebaseMessaging.instance;
  final _local = FlutterLocalNotificationsPlugin();
  bool _isLocalInit = false;

  /// 1. Gọi ngay khi app khởi động (trước runApp)
  Future<void> initialize() async {
    // Đăng ký background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Xin quyền
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );
    print('FCM permission: ${settings.authorizationStatus}');

    // Tạo channel & init local plugin
    await _initLocalNotifications();

    // Lắng nghe thông báo đến khi app chạy foreground
    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    // Xử lý khi tap notification (foreground/background)
    FirebaseMessaging.onMessageOpenedApp
        .listen((msg) => _handleMessageTap(msg.data));

    // Xử lý cold start
    final initialMsg = await _fcm.getInitialMessage();
    if (initialMsg != null) {
      _handleMessageTap(initialMsg.data);
    }

    // Lấy token và gửi lên server
    final token = await _fcm.getToken();
    print('FCM token: $token');
    if (token != null) _sendTokenToServer(token);
  }

  /// 2. Tạo Notification Channel và khởi tạo plugin
  Future<void> _initLocalNotifications() async {
    if (_isLocalInit) return;
    // 2.1. Định nghĩa channel
    const channel = AndroidNotificationChannel(
      'appointments', // phải trùng với default_notification_channel_id
      'Appointments', // tên hiển thị người dùng
      description: 'Appointment notifications',
      importance: Importance.max,
    );
    // 2.2. Tạo channel trên Android
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 2.3. Khởi tạo plugin
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    await _local.initialize(
      const InitializationSettings(android: androidSettings),
      onDidReceiveNotificationResponse: (resp) {
        if (resp.payload != null) _handleMessageTap(jsonDecode(resp.payload!));
      },
      onDidReceiveBackgroundNotificationResponse: (resp) {
        if (resp.payload != null) _handleMessageTap(jsonDecode(resp.payload!));
      },
    );
    _isLocalInit = true;
  }

  /// 3. Hiển thị notification cục bộ
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notif = message.notification;
    if (notif == null) return;
    final android = notif.android;
    // Chỉ show nếu có Android payload (đảm bảo icon, channel)
    if (android != null) {
      await instance._local.show(
        notif.hashCode,
        notif.title,
        notif.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'appointments',
            'Appointments',
            channelDescription: 'Appointment notifications',
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            // Đảm bảo notification lưu lại
            ongoing: false,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(
              presentAlert: true, presentSound: true, presentBadge: true),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  /// 4. Xử lý khi user tap notification
  void _handleMessageTap(Map<String, dynamic> data) {
    // Ví dụ chuyển về Dashboard với tham số
    Get.offAllNamed(Routes.dashboard, arguments: data);
  }

  /// 5. Gửi FCM token lên server (cần implement)
  Future<void> _sendTokenToServer(String token) async {
    // TODO: gọi API lưu token
  }
}
