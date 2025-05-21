import 'package:app_hm/Component/DialogCustom.dart';
import 'package:app_hm/Controller/Car/CarController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Car extends StatelessWidget {
  const Car({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Carcontroller());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorHex.total_color,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined),
          color: ColorHex.white,
          onPressed: () => Get.back(),
        ),
        title: Text(
          'mycar'.tr,
          style: const TextStyle(fontSize: 16, color: ColorHex.white),
        ),
      ),
      body: Obx(
        () => (controller.isLoading.value)
            ? const Center(child: CircularProgressIndicator())
            : controller.carList == null
                ? Center(
                    child: Text('nocar'.tr),
                  )
                : Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            color: const Color.fromARGB(255, 247, 247, 247),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 20.0),
                              child: TextField(
                                controller: controller.textSearch,
                                onChanged: (value) =>
                                    controller.onSearchChanged(),
                                decoration: InputDecoration(
                                  hintText: 'search_keyword'.tr,
                                  hintStyle: const TextStyle(fontSize: 14),
                                  filled: true,
                                  fillColor: ColorHex.white,
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
                            color: const Color.fromARGB(255, 247, 247, 247),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'car_list'.tr,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  "${controller.carList.length}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: ColorHex.total_color,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Obx(
                            () => (controller.carList.isEmpty)
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Center(child: Text('no_car')),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      controller: controller.scrollController,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 10),
                                      itemCount: controller.carList.length,
                                      itemBuilder: (context, index) {
                                        return _buildVehicleCard(
                                            index, controller, context);
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
                          onTap: () => Get.toNamed(Routes.addcar),
                          child: const CircleAvatar(
                            radius: 30.0,
                            backgroundColor: ColorHex.total_color,
                            child: Icon(Icons.add, color: ColorHex.white),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildVehicleCard(
      int index, Carcontroller controller, BuildContext context) {
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
            Text('${'name_car'.tr}: ${car.name}',
                style: const TextStyle(fontSize: 12)),
            Text('${'manufacturer'.tr}: ${car.manufacturer}',
                style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Trong nút Edit
            IconButton(
              icon: const Icon(Icons.edit, color: ColorHex.status_1),
              onPressed: () {
                final car = controller.carList[index];
                Get.toNamed(Routes.editcar, arguments: car);
              },
            ),

            IconButton(
              icon: const Icon(Icons.delete, color: ColorHex.status_0),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => DialogCustom(
                    title: 'confirm'.tr,
                    description: 'delete_car'.tr,
                    svg: 'assets/icons/info.svg',
                    svgColor: ColorHex.status_0,
                    btnColor: ColorHex.status_0,
                    onTap: () async {
                      Navigator.pop(context); // đóng dialog
                      await controller
                          .deleteCar(controller.carList[index].car_id!);
                    },
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
    await controller.getCarList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              color: ColorHex.white,
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
                        color: ColorHex.white,
                        boxShadow: [
                          BoxShadow(
                            color: ColorHex.grey.withOpacity(0.5),
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
