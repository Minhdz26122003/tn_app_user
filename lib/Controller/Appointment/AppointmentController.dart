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
import 'package:app_hm/Services/PushNotification.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TimeSlot {
  final String label;
  final DateTime dateTime;
  bool isSelected;
  bool isBooked;

  TimeSlot(
    this.label,
    this.dateTime, {
    this.isSelected = false,
    this.isBooked = false,
  });

  bool get isPast => dateTime.isBefore(DateTime.now());
  bool get isAvailable => !isPast && !isBooked;
}

class Appointmentcontroller extends GetxController {
  int uid = 0;
  RxList<bool> checkedValuesService = <bool>[].obs;
  RxInt currentStep = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isBooking = false.obs;
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
  DateTime timeNow = DateTime.now();
  var description = ''.obs;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController cancelreason = TextEditingController();

  RxString cancelReason = ''.obs;
  RxString selectedSession = "Sáng".obs;
  RxString selectedTime = "".obs;
  RxList<TimeSlot> slots = <TimeSlot>[].obs;
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
  final pushNotifications = PushNotifications();
  @override
  void onInit() async {
    uid = await Utils.getIntValueWithKey(Constant.UUID_USER_ACC);
    isLoading.value = false;

    //everAll([selectedDate, selectedSession], (_) => buildSlots());
    buildSlots();
    checkedValuesService.value = List<bool>.filled(serviceList.length, false);
    await GetServiceTypeList();
    await GetServiceList();
    await GetAddressList();
    await GetCarList();
    // chọn xe mặc định
    if (carList.isNotEmpty) {
      selectedCar.value = carList.first;
    }
    await GetAppointmentList();

    everAll([selectedDate, selectedSession, selectedCar], (_) => buildSlots());

    // build slot lần đầu
    buildSlots();

    await getAccount();

    super.onInit();
  }

  @override
  void onClose() {
    print('on close second');
    super.onClose();
  }

  // String formatTime(String? time) {
  //   if (time == null || time.isEmpty) return '--:--';
  //   // Giả sử m.appointment_time là dạng "HH:mm:ss"
  //   final parts = time.split(':');
  //   if (parts.length >= 2) {
  //     return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  //   }
  //   return time;
  // }

  void updateDate(DateTime d) => selectedDate.value = d;

  // build slot thời gian , so sánh viwos thời gian hiện tại
  void buildSlots() {
    final labels =
        selectedSession.value == 'Sáng' ? morningTimes : afternoonTimes;
    final date = selectedDate.value;
    final carId = selectedCar.value?.car_id;

    // Lọc và chuyển về HH:mm
    final takenTimes = appointmentList
        .where((a) =>
            a.appointment_date == DateFormat('yyyy-MM-dd').format(date) &&
            a.car_id == carId)
        .map((a) {
      // a.appointment_time có dạng "08:00:00"
      final parts = a.appointment_time?.split(':') ?? [];
      // trả về giờ đã được đặt
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }).toSet();

    //print('>>> thoi gian = $takenTimes');
    final tmp = labels.map((label) {
      final parts = label.split(':');
      final dt = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
      final booked = takenTimes.contains(label);
      return TimeSlot(
        label,
        dt,
        isSelected: label == selectedTime.value,
        isBooked: booked,
      );
    }).toList();

    slots.value = tmp;
  }

  void pickTime(String label) {
    final slot = slots.firstWhere((s) => s.label == label);

    if (!slot.isAvailable) {
      // nếu đã qua hoặc đã được book, không cho chọn
      Utils.showSnackBar(
        title: 'Thông báo',
        message: slot.isPast
            ? 'Khung giờ đã qua.'
            : 'Khung giờ này đã có người đặt.',
      );
      return;
    }

    selectedTime.value = label;
    buildSlots(); // cập nhật isSelected
  }

  void nextStep() {
    if (currentStep.value < 4) {
      currentStep.value++;
      navigateToStep();
    } else {
      BookAppointment();
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
      navigateToStep();
    } else {
      Get.back();
    }
  }

