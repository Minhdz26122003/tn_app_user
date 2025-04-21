import 'package:app_hm/Controller/Car/CarController.dart';
import 'package:app_hm/Model/Car/CarModel.dart';
import 'package:app_hm/View/Car/AddCar.dart';
import 'package:app_hm/View/Car/EditCar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Car extends StatelessWidget {
  const Car({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Carcontroller());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D74FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined),
          color: Colors.white,
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Quản lý xe',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
      ),
      body: Obx(
        () => (controller.isLoading.value)
            ? const Center(child: CircularProgressIndicator())
            : controller.carList == null // Kiểm tra null
                ? const Center(child: Text("Dữ liệu không khả dụng"))
                : Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            color: const Color.fromARGB(255, 238, 238, 238),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 20.0),
                              child: TextField(
                                controller: controller.textSearch,
                                onChanged: (value) =>
                                    controller.onSearchChanged(),
                                decoration: InputDecoration(
                                  hintText: "Nhập từ khóa tìm kiếm...",
                                  hintStyle: const TextStyle(fontSize: 14),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: GestureDetector(
                                      onTap: () => bottomSheetFilter(
                                          context: context,
                                          controller: controller),
                                      child: SvgPicture.asset(
                                        'assets/icons/filter.svg',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: Get.width,
                            color: const Color.fromARGB(255, 238, 238, 238),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "DANH SÁCH XE:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  "${controller.carList.length}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Obx(
                            () => (controller.carList.isEmpty)
                                ? Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: const Center(
                                        child: Text("Không có dữ liệu")),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      controller: controller.scrollController,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 10),
                                      itemCount: controller.carList.length,
                                      itemBuilder: (context, index) {
                                        return _buildVehicleCard(
                                            index, controller);
                                      },
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 20.0,
                        right: 20.0,
                        child: GestureDetector(
                          onTap: () => Get.to(() => const AddCar()),
                          child: const CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildVehicleCard(int index, Carcontroller controller) {
    final car = controller.carList[index];
    return Card(
      margin: const EdgeInsets.only(top: 6, left: 2, right: 5, bottom: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        leading: SvgPicture.asset(
          'assets/icons/car-icon.svg',
          width: 64,
          height: 64,
        ),
        title: Text(
          car.license_plate ?? '',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${'loại_xe'.tr}: ${car.name}',
                style: const TextStyle(fontSize: 12)),
            Text('${'hãng_sx'.tr}: ${car.manufacturer}',
                style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Trong nút Edit
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: () {
                final car = controller.carList[index];
                Get.to(() => EditCar(), arguments: car);
              },
            ),

            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                Get.dialog(
                  Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Xác nhận',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Bạn có chắc chắn muốn xóa chiếc xe này?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Get.back(),
                                  style: OutlinedButton.styleFrom(
                                    side:
                                        BorderSide(color: Colors.grey.shade300),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                  ),
                                  child: Text(
                                    'Hủy bỏ',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Get.back();
                                    await controller.deleteCar(
                                        controller.carList[index].car_id!);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                  ),
                                  child: const Text(
                                    'Xóa',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  void bottomSheetFilter({
    required BuildContext context,
    required Carcontroller controller,
  }) async {
    RxList<String> teamSelectListCache = RxList<String>();
    RxString selectedStatusCache = "".obs;

    teamSelectListCache.addAll(controller.selectList);
    selectedStatusCache.value = controller.selectedStatus.value;

    controller.isTruckLoading.value = true;
    await controller.GetCarList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Bộ lọc',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Trạng thái',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: selectedStatusCache.value.isEmpty
                                ? null
                                : selectedStatusCache.value,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: ['Đang hoạt động', 'Không hoạt động']
                                .map((status) => DropdownMenuItem(
                                      value: status,
                                      child: Text(status),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              selectedStatusCache.value = value ?? "";
                            },
                            hint: const Text('Chọn trạng thái...'),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              controller.selectList.clear();
                              controller.selectedStatus.value = "";
                              controller.refreshData();
                              Navigator.pop(context);
                            },
                            child: const Text("Xóa bộ lọc"),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              controller.selectList = teamSelectListCache;

                              controller.selectedStatus.value =
                                  selectedStatusCache.value == 'Đang hoạt động'
                                      ? '1'
                                      : selectedStatusCache.value ==
                                              'Không hoạt động'
                                          ? '0'
                                          : '';
                              controller.refreshData();
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Áp dụng (${teamSelectListCache.length + (selectedStatusCache.value.isNotEmpty ? 1 : 0)})",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
