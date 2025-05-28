import 'dart:async';
import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Model/Accessory/AccessoryModel.dart';
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
  // số liệu
  int uid = 0;
  RxDouble serviceTotal = 0.0.obs;
  RxDouble partsTotal = 0.0.obs;
  RxDouble totalAmount = 0.0.obs;
  RxInt currentStep = 1.obs;
  var description = ''.obs;

  // check service đã chọn
  RxList<bool> checkedValuesService = <bool>[].obs;

  // Loadding
  RxBool isLoading = false.obs;
  RxBool isLoadingSettlement = false.obs;
  RxBool isBooking = false.obs;
  var account = AccountModel().obs;

  // chuỗi
  RxString selectedSession = "Sáng".obs;
  RxString selectedTime = "".obs;

  // List
  RxList<TypeServiceModel> typeList = RxList<TypeServiceModel>();
  RxList<ServiceModel> serviceList = RxList<ServiceModel>();
  RxList<AccessoryModel> accessList = RxList<AccessoryModel>();
  RxList<AppointmentModel> appointmentList = RxList<AppointmentModel>();

  RxList<AppointmentModel> pendingAppointments = RxList<AppointmentModel>();
  RxList<AppointmentModel> historyAppointments = RxList<AppointmentModel>();

  RxList<CarModel> carList = RxList<CarModel>();
  RxList<CenterModel> centerList = RxList<CenterModel>();
  List<String> morningTimes = [
    '07:00',
    '09:00',
    '11:00',
  ];
  List<String> afternoonTimes = ['13:00', '15:00', '17:00'];
  RxList<TimeSlot> slots = <TimeSlot>[].obs;

  // theo dõi đối tượng chọn bắt đầu là null
  Rxn<CarModel> selectedCar = Rxn<CarModel>();
  Rxn<TypeServiceModel> selectedType = Rxn<TypeServiceModel>();
  Rxn<CenterModel> selectedAddress = Rxn<CenterModel>();
  Rx<DateTime> selectedDate = DateTime.now().obs;

  // text field
  TextEditingController descriptionController = TextEditingController();
  TextEditingController cancelreason = TextEditingController();

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
    await getServiceTypeList();
    await getServiceList();
    await getAddressList();
    await getCarList();
    // chọn xe mặc định
    if (carList.isNotEmpty) {
      selectedCar.value = carList.first;
    }
    await getAppointmentList();

    everAll([selectedDate, selectedSession], (_) => buildSlots());
    await buildSlots();

    await getAccount();

    super.onInit();
  }

  @override
  void onClose() {
    print('on close second');
    super.onClose();
  }

  void updateDate(DateTime d) => selectedDate.value = d;

  // build slot thời gian , so sánh với thời gian hiện tại
  Future<void> buildSlots() async {
    // Thêm isLoading ở đây để hiển thị trạng thái tải cho các slots
    isLoading.value = true;

    final labels =
        selectedSession.value == 'Sáng' ? morningTimes : afternoonTimes;
    final date = selectedDate.value;

    List<TimeSlot> tempSlots = [];

    for (String label in labels) {
      final parts = label.split(':');
      final dt = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      // Gọi API mà không truyền car_id
      bool isBooked = await _checkAppointmentAvailability(
        DateFormat('yyyy-MM-dd').format(date),
        label,
      );

      tempSlots.add(TimeSlot(
        label,
        dt,
        isSelected: label == selectedTime.value,
        isBooked: isBooked,
      ));
    }
    slots.value = tempSlots;
    isLoading.value = false; // Tắt loading sau khi hoàn thành
  }

  // Hàm _checkAppointmentAvailability (không thay đổi so với phiên bản trước)
  Future<bool> _checkAppointmentAvailability(
      String appointmentDate, String appointmentTime) async {
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    var param = {
      "keyCert":
          Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "appointment_date": appointmentDate,
      "appointment_time": appointmentTime,
    };

    try {
      var response = await APICaller.getInstance()
          .post('Appointment/check_time.php', param);
      if (response != null && response['status'] == 'success') {
        return response['is_booked'] ?? false;
      } else {
        debugPrint(
            "Lỗi khi kiểm tra khả dụng: ${response?['error']['message'] ?? 'Không rõ lỗi'}");
        return false;
      }
    } catch (e) {
      debugPrint("Lỗi API checkAppointmentAvailability: $e");
      return false;
    }
  }

  void pickTime(String label) {
    final slot = slots.firstWhere((s) => s.label == label);

    if (!slot.isAvailable) {
      Utils.showSnackBar(
        title: 'Thông báo',
        message: slot.isPast
            ? 'Khung giờ đã qua.'
            : 'Khung giờ này đã có người đặt.',
      );
      return;
    }

    selectedTime.value = label;
    // Cập nhật isSelected mà không gọi lại buildSlots để tránh gọi lại API không cần thiết
    slots.value = slots
        .map((s) => TimeSlot(s.label, s.dateTime,
            isSelected: s.label == label, isBooked: s.isBooked))
        .toList()
        .obs;
  }

  void nextStep() {
    if (currentStep.value < 4) {
      currentStep.value++;
      navigateToStep();
    } else {
      Utils.showSnackBar(
          title: 'notification'.tr, message: 'Hãy hoàn tất đặt lịch');
      // bookAppointment();
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
    selectedCar.value == null;
    selectedAddress.value == null;
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

  // Hủy lịch hẹn
  void cancelAppoint(int appoiId, String reason) async {
    if (cancelreason.text.trim().isEmpty) {
      Utils.showSnackBar(title: 'notification'.tr, message: 'Hãy nhập lý do');
    }
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    var param = {
      "keyCert":
          Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "uid": uid,
      "appointment_id": appoiId,
      "reason": reason
    };

    try {
      var response = await APICaller.getInstance()
          .post('Appointment/cancel_appointment.php', param);
      //print("data huy: $param");
      if (response != null && response['status'] == 'success') {
        Utils.showSnackBar(
          title: 'notification'.tr,
          message: response?['error']['message'] ?? 'Hủy lịch hẹn thành công ',
        );
        await getAppointmentList();
      }
    } catch (e) {
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  // Chấp nhận báo giá
  void acceptQuote(int appoiId) async {
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    var param = {
      "keyCert":
          Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "uid": uid,
      "appointment_id": appoiId,
    };
    try {
      var response = await APICaller.getInstance()
          .post('Appointment/accept_quote.php', param);
      if (response != null && response['status'] == 'success') {
        Utils.showSnackBar(
          title: 'notification'.tr,
          message: response?['error']['message'] ?? 'Đã chấp nhận báo giá',
        );
        await getAppointmentList();
      }
    } catch (e) {
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  // Chấp nhận bill
  Future<void> acceptBill(int appoiId) async {
    isLoadingSettlement.value = true;
    try {
      DateTime now = DateTime.now();
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(now);
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "uid": uid,
        "appointment_id": appoiId,
      };
      final response = await APICaller.getInstance()
          .post('Appointment/accept_bill.php', param);

      if (response != null || response['status'] == 'success') {
        // lưu hóa đơn
        final total = totalAmount.value;
        await addPayment(appoiId, total);

        Utils.showSnackBar(
          title: 'notification'.tr,
          message: 'Đã xác nhận thành công',
        );
        await getAppointmentList();
      } else {
        final msg =
            response['error']?['message'] ?? 'Chấp nhận hoá đơn thất bại';
        debugPrint("Lỗi response acceptBill: $msg", wrapWidth: 1024);
      }
    } catch (e) {
      debugPrint("Lỗi API acceptBill: $e", wrapWidth: 1024);
      // Utils.showSnackBar(
      //   title: 'notification'.tr,
      //   message: e.toString(),
      // );
    } finally {
      isLoadingSettlement.value = false;
    }
  }

  getAccount() async {
    DateTime timeNow = DateTime.now();
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
        //debugPrint("Lỗi API: $e", wrapWidth: 1024);
        Utils.showSnackBar(title: 'notification'.tr, message: '$e');
      }
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
      //debugPrint("Lỗi API getServiceTypeList : $e", wrapWidth: 1024);
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
    // finally {
    //   isLoading.value = false;
    // }
  }

  getServiceList() async {
    serviceList.clear();
    isLoading.value = true;
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
        // debugPrint('Phản hồi từ getServiceList API: $data', wrapWidth: 1024);
        checkedValuesService.value =
            List<bool>.filled(serviceList.length, false);
      }
    } catch (e) {
      //debugPrint("Lỗi API getServiceList: $e", wrapWidth: 1024);
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    } finally {
      isLoading.value = false;
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

  getAddressList() async {
    centerList.clear();
    try {
      DateTime timeNow = DateTime.now();
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
      //debugPrint("Lỗi API: $e", wrapWidth: 1024);
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  Future<void> getCarList() async {
    carList.clear(); // Xóa danh sách cũ trước khi tải lại
    if (uid != 0) {
      isLoading.value = true;
      try {
        DateTime timeNow = DateTime.now();
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
          // Cập nhật selectedCar nếu cần, ví dụ chọn xe đầu tiên sau khi load
          if (selectedCar.value == null && carList.isNotEmpty) {
            selectedCar.value = carList.first;
          }
        }
      } catch (e) {
        //debugPrint("Lỗi API: $e", wrapWidth: 1024);
        Utils.showSnackBar(title: 'notification'.tr, message: '$e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> getAppointmentList() async {
    if (uid == 0) {
      return;
    }

    isLoading.value = true;
    try {
      DateTime timeNow = DateTime.now();
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "uid": uid,
      };
      var data = await APICaller.getInstance()
          .post('Appointment/get_appointment.php', param);
      if (data != null && data['status'] == 'success') {
        List<dynamic> list = data['items'];
        var allAppointments = list
            .map((dynamic json) => AppointmentModel.fromJson(json))
            .toList();
        //print('datta lich hen: $data');
        // Xóa danh sách cũ trước khi cập nhật
        pendingAppointments.clear();
        historyAppointments.clear();
        appointmentList.clear(); // Đảm bảo làm sạch list chính
        for (var appointment in allAppointments) {
          if (appointment.status == 0 ||
              appointment.status == 1 ||
              appointment.status == 2 ||
              appointment.status == 3 ||
              appointment.status == 4 ||
              appointment.status == 5 ||
              appointment.status == 6) {
            pendingAppointments.add(appointment);
          } else {
            historyAppointments.add(appointment);
          }
        }
      }
    } catch (e) {
      //debugPrint('Lỗi API getAppointmentList: $e');
      Utils.showSnackBar(
          title: 'Lỗi', message: 'Không thể kết nối tới máy chủ');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> bookAppointment() async {
    savetoken();
    isBooking.value = true;
    try {
      // Lấy danh sách serviceIds từ serviceList và checkedValuesService
      List<int> serviceIds = [];
      for (int i = 0; i < serviceList.length; i++) {
        if (checkedValuesService[i]) {
          if (serviceList[i].service_id != null) {
            serviceIds.add(serviceList[i].service_id!);
          }
        }
      }

      DateTime timeNow = DateTime.now();
      //debugPrint('🔥 bookAppointment called at $timeNow');
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
      //print("data lich hen: $param");
      if (data != null && data['status'] == 'success') {
        String appointmentId = data['items']['appointment_id'].toString();
        // Utils.showSnackBar(
        //   title: 'notification'.tr,
        //   message: "Đặt lịch thành công với ID: $appointmentId",
        // );

        await getAppointmentList();
        buildSlots();

        final apptDT = DateTime(
          selectedDate.value.year,
          selectedDate.value.month,
          selectedDate.value.day,
          int.parse(selectedTime.value.split(':')[0]),
          int.parse(selectedTime.value.split(':')[1]),
        );

        await PushNotifications.scheduleReminders(
          uid,
          apptDT,
          title: 'Nhắc nhở lịch hẹn #$appointmentId',
          body: 'Bạn có lịch hẹn được đặt vào lúc '
              '${DateFormat('HH:mm dd/MM/yyyy').format(apptDT)}',
        );
        Get.offAllNamed(Routes.appointmentlist);
      } else {
        debugPrint("Lỗi APIdl: " + data?['error']['message'], wrapWidth: 1024);
      }
    } catch (e) {
      debugPrint("Lỗi APIdl2: $e", wrapWidth: 1024);
      //Utils.showSnackBar(title: 'Thông báo', message: 'Lỗi: $e');
    } finally {
      isBooking.value = false;
    }
  }

  Future<void> getSettlementUser(int appointmentId) async {
    serviceList.clear();
    accessList.clear();
    isLoadingSettlement.value = true;

    if (uid == 0) return;
    try {
      DateTime now = DateTime.now();
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(now);
      String keyCert =
          Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime);

      var params = {
        "keyCert": keyCert,
        "time": formattedTime,
        "uid": uid,
        "appointment_id": appointmentId,
      };

      final data = await APICaller.getInstance()
          .post('Payment/get_payment_detail.php', params);
      //print('list $data');
      if (data != null && data['status'] == 'success') {
        // Parse services
        final svs = (data['data']['services'] as List<dynamic>)
            .map((e) => ServiceModel.fromJson(e))
            .toList();
        serviceList.assignAll(svs);

        // Parse parts
        final pts = (data['data']['parts'] as List<dynamic>)
            .map((e) => AccessoryModel.fromJson(e))
            .toList();
        accessList.assignAll(pts);

        // Tổng tiền
        serviceTotal.value = (data['data']['service_total'] as num).toDouble();
        partsTotal.value = (data['data']['parts_total'] as num).toDouble();
        totalAmount.value = (data['data']['total'] as num).toDouble();
      } else {
        final msg =
            data?['error']?['message'] ?? 'Không thể tải thông tin thanh toán';
        Utils.showSnackBar(title: 'Lỗi', message: msg);
      }
    } catch (e) {
      debugPrint('Lỗi API getSettlementUser: $e');
      // Utils.showSnackBar(
      //     title: 'Lỗi', message: 'Không thể kết nối tới máy chủ');
    } finally {
      isLoadingSettlement.value = false;
    }
  }

  Future<void> addPayment(int appoiId, double total) async {
    DateTime t = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(t);
    String keyCert =
        Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime);

    var param = {
      "keyCert": keyCert,
      "time": formattedTime,
      "uid": uid,
      "appointment_id": appoiId,
      "form": 0, // 0 = online, 1 = offline...
      "status": 0, // 0 = chưa thanh toán, 1 = đã thanh toán
      "total_price": total,
    };

    final data =
        await APICaller.getInstance().post('Payment/add_payment.php', param);

    if (data != null && data['status'] == 'success') {
      String payment_id = data['items']['payment_id'].toString();
      print('message $payment_id');
    } else {
      final msg = data?['error']?['message'] ?? 'Lỗi server';
      debugPrint("Lỗi API getServiceList: $msg", wrapWidth: 1024);
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