  void resetService() {
    selectedType.value == null;
    checkedValuesService.isEmpty;
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

  void CancelAppoint(int appoi_id, String reason) async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    var param = {
      "keyCert":
          Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "uid": uid,
      "appointment_id": appoi_id,
      "reason": reason
    };
    try {
      var response = await APICaller.getInstance()
          .post('Appointment/cancel_appointment.php', param);
      if (response != null && response['status'] == 'success') {
        Utils.showSnackBar(
          title: 'notification'.tr,
          message: response?['error']['message'] ?? 'Hủy lịch hẹn thành công ',
        );
      }
    } catch (e) {
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  void AcceptAppoint(int appoi_id) async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    var param = {
      "keyCert":
          Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "uid": uid,
      "appointment_id": appoi_id,
    };
    try {
      var response = await APICaller.getInstance()
          .post('Appointment/accept_appointment.php', param);
      if (response != null && response['status'] == 'success') {
        Utils.showSnackBar(
          title: 'notification'.tr,
          message: response?['error']['message'] ?? 'Đã chấp nhận báo giá',
        );
        await GetAppointmentList();
      }
    } catch (e) {
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  getAccount() async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    if (uid != 0) {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "uid": uid,
      };

      try {
        var response = await APICaller.getInstance()
            .post('Account/account_detail.php', param);
        if (response != null && response['data'] != null) {
          account.value = AccountModel.fromJson(response['data']);
        }
      } catch (e) {
        debugPrint("Lỗi API: $e", wrapWidth: 1024);
        //Utils.showSnackBar(title: 'notification'.tr, message: '$e');
      }
    }
  }

  GetServiceTypeList() async {
    isLoading.value = true;
    typeList.clear();
    try {
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
      debugPrint("Lỗi API: $e", wrapWidth: 1024);
      //Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    } finally {
      isLoading.value = false;
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
          await APICaller.getInstance().post('Service/get_service.php', param);
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
          await APICaller.getInstance().post('Center/get_center.php', param);
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
    if (uid != 0) {
      isLoading.value = true;
      try {
        String formattedTime =
            DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
        var param = {
          "keyCert":
              Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
          "time": formattedTime,
          "uid": uid,
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
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> GetAppointmentList() async {
    appointmentList.clear();
    if (uid == null || uid == 0) return;

    isLoading.value = true;
    try {
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "uid": uid,
      };
      final data =
          await APICaller.getInstance().post('Appointment/getappoi.php', param);

      if (data != null && data['status'] == 'success') {
        final items = data['items'] as List<dynamic>;
        final listItem = items
            .map((json) =>
                AppointmentModel.fromJson(json as Map<String, dynamic>))
            .toList();
        appointmentList.assignAll(listItem);
      } else {
        final msg = data?['error']?['message'] ?? 'Không thể tải lịch hẹn';
        Utils.showSnackBar(title: 'Lỗi', message: msg);
      }
    } catch (e) {
      debugPrint("Lỗi API GetAppointmentList: $e");
      Utils.showSnackBar(
          title: 'Lỗi', message: 'Không thể kết nối tới máy chủ');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> BookAppointment() async {
    savetoken();
    isBooking.value = true;
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
      DateTime timeNow = DateTime.now();
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "uid": uid,
        "car_id": selectedCar.value?.car_id,
        "gara_id": selectedAddress.value?.gara_id,
        "appointment_date": DateFormat('yyyy-MM-dd').format(selectedDate.value),
        "appointment_time": selectedTime.value,
        "description": description.value,
        "status": 0,
        "reason": "",
        "serviceIds": serviceIds,
      };

      var data = await APICaller.getInstance()
          .post('Book/book_appointment.php', param);
      print("data lich hen: $param");
      if (data != null && data['status'] == 'success') {
        //String appointmentId = data['items']['appointment_id'].toString();
        // Utils.showSnackBar(
        //   title: 'notification'.tr,
        //   message: "Đặt lịch thành công với ID: $appointmentId",
        // );

        await GetAppointmentList();
        buildSlots();
        Get.offAllNamed(Routes.appointmentlist);
      } else {
        debugPrint("Lỗi API: " + data?['error']['message'], wrapWidth: 1024);
      }
    } catch (e) {
      debugPrint("Lỗi API: $e", wrapWidth: 1024);
      //Utils.showSnackBar(title: 'Thông báo', message: 'Lỗi: $e');
    } finally {
      isBooking.value = false;
    }
  }

  savetoken() async {
    try {
      int uid = await Utils.getIntValueWithKey(Constant.UUID_USER_ACC);

      await pushNotifications.saveFcmToken(uid.toString());
    } catch (e, stack) {
      debugPrint('EXCEPTION khi saveFcmToken: $e');
      debugPrint('$stack');
    }
  }
}
