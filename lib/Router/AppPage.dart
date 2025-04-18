import 'package:app_hm/View/Account/ChangePassword.dart';
import 'package:app_hm/View/Account/CreatePassword.dart';
import 'package:app_hm/View/Account/ForgotPassword.dart';
import 'package:app_hm/View/Account/SendOTP.dart';
import 'package:app_hm/View/Appointment/AppointmentBook.dart';
import 'package:app_hm/View/Appointment/AppointmentConfirm.dart';
import 'package:app_hm/View/Appointment/AppointmentHistory.dart';
import 'package:app_hm/View/Appointment/AppointmentPlace.dart';
import 'package:app_hm/View/Appointment/AppointmentTime.dart';
import 'package:app_hm/View/Appointment/ListAppointment.dart';
import 'package:app_hm/View/Login/Login.dart';
import 'package:app_hm/View/Login/Onboarding.dart';
import 'package:app_hm/View/Notification/Notification.dart';
import 'package:app_hm/View/Personal/PersonalDetail.dart';
import 'package:app_hm/View/ServiceCar/ServiceCar.dart';
import 'package:app_hm/View/Setting/Language.dart';
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
      name: Routes.language,
      page: () => const Language(),
    ),
    GetPage(
      name: Routes.personaldetail,
      page: () => const Personaldetail(),
    ),
    GetPage(
      name: Routes.createpassword,
      page: () => const Createpassword(),
    ),
    GetPage(
      name: Routes.changepassword,
      page: () => const Changepassword(),
    ),
    GetPage(
      name: Routes.appointmentlist,
      page: () => const AppointmentList(),
    ),
    GetPage(
      name: Routes.servicecar,
      page: () => const ServiceCar(),
    ),
    GetPage(
      name: Routes.appointmentbook,
      page: () => const AppointmentBook(),
    ),
    GetPage(
      name: Routes.appointmenthistory,
      page: () => const Appointmenthistory(),
    ),
    GetPage(
      name: Routes.appointmentplace,
      page: () => const Appointmentplace(),
    ),
    GetPage(
      name: Routes.appointmenttime,
      page: () => const Appointmenttime(),
    ),
    GetPage(
      name: Routes.appointmentconfirm,
      page: () => const Appointmentconfirm(),
    ),
  ];
}
