import 'dart:io';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Services/PushNotification.dart';
import 'package:app_hm/Services/TranslationService.dart';
import 'package:app_hm/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(initialLocale: await TranslationService.getSavedLocale()));
  await FirebasePlatform();
  await startNotification();
}

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

Future FirebasePlatform() async {
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
