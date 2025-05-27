import 'package:app_hm/View/Account/ChangePassword.dart';
import 'package:app_hm/View/Account/CreatePassword.dart';
import 'package:app_hm/View/Account/ForgotPassword.dart';
import 'package:app_hm/View/Account/SendOTP.dart';
import 'package:app_hm/View/Appointment/AppointmentBook.dart';
import 'package:app_hm/View/Appointment/AppointmentConfirm.dart';
import 'package:app_hm/View/Appointment/AppointmentDetail.dart';
import 'package:app_hm/View/Appointment/AppointmentHistory.dart';
import 'package:app_hm/View/Appointment/AppointmentHistoryDetail.dart';
import 'package:app_hm/View/Appointment/AppointmentPlace.dart';
import 'package:app_hm/View/Appointment/AppointmentTime.dart';
import 'package:app_hm/View/Appointment/ListAppointment.dart';
import 'package:app_hm/View/Car/AddCar.dart';
import 'package:app_hm/View/Car/Car.dart';
import 'package:app_hm/View/Car/EditCar.dart';
import 'package:app_hm/View/Chat/chat_screen.dart';
import 'package:app_hm/View/Guide/PermissionGuide.dart';
import 'package:app_hm/View/Login/Login.dart';
// import 'package:app_hm/View/Login/Onboarding.dart';
import 'package:app_hm/View/Notification/Notification.dart';
import 'package:app_hm/View/Payment/Payment.dart';
import 'package:app_hm/View/Personal/PersonalDetail.dart';
import 'package:app_hm/View/Book/Servicebook.dart';
import 'package:app_hm/View/ServiceType/Listservice.dart';
import 'package:app_hm/View/ServiceType/Servicedetail.dart';
import 'package:app_hm/View/Setting/Language.dart';
import 'package:app_hm/View/Setting/NotificationSet.dart';
import 'package:app_hm/View/Setting/setting.dart';
import 'package:app_hm/View/Signup/Signup.dart';
import 'package:app_hm/View/dashboard.dart';
import 'package:app_hm/View/home/ServiceSearch.dart';
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
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    // GetPage(
    //   name: Routes.onboarding,
    //   page: () => const Onboarding(),
    //   transition: Transition.fadeIn,
    //   transitionDuration: const Duration(milliseconds: 400),
    // ),
    GetPage(
      name: Routes.home,
      page: () => const Home(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.login,
      page: () => const Login(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const Signup(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.sendtopt,
      page: () => const Sentotp(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const Dashboard(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const Forgotpassword(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.notification,
      page: () => const Notification(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.notificationset,
      page: () => const Notificationset(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.setting,
      page: () => const Setting(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.language,
      page: () => const Language(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.personaldetail,
      page: () => const Personaldetail(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.createpassword,
      page: () => const Createpassword(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.changepassword,
      page: () => const Changepassword(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.appointmentlist,
      page: () => const Appointmentlist(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.servicebook,
      page: () => const Servicebook(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.appointmentbook,
      page: () => const Appointmentbook(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.appointmenthistory,
      page: () => const Appointmenthistory(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.appointmentplace,
      page: () => const Appointmentplace(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.appointmenttime,
      page: () => const Appointmenttime(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.appointmentconfirm,
      page: () => const Appointmentconfirm(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.appoointmentdetail,
      page: () => const Appoointmentdetail(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.car,
      page: () => const Car(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.addcar,
      page: () => const AddCar(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.editcar,
      page: () => const EditCar(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.listservice,
      page: () => const Listservice(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.servicedetail,
      page: () => const Servicedetail(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.permissionguide,
      page: () => const PermissionGuide(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.payment,
      page: () => const Payment(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.servicesearch,
      page: () => const Servicesearch(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.appointmenthistorydetail,
      page: () => const Appointmenthistorydetail(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.chatscreen,
      page: () => const ChatScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
  ];
}
