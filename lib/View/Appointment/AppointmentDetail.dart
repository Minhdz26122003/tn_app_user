import 'package:app_hm/Controller/Appointment/Appointmentcontroller.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Model/Appointment/ApointmentModel.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Appoointmentdetail extends StatelessWidget {
  const Appoointmentdetail({super.key});

  @override
  Widget build(BuildContext context) {
    final Appointmentcontroller controller = Get.put(Appointmentcontroller());
    final dynamic receivedAppointmentId = Get.arguments['appointment_id'];
    final int? appointmentId =
        receivedAppointmentId is int ? receivedAppointmentId : null;

    if (appointmentId == null) {
      return const Center(child: Text('Lỗi: Không tìm thấy ID cuộc hẹn'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'detail_service'.tr,
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
        backgroundColor: ColorHex.total_color,
        leading: const BackButton(color: Colors.white),
      ),
      backgroundColor: ColorHex.background,
      body: Obx(() {
        final appt = controller.appointmentList.firstWhereOrNull(
          (a) => a.appointment_id == appointmentId,
        );
        if (appt == null) {
          return Center(child: Text('Lịch hẹn không tồn tại hoặc đã bị hủy'));
        }
        final currentStep = appt.currentStatusIndex;
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              _buildCurrentStepCard(
                  currentStep, appt, controller, context, appointmentId),
              const SizedBox(height: 16),
              _buildTimeLine(currentStep),
              const SizedBox(height: 24),
              if (currentStep <= 1)
                _buildButtons(controller, context, appointmentId),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTimeLine(int currentStep) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(Utils.steps.length, (i) {
          return TimelineTile(
            isFirst: i == 0,
            isLast: i == Utils.steps.length - 1,
            indicatorStyle: IndicatorStyle(
              width: 25,
              color: i <= currentStep
                  ? ColorHex.total_color
                  : ColorHex.grey_shade400,
            ),
            beforeLineStyle: LineStyle(
              color: i > 0 && i <= currentStep
                  ? ColorHex.total_color
                  : ColorHex.grey_shade400,
              thickness: 3,
            ),
            afterLineStyle: LineStyle(
              color: i < currentStep
                  ? ColorHex.total_color
                  : ColorHex.grey_shade400,
              thickness: 3,
            ),
            endChild: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Text(
                Utils.steps[i].tr,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      i == currentStep ? FontWeight.bold : FontWeight.normal,
                  color: i < currentStep ? Colors.black : ColorHex.border_3,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStepCard(
      int step,
      AppointmentModel m,
      Appointmentcontroller controller,
      BuildContext context,
      int appointmentId) {
    switch (step) {
      // Status 0: Đang xử lý yêu cầu
      case 0:
        return _processingCard(m);
      // Status 1: Báo giá
      case 1:
        return _quoteCard(m, controller, context, appointmentId);
      // Status 2: Sửa chữa
      case 2:
        return _repairCard(m, controller);
      // Status 3: Quyết toán
      case 3:
        return _settlementCard(m); // Thêm widget cho trạng thái Quyết toán
      // Status 4: Thanh toán
      case 4:
        return _paymentCard(m); // Thêm widget cho trạng thái Thanh toán
      default:
        return const SizedBox.shrink();
    }
  }

// Đang xử lý yêu cầu
  Widget _processingCard(AppointmentModel m) {
    final dt = DateTime.tryParse(m.appointment_date!) ?? DateTime.now();
    final dateStr = DateFormat("EEE, dd 'thg' MM yyyy", "vi").format(dt);
    final timeStr = m.appointment_time ?? '--:--';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: ColorHex.grey_shade300,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(m.gara_name ?? '',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorHex.black)),
            const SizedBox(height: 8),
            Text('${'date'.tr}: $dateStr',
                style:
                    const TextStyle(fontSize: 14, color: ColorHex.textContent)),
            const SizedBox(height: 4),
            Text('${'time'.tr}: $timeStr',
                style:
                    const TextStyle(fontSize: 14, color: ColorHex.textContent)),
            const SizedBox(height: 4),
            Text('${'address'.tr}: ${m.gara_address}',
                style:
                    const TextStyle(fontSize: 14, color: ColorHex.textContent)),
            const SizedBox(height: 4),
            Text('${'code'.tr}: #${m.appointment_id}',
                style:
                    const TextStyle(fontSize: 14, color: ColorHex.textContent)),
          ],
        ),
      ),
    );
  }

  int _parseDurationToMinutes(String duration) {
    final parts = duration.split(':'); // ["HH", "MM", "SS"]
    if (parts.length != 3) return 0;
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    final seconds = int.tryParse(parts[2]) ?? 0;
    // Chuyển thành phút (làm tròn xuống)
    return hours * 60 + minutes + (seconds >= 30 ? 1 : 0);
  }

  // báo giá
  Widget _quoteCard(AppointmentModel m, Appointmentcontroller controller,
      BuildContext context, int appointmentId) {
    double totalPrice = 0;
    if (m.services != null) {
      for (var service in m.services!) {
        totalPrice += service.price ?? 0;
        //totalTime += _parseDurationToMinutes(service.time ?? '0:00:00');
      }
    }

    final formattedPrice =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(totalPrice);
    //final formattedTotalTime = '$totalTime phút'; // Định dạng tổng thời gian

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: ColorHex.grey_shade300,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'service'.tr + ':',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const Divider(),
              // Danh sách từng service
              ...m.services?.map((s) {
                    final price = NumberFormat.currency(
                            locale: 'vi_VN', symbol: '₫')
                        .format(
                            double.tryParse(s.price?.toString() ?? '0') ?? 0);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                s.service_name ?? '',
                                style: const TextStyle(fontSize: 13),
                              )),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(price,
                                  style: const TextStyle(color: Colors.red)),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList() ??
                  [],
              const Divider(),

              // Tổng tiền
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Row(
                  children: [
                    const Text(
                      'Tổng:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formattedPrice, // Sử dụng formattedPrice
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red),
                    ),
                  ],
                ),
              ),

              // Nút Hủy/Đồng ý
              Row(
                children: [
                  // Expanded(
                  //   child: OutlinedButton(
                  //     onPressed: () {
                  //       _showCancelDialog(controller, context, appointmentId);
                  //     },
                  //     style: OutlinedButton.styleFrom(
                  //       side: const BorderSide(color: ColorHex.grey),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(15),
                  //       ),
                  //     ),
                  //     child: Text('cancel'.tr,
                  //         style: const TextStyle(color: ColorHex.black)),
                  //   ),
                  // ),
                  // const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.AcceptAppoint(appointmentId);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: ColorHex.grey),
                        backgroundColor: ColorHex.total_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text('accept'.tr,
                          style: const TextStyle(color: ColorHex.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // sửa chữa
  Widget _repairCard(AppointmentModel m, Appointmentcontroller controller) {
    double totalPrice = 0;
    int totalTime = 0; // Giả sử thời gian là số phút

    if (m.services != null) {
      for (var service in m.services!) {
        totalPrice += service.price ?? 0;
        totalTime += _parseDurationToMinutes(service.time ?? '0:00:00');
      }
    }

    final formattedPrice =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(totalPrice);
    final formattedTotalTime = '$totalTime phút'; // Định dạng tổng thời gian
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: ColorHex.grey_shade300,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Đang sửa chữa',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorHex.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Thời gian: $formattedTotalTime',
                style: const TextStyle(
                    fontSize: 14, color: ColorHex.grey_shade600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Xe của bạn đang được sửa chữa tại gara.',
                style: TextStyle(fontSize: 14, color: ColorHex.grey_shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Quyết toán
  Widget _settlementCard(AppointmentModel m) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: ColorHex.grey_shade300,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quyết toán',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorHex.black,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  // TODO: Implement view settlement details
                },
                child: const Text(
                  'Xem quyết toán',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue, // Or your link color
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Thanh toán
  Widget _paymentCard(AppointmentModel m) {
    double totalPrice = 0;
    if (m.services != null) {
      for (var service in m.services!) {
        totalPrice += service.price ?? 0;
      }
    }
    final formattedPrice =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(totalPrice);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: ColorHex.grey_shade300,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hoàn tất thanh toán: $formattedPrice',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorHex.black,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  // TODO: Implement view electronic invoice
                },
                child: const Text(
                  'Xem Hoá đơn điện tử',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue, // Or your link color
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(Appointmentcontroller controller, BuildContext context,
      int appointmentId) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              _showCancelDialog(controller, context, appointmentId);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: ColorHex.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text('cancel'.tr,
                style: const TextStyle(color: ColorHex.black)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              controller.AcceptAppoint(appointmentId);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              side: const BorderSide(color: ColorHex.grey),
              backgroundColor: ColorHex.total_color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text('accept'.tr,
                style: const TextStyle(color: ColorHex.white)),
          ),
        ),
      ],
    );
  }

  void _showCancelDialog(Appointmentcontroller controller, BuildContext context,
      int appointmentId) {
    showDialog(
      context: context,
      builder: (_) => SafeArea(
        child: AlertDialog(
          title: Text('Xác nhận hủy'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Text('Bạn có chắc chắn muốn hủy lịch hẹn này?'.tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Không'.tr),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (_) => SafeArea(
                    child: AlertDialog(
                      title: Text('Lý do hủy hẹn'.tr,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      content: TextField(
                        controller: controller.cancelreason,
                        maxLines: 3,
                        decoration: const InputDecoration(
                            hintText: 'Nhập lý do (tùy chọn)',
                            border: OutlineInputBorder()),
                        onChanged: (value) {
                          controller.cancelreason.text = value;
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Đóng'.tr),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (appointmentId != null) {
                              print(
                                  "nhap ly do: ${controller.cancelreason.text}");
                              controller.CancelAppoint(
                                  appointmentId, controller.cancelreason.text);

                              Get.back();
                            } else {
                              Utils.showSnackBar(
                                  title: 'Lỗi'.tr,
                                  message: 'Không tìm thấy ID lịch hẹn.');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorHex.total_color,
                          ),
                          child: Text('Xác nhận hủy'.tr,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: Text('Có, hủy'.tr, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
