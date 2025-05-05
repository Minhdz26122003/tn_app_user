import 'dart:async';

import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Model/Car/CarModel.dart';
import 'package:app_hm/Services/APICaller.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Carcontroller extends GetxController {
  int uid = 0;
  String emailAcc = "";
  DateTime timeNow = DateTime.now();
  RxBool isLoading = false.obs;
  RxBool isShowOverview = false.obs;
  RxBool isChecked = false.obs;
  RxList<CarModel> carList = RxList<CarModel>();
  CarModel car = CarModel();
  TextEditingController textLicensePlate = TextEditingController();
  TextEditingController textName = TextEditingController();
  TextEditingController textManufacturer = TextEditingController();
  TextEditingController textYearManufacturer = TextEditingController();

  RxList<bool> checkedValues = <bool>[].obs;
  final RxBool isExpanded = false.obs;
  Timer? _debounce;
  final _plateRegEx = RegExp(r'^\d{2}[A-Z]\-\d{5}$');
  TextEditingController textSearch = TextEditingController();
  int totalCount = 0;
  int page = 0;
  int pageSize = 20;
  int totalPage = 0;

  // Filter
  RxBool isSearchLoading = false.obs;
  RxList<CarModel> searchList = RxList<CarModel>();
  RxList<String> selectList = RxList<String>();

  ScrollController scrollController = ScrollController();
  RxBool isTruckLoading = false.obs;

  RxString selectedStatus = ''.obs;

  @override
  void onInit() async {
    uid = await Utils.getIntValueWithKey(Constant.UUID_USER_ACC);
    emailAcc = await Utils.getStringValueWithKey(Constant.EMAIL);

    // scrollController.addListener(() {
    //   if (scrollController.position.pixels ==
    //       scrollController.position.maxScrollExtent) {
    //     if (totalPage > page) {
    //       page++;
    //       GetCarList();
    //     }
    //   }
    // });

    await GetCarList();
    setCar();
    isLoading.value = false;
    super.onInit();
  }

  @override
  void onClose() {
    print('on close second');
    super.onClose();
  }

  // Hàm tìm kiếm và lọc
  void searchAndFilterTrucks() {
    String keyword = textSearch.text.toLowerCase();
    // Lọc danh sách truck dựa trên từ khóa và trạng thái
    searchList.value = carList.where((car) {
      bool matchesKeyword = car.license_plate!.toLowerCase().contains(keyword);
      // bool matchesStatus = status.isEmpty ||
      //     (status == 1 && truck.status == 1) ||
      //     (status == 0 && truck.status == 0);
      // return matchesKeyword && matchesStatus;
      return matchesKeyword;
    }).toList();
  }

  onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      refreshData();
    });
  }

  refreshData() async {
    page = 1;
    carList.clear();
    await GetCarList();
  }

  void clearData() {
    textLicensePlate.clear();
    textManufacturer.clear();
    textName.clear();
    textYearManufacturer.clear();
  }

  setCar() {
    textLicensePlate.text = car.license_plate ?? '';
    textName.text = car.name ?? '';
    textManufacturer.text = car.manufacturer ?? '';
    textYearManufacturer.text = car.year_manufacture ?? '';
  }

  Future<void> GetCarList() async {
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
        //debugPrint("Lỗi API: $e", wrapWidth: 1024);
        Utils.showSnackBar(title: 'notification'.tr, message: '$e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> AddCar() async {
    final plate = textLicensePlate.text.trim().toUpperCase();
    if (!_plateRegEx.hasMatch(plate)) {
      Utils.showSnackBar(
        title: 'notification'.tr,
        message: 'Biển số không hợp lệ. Ví dụ: 30A-56789',
      );
      return;
    }
    if (textManufacturer.text.isEmpty) {
      Utils.showSnackBar(
        title: 'notification'.tr,
        message: 'enter_manufacturer'.tr,
      );
      return;
    }
    if (textYearManufacturer.text.isEmpty) {
      Utils.showSnackBar(
        title: 'notification'.tr,
        message: 'enter_year_manufacture'.tr,
      );
      return;
    }

    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    final keyCert =
        Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime);
    final param = {
      "keyCert": keyCert,
      "time": formattedTime,
      "uid": uid,
      "license_plate": plate,
      "name": textName.text.trim(),
      "manufacturer": textManufacturer.text.trim(),
      "year_manufacture": textYearManufacturer.text.trim(),
    };

    try {
      final response =
          await APICaller.getInstance().post('Car/add_car.php', param);
      if (response['status'] == 'success' || response['error']?['code'] == 0) {
        Utils.showSnackBar(
          title: 'Thông báo',
          message: 'thanh cong'.tr,
        );
        clearData();
        await GetCarList();
      } else {
        Utils.showSnackBar(
          title: 'Lỗi',
          message: response?['error']['message'] ?? 'Thêm xe thất bại',
        );
      }
    } catch (e) {
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  Future<void> updateCar() async {
    final plate = textLicensePlate.text.trim().toUpperCase();
    if (!_plateRegEx.hasMatch(plate)) {
      Utils.showSnackBar(
        title: 'notification'.tr,
        message: 'Biển số không hợp lệ. Ví dụ: 30A-56789',
      );
      return;
    }
    if (textManufacturer.text.isEmpty) {
      Utils.showSnackBar(
        title: 'notification'.tr,
        message: 'enter_manufacturer'.tr,
      );
      return;
    }
    if (textYearManufacturer.text.isEmpty) {
      Utils.showSnackBar(
        title: 'notification'.tr,
        message: 'enter_year_manufacture'.tr,
      );
      return;
    }

    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    final keyCert =
        Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime);
    final param = {
      "keyCert": keyCert,
      "time": formattedTime,
      "car_id": car.car_id.toString(),
      "license_plate": plate,
      "name": textName.text.trim(),
      "manufacturer": textManufacturer.text.trim(),
      "year_manufacture": textYearManufacturer.text.trim(),
    };

    try {
      final response =
          await APICaller.getInstance().post('Car/edit_car.php', param);
      if (response['status'] == 'success' || response['error']?['code'] == 0) {
        Utils.showSnackBar(title: 'notification'.tr, message: 'thanh cong');
        clearData();
        await GetCarList();
      } else {
        Utils.showSnackBar(
          title: 'Lỗi',
          message: response?['error']['message'] ?? 'Cập nhật xe thất bại',
        );
      }
    } catch (e) {
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  Future<void> deleteCar(int carId) async {
    isLoading.value = true;
    try {
      String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(timeNow);

      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "car_id": carId.toString(),
      };

      var response =
          await APICaller.getInstance().post('Car/delete_car.php', param);

      if (response != null && response['error']['code'] == 0) {
        carList.removeWhere((c) => c.car_id == carId);
        Utils.showSnackBar(
          title: 'Thông báo',
          message: 'Xoa thanh cong'.tr,
        );
      } else {
        Utils.showSnackBar(
          title: 'Lỗi',
          message: response?['error']['message'] ??
              'Không thể cập nhật trạng thái xe',
        );
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
