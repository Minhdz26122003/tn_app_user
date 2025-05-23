import 'package:app_hm/Controller/ServiceC/ServiceController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Model/Service/TypeServiceModel.dart'; // Đảm bảo đã import TypeServiceModel
import 'package:app_hm/Router/AppPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import để sử dụng NumberFormat

class Servicesearch extends StatefulWidget {
  const Servicesearch({super.key});

  @override
  State<Servicesearch> createState() => _ServicesearchState();
}

class _ServicesearchState extends State<Servicesearch> {
  final Servicecontroller ctrl = Get.find<Servicecontroller>();
  late TextEditingController _searchCtrl;
  late TextEditingController _minPriceCtrl;
  late TextEditingController _maxPriceCtrl;
  // Sử dụng FocusNode để phát hiện khi TextField mất focus
  late FocusNode _minPriceFocusNode;
  late FocusNode _maxPriceFocusNode;

  @override
  void initState() {
    super.initState();

    _searchCtrl = TextEditingController(text: ctrl.query.value);
// Khởi tạo TextControllers với giá trị đã format
    _minPriceCtrl =
        TextEditingController(text: ctrl.formatCurrency(ctrl.minPrice.value));
    _maxPriceCtrl =
        TextEditingController(text: ctrl.formatCurrency(ctrl.maxPrice.value));

    // Khởi tạo FocusNodes
    _minPriceFocusNode = FocusNode();
    _maxPriceFocusNode = FocusNode();

    // Lắng nghe sự thay đổi của TextField và cập nhật Rx variables trong controller
    _searchCtrl.addListener(() {
      ctrl.query.value = _searchCtrl.text;
    });

    // Listener cho minPriceCtrl: Cập nhật giá trị số khi nhập liệu
    _minPriceCtrl.addListener(() {
      // Khi người dùng nhập, chỉ cập nhật giá trị số trong controller
      // Không format lại ngay lập tức để tránh làm gián đoạn quá trình nhập
      ctrl.minPrice.value = ctrl.parseCurrency(_minPriceCtrl.text);
    });
    // Listener cho maxPriceCtrl: Cập nhật giá trị số khi nhập liệu
    _maxPriceCtrl.addListener(() {
      ctrl.maxPrice.value = ctrl.parseCurrency(_maxPriceCtrl.text);
    });

    // Listener cho FocusNode của minPrice: Format lại khi mất focus
    _minPriceFocusNode.addListener(() {
      if (!_minPriceFocusNode.hasFocus) {
        // TextField mất focus, cập nhật lại với định dạng tiền tệ
        String formatted = ctrl.formatCurrency(ctrl.minPrice.value);
        if (_minPriceCtrl.text != formatted) {
          // Chỉ cập nhật nếu có thay đổi
          _minPriceCtrl.text = formatted;
        }
      }
    });

    // Listener cho FocusNode của maxPrice: Format lại khi mất focus
    _maxPriceFocusNode.addListener(() {
      if (!_maxPriceFocusNode.hasFocus) {
        // TextField mất focus, cập nhật lại với định dạng tiền tệ
        String formatted = ctrl.formatCurrency(ctrl.maxPrice.value);
        if (_maxPriceCtrl.text != formatted) {
          // Chỉ cập nhật nếu có thay đổi
          _maxPriceCtrl.text = formatted;
        }
      }
    });

    // Gọi fetchAllServices() h bộ lọc được initFilters() từ trang Home.
    //ctrl.fetchAllServices();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _minPriceCtrl.dispose();
    _maxPriceCtrl.dispose();
    _minPriceFocusNode.dispose();
    _maxPriceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm kiếm dịch vụ',
            style: const TextStyle(color: Colors.white, fontSize: 17)),
        backgroundColor: ColorHex.total_color,
        leading: GestureDetector(
          onTap: () {
            // Get.offAllNamed(Routes.home);
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: ColorHex.white),
        ),
      ),
      body: Obx(() {
        if (ctrl.isLoadingTypes.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Nhập tên dịch vụ hoặc mô tả',
                  hintStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchCtrl.clear();
                    },
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Type dropdown
              Obx(() => DropdownButtonFormField<TypeServiceModel?>(
                    decoration:
                        const InputDecoration(labelText: 'Loại dịch vụ'),
                    value: ctrl.selectedType.value,
                    items: [
                      const DropdownMenuItem(
                          value: null, child: Text('Tất cả')),
                      // Sử dụng ctrl.serviceTypes và TypeServiceModel
                      ...ctrl.serviceTypes.map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.type_name ?? ""),
                          ))
                    ],
                    onChanged: (v) => ctrl.selectedType.value = v,
                    hint: const Text('Chọn loại dịch vụ'),
                  )),
              const SizedBox(height: 16),

              // Price fields
              Row(children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceCtrl,
                    focusNode: _minPriceFocusNode,
                    decoration: const InputDecoration(
                        labelText: 'Giá từ',
                        hintStyle: TextStyle(fontSize: 12)),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _maxPriceCtrl,
                    focusNode: _maxPriceFocusNode,
                    decoration: const InputDecoration(
                        labelText: 'đến', hintStyle: TextStyle(fontSize: 12)),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ]),

              const SizedBox(height: 16),

              // Time range
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Thời gian thực hiện (giờ):',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Obx(() => RangeSlider(
                        values: ctrl.timeRange.value,
                        min: 0,
                        max: 24,
                        divisions: 24 * 4, // 15 phút mỗi vạch
                        labels: RangeLabels(
                          '${ctrl.timeRange.value.start.toStringAsFixed(0)}h',
                          '${ctrl.timeRange.value.end.toStringAsFixed(0)}h',
                        ),
                        onChanged: (rv) => ctrl.timeRange.value = rv,
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Obx(() => Text(
                          'Từ: ${ctrl.timeRange.value.start.toStringAsFixed(0)}:00 - Đến: ${ctrl.timeRange.value.end.toStringAsFixed(0)}:00',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Nút Tìm kiếm
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _minPriceFocusNode.unfocus();
                    _maxPriceFocusNode.unfocus();

                    ctrl.applyFiltersAndSearch(); // Gọi hàm tìm kiếm khi nút được nhấn
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text(
                    'Tìm kiếm',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Results
              Obx(() {
                if (ctrl.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (ctrl.filteredServices.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text('Không tìm thấy dịch vụ nào phù hợp.',
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ),
                  );
                } else {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ctrl.filteredServices.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, i) {
                      final s = ctrl.filteredServices[i];
                      return ListTile(
                        leading: (s.service_img?.isNotEmpty ?? false)
                            ? Image.network(
                                s.service_img!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image,
                                        size: 60, color: Colors.grey),
                              )
                            : const SizedBox(
                                width: 60,
                                height: 60,
                                child: Icon(Icons.miscellaneous_services,
                                    size: 40, color: Colors.grey)),
                        title: Text(s.service_name ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Loại: ${ctrl.getTypeNameById(s.type_id ?? 0)}',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Thời gian: ${s.time != null ? s.time!.substring(0, 5) : "N/A"}',
                              style: TextStyle(fontSize: 12),
                            ), // Hiển thị HH:mm
                            Text(s.description ?? "",
                                style: const TextStyle(fontSize: 11),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                        trailing: Text(
                          ctrl.formatCurrency(s.price),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        onTap: () =>
                            Get.toNamed(Routes.servicedetail, arguments: s),
                      );
                    },
                  );
                }
              }),
            ],
          ),
        );
      }),
    );
  }
}
