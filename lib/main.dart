import 'dart:io';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Services/PushNotification.dart';
import 'package:app_hm/Services/TranslationService.dart';
import 'package:app_hm/firebase_options.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

  // Khởi tạo Firebase trước khi chạy ứng dụng
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      name: "demo1-4b8c1",
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await dotenv.load(fileName: ".env");
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);

  //await _requestPermissions();
  runApp(MyApp(initialLocale: await TranslationService.getSavedLocale()));

  await startNotification();
}

// Future<void> _requestPermissions() async {
//   final notificationStatus = await Permission.notification.status;
//   if (notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
//     if (Platform.isIOS) {
//       await Permission.notification.request();
//     } else if (Platform.isAndroid) {
//       await Permission.notification.request();
//     }
//   } else {
//     print('Notification permission already granted');
//   }

//   if (Platform.isAndroid) {
//     final androidInfo = await DeviceInfoPlugin().androidInfo;
//     if (androidInfo.version.sdkInt >= 31) {
//       final alarmStatus = await Permission.scheduleExactAlarm.status;
//       print('Trạng thái quyền báo thức chính xác: $alarmStatus');
//       if (alarmStatus.isDenied || alarmStatus.isPermanentlyDenied) {
//         final newAlarmStatus = await Permission.scheduleExactAlarm.request();
//         if (newAlarmStatus.isGranted) {
//           print('Exact alarm permission granted');
//         } else {
//           print('Exact alarm permission denied');
//         }
//       } else {
//         print('Exact alarm permission already granted');
//       }
//     }
//   }
// }

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          titleSpacing: 20,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('vi', 'VN'),
      ],
      translations: TranslationService(),
      locale: initialLocale,
      fallbackLocale: TranslationService.fallbackLocale,
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.splash,
      getPages: AppPages.routes,
    );
  }
}

Future firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {}
}

Future startNotification() async {
  await PushNotifications.localNotiInit();
  await PushNotifications.init();

  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    if (message.notification != null) {
      await PushNotifications.showSimpleNotification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
      );
      // Flushbar(
      //   title: message.notification!.title ?? 'No Title',
      //   message: message.notification!.body ?? 'No Body',
      //   duration: const Duration(seconds: 5),
      //   flushbarPosition: FlushbarPosition.TOP,
      //   flushbarStyle: FlushbarStyle.GROUNDED,
      //   reverseAnimationCurve: Curves.decelerate,
      //   forwardAnimationCurve: Curves.elasticOut,
      //   onTap: (flushbar) {
      //     PushNotifications.navigationInNotification(message.data);
      //     flushbar.dismiss();
      //   },
      // ).show(Get.context!);
    }
  });
// Xử lý khi mở ứng dụng từ thông báo
  FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    await PushNotifications.navigationInNotification(message.data);
  });

// Kiểm tra nếu ứng dụng khởi động từ thông báo
  final RemoteMessage? message = await FirebaseMessaging.instance
      .getInitialMessage(); // gọi hàm  này khi thông báo được nhấn vào từ trạng thái app đang đóng
  if (message != null) {
    PushNotifications.navigationInNotification(message.data);
  }
// Lắng nghe làm mới token
  FirebaseMessaging.instance.onTokenRefresh.listen((event) {});
}
