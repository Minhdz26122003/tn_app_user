import 'package:app_hm/Controller/Home/HomeController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 245, 250),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      color: Colors.white,
                      width: Get.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (controller.isShowOverview.value) ...[
                            LayoutBuilder(
                              builder: (context, constraints) {
                                int crossAxisCount = 2;
                                if (constraints.maxWidth < 320) {
                                  crossAxisCount = 1;
                                }
                                return StaggeredGrid.count(
                                  crossAxisCount: crossAxisCount,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Get.to(() => const Truck());
                                      },
                                      child: StaggeredGridTile.fit(
                                          crossAxisCellCount: 1,
                                          child: _itemOverview(
                                            title: 'Quản lý xe',
                                            url:
                                                'assets/images/appointment_empty.png',
                                          )),
                                    ),
                                    StaggeredGridTile.fit(
                                        crossAxisCellCount: 1,
                                        child: _itemOverview(
                                          title: 'Quản lý RIFD',
                                          url:
                                              'assets/images/appointment_empty.png',
                                        )),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            )
                          ],
                          GestureDetector(
                            onTap: () {
                              controller.isShowOverview.value =
                                  !controller.isShowOverview.value;
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  controller.isShowOverview.value
                                      ? 'collapse'.tr
                                      : 'expand'.tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: controller.isShowOverview.value
                                          ? const Color.fromRGBO(
                                              119, 126, 144, 1)
                                          : const Color.fromRGBO(
                                              45, 116, 255, 1)),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Icon(
                                    controller.isShowOverview.value
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_right_rounded,
                                    size: 16,
                                    color: controller.isShowOverview.value
                                        ? const Color.fromRGBO(119, 126, 144, 1)
                                        : const Color.fromRGBO(45, 116, 255, 1))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Text('are_transmitter'.tr)),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Text('confirm_processing_successful'.tr)),
                  ],
                ),
              ),
      ),
    );
  }

  _itemOverview({
    required String title,
    required String url,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: const Color.fromARGB(255, 236, 234, 234), width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(url, fit: BoxFit.fitHeight),
          const SizedBox(
            height: 8,
          ),
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color.fromRGBO(0, 0, 0, 1)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// class StackedBarChart extends StatelessWidget {
//   final controller = Get.find<HomeController>();

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (controller.productweightList.isEmpty) {
//         return const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.error_outline, size: 50, color: Colors.grey),
//               SizedBox(height: 10),
//               Text(
//                 "Không có dữ liệu để hiển thị",
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ],
//           ),
//         );
//       }
//       // Hiển thị biểu đồ nếu có dữ liệu
//       return Column(
//         children: [
//           SfCartesianChart(
//             backgroundColor: Colors.white,
//             title: const ChartTitle(text: 'Doanh số theo sản phẩm'),
//             legend:
//                 const Legend(isVisible: true, position: LegendPosition.bottom),
//             primaryXAxis: const CategoryAxis(),
//             primaryYAxis: const NumericAxis(
//               edgeLabelPlacement: EdgeLabelPlacement.shift,
//               title: AxisTitle(text: 'Doanh số (Triệu)'),
//             ),
//             tooltipBehavior: TooltipBehavior(enable: true),
//             series: <CartesianSeries>[
//               StackedBarSeries<ProductWeight, String>(
//                 dataSource: controller.productweightList,
//                 xValueMapper: (ProductWeight data, _) =>
//                     data.productTypeUu?.name ?? 'Unknown',
//                 yValueMapper: (ProductWeight data, _) => data.amountMT,
//                 name: 'Doanh số BDMT',
//               ),
//               StackedBarSeries<ProductWeight, String>(
//                 dataSource: controller.productweightList,
//                 xValueMapper: (ProductWeight data, _) =>
//                     data.productTypeUu?.name ?? 'Unknown',
//                 yValueMapper: (ProductWeight data, _) => data.amountTotalBDMT,
//                 name: 'Doanh số KHMT',
//               ),
//             ],
//           ),
//         ],
//       );
//     });
//   }
// }

// class RadialChartBar extends StatelessWidget {
//   final controller = Get.find<HomeController>();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Text(
//           'Tổng khối lượng',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         Obx(
//           () => Text(
//             "${controller.totalWeight} tấn", // Dữ liệu động
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//         SfCircularChart(
//           legend: const Legend(
//             isVisible: true,
//             overflowMode: LegendItemOverflowMode.wrap,
//             position: LegendPosition.bottom,
//             textStyle: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           series: <CircularSeries>[
//             // Vòng ngoài cùng
//             DoughnutSeries<ProductWeight, String>(
//               dataSource: controller.productweightList,
//               xValueMapper: (ProductWeight data, _) =>
//                   data.productTypeUu?.name ?? 'Unknown',
//               yValueMapper: (ProductWeight data, _) => data.amountTotalBDMT,
//               pointColorMapper: (ProductWeight data, _) =>
//                   controller.parseColor(data.productTypeUu?.colorShow),
//               radius: '100%',
//               innerRadius: '82%',
//               dataLabelSettings: const DataLabelSettings(
//                 isVisible: true,
//                 textStyle: TextStyle(fontSize: 10),
//               ),
//               explode: true, // Kích hoạt tính năng tách các phần
//               explodeOffset: '5%', // Độ tách biệt giữa các phần
//             ),
//             // Vòng giữa
//             DoughnutSeries<QualityWeight, String>(
//               dataSource: controller.qualityweightList,
//               xValueMapper: (QualityWeight data, _) =>
//                   data.qualityUu?.name ?? 'Unknown',
//               yValueMapper: (QualityWeight data, _) => data.amountTotalBDMT,
//               pointColorMapper: (QualityWeight data, _) =>
//                   controller.parseColor(data.qualityUu?.colorShow),
//               radius: '80%',
//               innerRadius: '63%',
//               dataLabelSettings: const DataLabelSettings(
//                 isVisible: true,
//                 textStyle: TextStyle(fontSize: 10),
//               ),
//               explode: true, // Kích hoạt tính năng tách các phần
//               explodeOffset: '5%', // Độ tách biệt giữa các phần
//             ),
//             // Vòng trong cùng
//             DoughnutSeries<SpecWeight, String>(
//               dataSource: controller.specweightList,
//               xValueMapper: (SpecWeight data, _) =>
//                   data.specUu?.name ?? 'Unknown',
//               yValueMapper: (SpecWeight data, _) => data.amountTotalBDMT,
//               pointColorMapper: (SpecWeight data, _) =>
//                   controller.parseColor(data.specUu?.colorShow),
//               radius: '50%',
//               innerRadius: '43%',
//               dataLabelSettings: const DataLabelSettings(
//                 isVisible: true,
//                 textStyle: TextStyle(fontSize: 10),
//               ),
//               explode: true, // Kích hoạt tính năng tách các phần
//               explodeOffset: '5%', // Độ tách biệt giữa các phần
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
