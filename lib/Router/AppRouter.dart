part of 'AppPage.dart';

abstract class Routes {
  static const dashboard = _Paths.dashboard;
  static const splash = _Paths.splash;
  static const onboarding = _Paths.onboarding;
  static const login = _Paths.login;
  static const account = _Paths.account;
  static const home = _Paths.home;
  static const signup = _Paths.signup;
  static const sendtopt = _Paths.sendotp;
  static const notification = _Paths.notification;
  static const createpassword = _Paths.createpassword;
  static const forgotPassword = _Paths.forgotpassword;
  static const changepassword = _Paths.changepassword;
  static const setting = _Paths.setting;
  static const language = _Paths.language;
  static const personal = _Paths.personal;
  static const personaldetail = _Paths.personaldetail;
  static const appointmentlist = _Paths.appointmentlist;
  static const servicecar = _Paths.servicecar;
  static const appointmentbook = _Paths.appointmentbook;
  static const appointmenthistory = _Paths.appointmenthistory;
  static const appointmentplace = _Paths.appointmentplace;
  static const appointmenttime = _Paths.appointmenttime;
  static const appointmentconfirm = _Paths.appointmentconfirm;
  Routes._();
}

abstract class _Paths {
  _Paths._();
  static const dashboard = '/';
  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const sendotp = '/sendotp';
  static const home = '/home';
  static const notification = '/notification';
  static const onboarding = '/onboarding';
  static const forgotpassword = '/forgotpassword';
  static const account = '/account';
  static const createpassword = '/createpassword';
  static const language = '/language';
  static const setting = '/setting';
  static const changepassword = '/changepassword';
  static const personal = '/personal';
  static const personaldetail = '/personaldetail';
  static const appointmentlist = '/appointmentlist';
  static const servicecar = '/servicecar';
  static const appointmentbook = '/appointmentbook';
  static const appointmenthistory = '/appointmenthistory';
  static const appointmentplace = '/appointmentplace';
  static const appointmenttime = '/appointmenttime';
  static const appointmentconfirm = '/appointmentconfirm';
}
