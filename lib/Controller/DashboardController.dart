import 'package:app_hm/Controller/Appointment/Appointmentcontroller.dart';
import 'package:app_hm/Controller/Notification/NotificationController.dart';
import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Model/Service/ServiceModel.dart';
import 'package:app_hm/Model/Service/TypeServiceModel.dart';
import 'package:app_hm/Services/APICaller.dart';
import 'package:app_hm/Services/Auth.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Dashboardcontroller extends GetxController {
  RxInt currentPageIndex = 0.obs;
  RxString username = ''.obs;
  RxString fullname = ''.obs;
  RxString avatar = ''.obs;
  RxString email = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString birthDate = ''.obs;
  RxString gender = ''.obs;
  RxString address = ''.obs;
  RxBool isLoading = true.obs;

  Rxn<User> firebaseUser = Rxn<User>();

  RxBool isPhpLoggedIn = false.obs;
  // phương thức đăng nhâp
  Rx<LoginMethod?> loginMethod = Rx<LoginMethod?>(null);
  RxBool isLoggedIn = false.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController textSearch = TextEditingController();
  RxList<String> teamSelectList = RxList<String>();
  RxInt isState = (-1).obs;
  // List
  RxList<TypeServiceModel> typeList = RxList<TypeServiceModel>();
  RxList<ServiceModel> serviceList = RxList<ServiceModel>();
  final banners = <String>[
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
    'assets/images/banner4.jpg',
  ];

  @override
  Future<void> onInit() async {
    super.onInit();

    final idx = Get.arguments;
    if (idx is int) currentPageIndex.value = idx;
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
    checkPhpToken();
    ever<User?>(firebaseUser, (_) => updateIsLoggedIn());
    getServiceTypeList();
    getServiceList();
    try {
      isLoading.value = true;

      username.value =
          await Utils.getStringValueWithKey(Constant.USERNAME) ?? '';
      fullname.value = await Utils.getStringValueWithKey(Constant.FULL_NAME) ??
          ''; // Đảm bảo tải fullname
      avatar.value =
          await Utils.getStringValueWithKey(Constant.AVATAR_USER) ?? '';
      email.value = await Utils.getStringValueWithKey(Constant.EMAIL) ?? '';
      phoneNumber.value =
          await Utils.getStringValueWithKey(Constant.PHONENUM) ?? '';
      birthDate.value =
          await Utils.getStringValueWithKey(Constant.BIRTHDAY) ?? '';
      gender.value = await Utils.getStringValueWithKey(Constant.GENDER) ?? '';
      address.value = await Utils.getStringValueWithKey(Constant.ADDRESS) ?? '';
    } catch (e) {
      print("Lỗi khi tải dữ liệu: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void checkPhpToken() async {
    String token = await Utils.getStringValueWithKey(Constant.ACCESS_TOKEN);
    isPhpLoggedIn.value = token.isNotEmpty;
    updateIsLoggedIn();
  }

  // void updateIsLoggedIn() {
  //   // Nếu firebaseUser đã đăng nhâp HOẶC có token PHP => đã đăng nhập
  //   isLoggedIn.value = (firebaseUser.value != null) || isPhpLoggedIn.value;
  //   // Utils.showSnackBar(title: 'Thông báo', message: '$isLoggedIn');
  // }
  void updateIsLoggedIn() {
    if (firebaseUser.value != null) {
      isLoggedIn.value = true;
      loginMethod.value ??= LoginMethod.firebase;
    } else if (isPhpLoggedIn.value && loginMethod.value == null) {
      isLoggedIn.value = true;
      loginMethod.value ??= LoginMethod.php;
    } else {
      isLoggedIn.value = false;
    }
  }

  getServiceTypeList() async {
    //isLoading.value = true;
    typeList.clear();
    try {
      DateTime timeNow = DateTime.now();
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
      };

      var data = await APICaller.getInstance()
          .post('Servicetype/get_type_service.php', param);
      if (data != null && data['error']['code'] == 0) {
        List<dynamic> list = data['items'];
        var listItem = list
            .map((dynamic json) => TypeServiceModel.fromJson(json))
            .toList();
        typeList.addAll(listItem);
      }
    } catch (e) {
      debugPrint("Lỗi API getServiceTypeList : $e", wrapWidth: 1024);
      //Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
    // finally {
    //   isLoading.value = false;
    // }
  }

  getServiceList() async {
    serviceList.clear();
    //isLoading.value = true;
    try {
      DateTime timeNow = DateTime.now();
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
      };

      var data =
          await APICaller.getInstance().post('Service/get_service.php', param);
      if (data != null) {
        List<dynamic> list = data['items'];
        var listItem =
            list.map((dynamic json) => ServiceModel.fromJson(json)).toList();
        serviceList.addAll(listItem);
      }
    } catch (e) {
      debugPrint("Lỗi API getServiceList: $e", wrapWidth: 1024);
      //Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
    // finally {
    //   isLoading.value = false;
    // }
  }

  Future<void> changePage(int index) async {
    currentPageIndex.value = index;
    // if (index == 0) {
    //   try{
    //      getServiceTypeList();
    //   getServiceList();
    //   }catch (e) {
    //     Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    //   }finally {
    //     isLoading.value = false;
    //   }

    // }
  }
}
