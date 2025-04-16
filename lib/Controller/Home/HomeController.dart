import 'dart:async';
import 'package:app_hm/Global/Constant.dart';

import 'package:app_hm/Services/APICaller.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxBool isShowOverview = true.obs;
  DateTime timeNow = DateTime.now();
  RxBool isLoading = false.obs;
  RxBool isExpanded = false.obs;
  TextEditingController textSearchCompanyUuid = TextEditingController();
  TextEditingController textSearch = TextEditingController();
  // RxList<Chartmodel> chartList = RxList<Chartmodel>();

  // RxList<ProductWeight> productweightList = <ProductWeight>[].obs;
  // RxList<QualityWeight> qualityweightList = <QualityWeight>[].obs;
  // RxList<SpecWeight> specweightList = <SpecWeight>[].obs;

  ScrollController scrollController = ScrollController();
  String username = '';
  RxList<String> teamSelectList = RxList<String>();
  RxInt isState = (-1).obs;

  @override
  void onInit() async {
    username = await Utils.getStringValueWithKey(Constant.USERNAME);
    int uidAcc = await Utils.getIntValueWithKey(Constant.UUID_USER_ACC);

    isLoading.value = false;
    super.onInit();
  }

  @override
  void onClose() {
    print('on close second');
    super.onClose();
  }

  Color parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return Colors.black; // Màu mặc định nếu null hoặc rỗng
    }
    if (colorString.startsWith('#')) {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    }
    return Colors.black; // Màu mặc định nếu không hợp lệ
  }

  String formatTime(int totalMinutes) {
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    String formattedHours = hours > 0 ? '$hours ${'minute'.tr} ' : '';
    String formattedMinutes = minutes > 0 ? '$minutes ${'seconds'.tr} ' : '';
    return '$formattedHours$formattedMinutes';
  }

  // getDashboardWarehouse() async {
  //   productweightList.clear();
  //   qualityweightList.clear();
  //   specweightList.clear();
  //   try {
  //     String formattedTime =
  //         DateFormat('MM/dd/yyyy HH:mm:ss').format(DateTime.now());

  //     var param = {
  //       "keyCert":
  //           Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
  //       "time": formattedTime,
  //       "companyUuid": "",
  //       "typeProduct": 0,
  //     };

  //     var data = await APICaller.getInstance()
  //         .post('v1/Warehouse/dashbroad-warehouse', param);
  //     if (data is Map && data['data'] != null) {
  //       var detailWarehouseSpec = data['data']['detailWarehouseSpec'];
  //       if (detailWarehouseSpec is List && detailWarehouseSpec.isNotEmpty) {
  //         var firstSpec = detailWarehouseSpec.first;
  //         if (firstSpec is Map) {
  //           if (firstSpec['productWeight'] is List) {
  //             List<dynamic> productWeight = firstSpec['productWeight'];
  //             var listItem = productWeight
  //                 .map((dynamic json) => ProductWeight.fromJson(json))
  //                 .toList();
  //             productweightList.addAll(listItem);
  //           }
  //           if (firstSpec['qualityWeight'] is List) {
  //             List<dynamic> qualityWeight = firstSpec['qualityWeight'];
  //             var listQuality = qualityWeight
  //                 .map((dynamic jsons) => QualityWeight.fromJson(jsons))
  //                 .toList();
  //             qualityweightList.addAll(listQuality);
  //           }
  //           if (firstSpec['specWeight'] is List) {
  //             List<dynamic> specWeight = firstSpec['specWeight'];
  //             var listSpec = specWeight
  //                 .map((dynamic jsonss) => SpecWeight.fromJson(jsonss))
  //                 .toList();
  //             specweightList.addAll(listSpec);
  //           }
  //         } else {
  //           Utils.showSnackBar(
  //             title: 'notification'.tr,
  //             message: 'Dữ liệu không chứa productWeight.',
  //           );
  //         }
  //       }
  //     }

//     } catch (e) {
//       Utils.showSnackBar(
//         title: 'notification'.tr,
//         message: 'Lỗi khi gọi API: $e',
//       );
//     }
//   }

//   double get totalWeight {
//     return productweightList.fold(
//         0, (sum, item) => sum + (item.amountTotalBDMT ?? 0));
//   }
}
