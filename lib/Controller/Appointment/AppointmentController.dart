import 'dart:async';
import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Model/Account/AccountModel.dart';
import 'package:app_hm/Model/Appointment/ApointmentModel.dart';
import 'package:app_hm/Model/Car/CarModel.dart';
import 'package:app_hm/Model/Center/CenterModel.dart';
import 'package:app_hm/Model/Service/ServiceModel.dart';
import 'package:app_hm/Model/Service/TypeServiceModel.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Services/APICaller.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Appointmentcontroller extends GetxController {
  String emailAcc = "";
  RxList<bool> checkedValuesService = <bool>[].obs;
  RxInt currentStep = 1.obs;
  RxBool isLoading = false.obs;
  var account = AccountModel().obs;

  Rxn<TypeServiceModel> selectedType = Rxn<TypeServiceModel>();
  RxList<TypeServiceModel> typeList = RxList<TypeServiceModel>();
  RxList<ServiceModel> serviceList = RxList<ServiceModel>();

  RxList<AppointmentModel> appointmentList = RxList<AppointmentModel>();

  RxList<CarModel> carList = RxList<CarModel>();
  Rxn<CarModel> selectedCar = Rxn<CarModel>();

  RxList<CenterModel> centerList = RxList<CenterModel>();
  Rxn<CenterModel> selectedAddress = Rxn<CenterModel>();

  Rx<DateTime> selectedDate = DateTime.now().obs;
  DateTime timeNow = DateTime.now().toUtc();
  var description = ''.obs;
  TextEditingController descriptionController = TextEditingController();

  RxString selectedSession = "Sáng".obs;
  RxString selectedTime = "".obs;
  List<String> morningTimes = ['08:00', '09:00', '10:00', '11:00', '12:00'];
  List<String> afternoonTimes = ['13:00', '14:00', '15:00', '16:00', '17:00'];

  bool get hasSelectedService =>
      selectedType.value != null &&
      checkedValuesService.any((isChecked) => isChecked);

  bool get checkdetail =>
      account.value.fullname != null &&
      account.value.fullname!.trim().isNotEmpty &&
      account.value.address != null &&
      account.value.address!.trim().isNotEmpty &&
      account.value.phonenum != null &&
      account.value.phonenum!.trim().isNotEmpty;

  @override
  void onInit() async {
    emailAcc = await Utils.getStringValueWithKey(Constant.EMAIL);
    isLoading.value = false;
    checkedValuesService.value = List<bool>.filled(serviceList.length, false);
    await GetServiceTypeList();
    await GetServiceList();
    await GetAddressList();
    await GetCarList();
    await GetAppointmentList();
    await getAccount();
    super.onInit();
  }

  @override
  void Close() {
    print('on close second');
    super.onClose();
  }

  void updateDate(DateTime newDate) {
    selectedDate.value = newDate;
  }

  void nextStep() {
    if (currentStep.value < 4) {
      currentStep.value++;
      navigateToStep();
    } else {
      BookAppointment();
      Get.snackbar('Thông báo', 'Bạn đã hoàn tất quy trình đặt dịch vụ!');
      Get.offAllNamed(Routes.home);
    }
  }

  void resetService() {
    selectedType.value == null;
    checkedValuesService.isEmpty;
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
      navigateToStep();
    } else {
      Get.back();
    }
  }

  // Điều hướng đến màn hình tương ứng với bước
  void navigateToStep() {
    switch (currentStep.value) {
      case 1:
        Get.toNamed(Routes.appointmentbook);
        break;
      case 2:
        Get.toNamed(Routes.appointmentplace);
        break;
      case 3:
        Get.toNamed(Routes.appointmenttime);
        break;
      case 4:
        Get.toNamed(Routes.appointmentconfirm);
        break;
    }
  }

  getAccount() async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);

    var param = {
      "keyCert":
          Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "email": emailAcc,
    };

    try {
      var response = await APICaller.getInstance()
          .post('/Account/account_detail.php', param);
      if (response != null && response['data'] != null) {
        account.value = AccountModel.fromJson(response['data']);
      }
    } catch (e) {
      // debugPrint("Lỗi API: $e", wrapWidth: 1024);
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  GetServiceTypeList() async {
    typeList.clear();
    try {
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
      };
      var data = await APICaller.getInstance()
          .post('Book/get_type_service.php', param);
      if (data != null) {
        List<dynamic> list = data['items'];
        var listItem = list
            .map((dynamic json) => TypeServiceModel.fromJson(json))
            .toList();
        typeList.addAll(listItem);
      }
    } catch (e) {
      // debugPrint("Lỗi API: $e", wrapWidth: 1024);
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  GetServiceList() async {
    serviceList.clear();
    try {
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
      };
      var data =
          await APICaller.getInstance().post('Book/get_service.php', param);
      if (data != null) {
        List<dynamic> list = data['items'];
        var listItem =
            list.map((dynamic json) => ServiceModel.fromJson(json)).toList();
        serviceList.addAll(listItem);

        // Khởi tạo trạng thái checkbox
        checkedValuesService.value =
            List<bool>.filled(serviceList.length, false);
      }
    } catch (e) {
      //debugPrint("Lỗi API: $e", wrapWidth: 1024);
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  List<ServiceModel> get selectedServices {
    List<ServiceModel> selected = [];
    for (int i = 0; i < checkedValuesService.length; i++) {
      if (checkedValuesService[i]) {
        selected.add(serviceList[i]);
      }
    }
    return selected;
  }

  GetAddressList() async {
    centerList.clear();
    try {
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
      };
      var data =
          await APICaller.getInstance().post('Book/get_center.php', param);
      if (data != null) {
        List<dynamic> list = data['items'];
        var listItem =
            list.map((dynamic json) => CenterModel.fromJson(json)).toList();
        centerList.addAll(listItem);
      }
    } catch (e) {
      // debugPrint("Lỗi API: $e", wrapWidth: 1024);
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  GetCarList() async {
    carList.clear();
    try {
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "email": emailAcc,
      };
      var data = await APICaller.getInstance().post('Car/get_car.php', param);
      if (data != null) {
        List<dynamic> list = data['items'];
        var listItem =
            list.map((dynamic json) => CarModel.fromJson(json)).toList();
        carList.addAll(listItem);
      }
    } catch (e) {
      // debugPrint("Lỗi API: $e", wrapWidth: 1024);
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  GetAppointmentList() async {
    appointmentList.clear();
    try {
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "email": emailAcc,
      };
      var data = await APICaller.getInstance()
          .post('Appointment/get_appointment.php', param);
      if (data != null) {
        List<dynamic> list = data['items'];
        var listItem = list
            .map((dynamic json) => AppointmentModel.fromJson(json))
            .toList();
        appointmentList.addAll(listItem);
      }
    } catch (e) {
      // debugPrint("Lỗi API: $e", wrapWidth: 1024);
      // Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  Future<void> BookAppointment() async {
    try {
      // Lấy danh sách serviceIds từ serviceList và checkedValuesService
      List<int> serviceIds = [];
      for (int i = 0; i < serviceList.length; i++) {
        if (checkedValuesService[i]) {
          if (serviceList[i].service_id != null) {
            serviceIds.add(int.parse(serviceList[i].service_id!));
          }
        }
      }

      isLoading.value = true;
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "email": emailAcc,
        "carr_id": selectedCar.value?.car_id,
        "gara_id": selectedAddress.value?.gara_id,
        "appointment_date": DateFormat('yyyy-MM-dd').format(selectedDate.value),
        "appointment_time": selectedTime.value,
        "description": description.value,
        "status": 0,
        "serviceIds": serviceIds,
      };

      var data = await APICaller.getInstance()
          .post('Book/book_appointment.php', param);
      if (data != null && data['status'] == 'success') {
        String appointmentId = data['items']['appointment_id'].toString();
        Utils.showSnackBar(
          title: 'notification'.tr,
          message: "Đặt lịch thành công với ID: $appointmentId",
        );
        Get.offAllNamed(Routes.appointmentlist);
        // Get.offAllNamed(Routes.appointmentlist, arguments: {
        //   'appointmentId': appointmentId, // Truyền appointmentId nếu cần
        // });
      } else {
        Utils.showSnackBar(
          title: 'Thông báo',
          message: data?['error']['message'] ?? 'Đặt lịch thất bại',
        );
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: 'Lỗi: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
