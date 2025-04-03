import 'package:app_hm/View/Account/ChangePassword.dart';
import 'package:app_hm/View/Account/ForgotPassword.dart';
import 'package:app_hm/View/Account/SendOTP.dart';
import 'package:app_hm/View/Appointment/Appointment.dart';
import 'package:app_hm/View/Login/Login.dart';
import 'package:app_hm/View/Login/Onboarding.dart';
import 'package:app_hm/View/Notification/Notification.dart';
import 'package:app_hm/View/Personal/Personal.dart';
import 'package:app_hm/View/Personal/PersonalDetail.dart';
import 'package:app_hm/View/Setting/setting.dart';
import 'package:app_hm/View/Signup/Signup.dart';
import 'package:app_hm/View/dashboard.dart';
import 'package:app_hm/View/home/home.dart';
import 'package:get/get.dart';
import 'package:app_hm/View/Login/Splash.dart';
part 'AppRouter.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.dashboard;
  static const splash = Routes.splash;
  static const login = Routes.login;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const Splash(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const Onboarding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const Home(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const Login(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const Signup(),
    ),
    GetPage(
      name: Routes.sendtopt,
      page: () => const Sentotp(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const Dashboard(),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const Forgotpassword(),
    ),
    GetPage(
      name: Routes.notification,
      page: () => const Notification(),
    ),
    GetPage(
      name: Routes.setting,
      page: () => const Setting(),
    ),
    GetPage(
      name: Routes.personaldetail,
      page: () => const Personaldetail(),
    ),
    GetPage(
      name: Routes.changepassword,
      page: () => const Changepassword(),
    ),
    GetPage(
      name: Routes.appointment,
      page: () => const Appointment(),
    ),
  ];
}
