import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Model/Service/ServiceModel.dart';
import 'package:app_hm/Model/Service/TypeServiceModel.dart'; // Đảm bảo đã import TypeServiceModel
import 'package:app_hm/Services/APICaller.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart'; // Thêm để sử dụng RangeValues

class Servicecontroller extends GetxController {
  RxBool isDescriptionExpanded = true.obs;

  // Filters
  final RxString query = ''.obs;
  final Rxn<TypeServiceModel> selectedType = Rxn<TypeServiceModel>();
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = double.infinity.obs; // Vô cực cho giá tối đa
  final Rx<RangeValues> timeRange =
      const RangeValues(0, 24).obs; // Khoảng thời gian từ 0 đến 24 giờ

  final RxBool isLoading = false.obs;
  final RxBool isLoadingTypes = false.obs;

  // Raw data from API
  final RxList<Service> allServices = <Service>[].obs;
  // Filtered results (API sẽ trả về kết quả đã lọc)
  final RxList<Service> filteredServices = <Service>[].obs;

  // Danh sách tất cả các loại dịch vụ có sẵn
  final RxList<TypeServiceModel> serviceTypes = <TypeServiceModel>[].obs;

  int uid = 0;

  String formatCurrency(double? amount) {
    if (amount == null || amount == double.infinity)
      return ''; // Hiển thị rỗng cho giá vô cực

    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0)
        .format(amount);
  }

  double parseCurrency(String formattedString) {
    String cleanString = formattedString.replaceAll(RegExp(r'[^\d]'), '');
    return double.tryParse(cleanString) ?? 0.0;
  }

  @override
  Future<void> onInit() async {
    uid = await Utils.getIntValueWithKey(Constant.UUID_USER_ACC);
    await getServiceTypeList();

    super.onInit();
  }

  // Hàm tải danh sách loại dịch vụ
  Future<void> getServiceTypeList() async {
    // isLoadingTypes.value = true;
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
      if (data != null &&
          data['status'] == 'success' &&
          data['error']['code'] == 0) {
        final items = data['items'] as List<dynamic>;
        serviceTypes.assignAll(items
            .map((e) => TypeServiceModel.fromJson(e as Map<String, dynamic>))
            .toList());
      } else {
        Utils.showSnackBar(
            title: 'Thông báo',
            message:
                'Lỗi khi tải loại: ${data?['error']?['message'] ?? 'Vui lòng thử lại.'}');
      }
    } catch (e) {
      // Utils.showSnackBar(
      //     title: 'Thông báo', message: 'Lỗi khi tải loại dịch vụ: $e');
      debugPrint('Phản hồi từ aaatServiceList API: $e', wrapWidth: 1024);
    }
    // finally {
    //   isLoadingTypes.value = false;
    // }
  }

  // Hàm chính để tìm kiếm dịch vụ với các bộ lọc
  Future<void> fetchAllServices() async {
    isLoading.value = true;
    try {
      final now = DateTime.now();
      final formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(now);
      final keyCert =
          Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime);

      double? finalMinPrice = minPrice.value == 0.0 ? null : minPrice.value;
      double? finalMaxPrice =
          maxPrice.value == double.infinity ? null : maxPrice.value;

      // Lấy giờ bắt đầu và giờ kết thúc từ RangeValues
      int startHour = timeRange.value.start.round();
      int endHour = timeRange.value.end.round();

      String finalMinTime = '${startHour.toString().padLeft(2, '0')}:00:00';
      String finalMaxTime;

      if (endHour == 24) {
        finalMaxTime = '23:59:59';
      } else {
        //  N giờ (ví dụ N=1 cho 0-1h), 00:00:00 đến (N-1):59:59.

        finalMaxTime = '${(endHour - 1).toString().padLeft(2, '0')}:59:59';
      }

      final Map<String, dynamic> params = {
        'keyCert': keyCert,
        'time': formattedTime,
        'uid': uid,
        'query': query.value,
        'min_price': finalMinPrice,
        'max_price': finalMaxPrice,
        'type_id': selectedType.value?.type_id,
        'min_time': finalMinTime,
        'max_time': finalMaxTime,
      };

      params.removeWhere((key, value) => value == null);

      final data = await APICaller.getInstance()
          .post('Service/search_service.php', params);
      if (data != null && data['status'] == 'success') {
        final items = data['items'] as List<dynamic>;
        allServices.assignAll(items
            .map((e) => Service.fromJson(e as Map<String, dynamic>))
            .toList());
        filteredServices.assignAll(allServices);
      } else {
        allServices.clear();
        filteredServices.clear();
        print(
            "Lỗi khi fetchAllServices: ${data?['error']?['message'] ?? 'Unknown error'}");
        Utils.showSnackBar(
            title: 'Lỗi',
            message: 'Lỗi khi tìm kiếm , vui lòng thực hiện lại thao tác!');
      }
    } catch (e) {
      allServices.clear();
      filteredServices.clear();
      // print("Lỗi khi fetchAllServices: $e");
      // Utils.showSnackBar(
      //     title: 'Lỗi', message: 'Không thể tải danh sách dịch vụ: $e');
      debugPrint("Lỗi API Không: $e", wrapWidth: 1024);
    } finally {
      isLoading.value = false;
    }
  }

  void applyFiltersAndSearch() {
    fetchAllServices();
  }

  String getTypeNameById(int typeId) {
    return serviceTypes
            .firstWhereOrNull((type) => type.type_id == typeId)
            ?.type_name ??
        'Không xác định';
  }

  void initFilters({String? initialQuery}) {
    query.value = initialQuery ?? '';
    selectedType.value = null;
    minPrice.value = 0.0;
    maxPrice.value = double.infinity;
    timeRange.value = const RangeValues(0, 24);
    filteredServices.clear();
    allServices.clear();
  }
}
