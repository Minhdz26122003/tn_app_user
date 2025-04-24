import 'package:app_hm/Controller/Appointment/AppointmentController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Model/Appointment/ApointmentModel.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';

class Appoointmentdetail extends StatelessWidget {
  const Appoointmentdetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Appointmentcontroller controller = Get.put(Appointmentcontroller());
    final appointmentId = Get.arguments['appointment_id'] as int;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'detail_service'.tr,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: ColorHex.total_color,
        leading: const BackButton(color: Colors.white),
      ),
      backgroundColor: ColorHex.background,
      body: Obx(() {
        final appt = controller.appointmentList.firstWhere(
          (a) => a.appointment_id == appointmentId,
          orElse: () => AppointmentModel(),
        );
        if (appt == null) {
          return Center(child: Text('Appointment not found'));
        }
        final currentStep = appt.currentStatusIndex;
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              _buildCurrentStepCard(currentStep, appt),
              const SizedBox(height: 16),
              _buildTimeLine(currentStep),
              const SizedBox(height: 24),
              _buildButtons(controller),
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

  Widget _buildCurrentStepCard(int step, AppointmentModel m) {
    switch (step) {
      // Status 0: Đang xử lý yêu cầu
      case 0:
        return _processingCard(m);
      // Status 1: Báo giá
      case 1:
        return _quoteCard(m);
      // Status 2: Đặt cọc
      case 2:
        return _depositCard(m);
      // Status 3: Sửa chữa
      case 3:
        return _repairCard(m);
      // Status 4: Thanh toán
      case 4:
        return _lostlostCard(m);
      // Status 5: Thanh toán
      case 5:
        return _paymentCard(m);
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
                style: const TextStyle(
                    fontSize: 14, color: ColorHex.grey_shade600)),
            const SizedBox(height: 4),
            Text('${'time'.tr}: $timeStr',
                style: const TextStyle(
                    fontSize: 14, color: ColorHex.grey_shade600)),
            const SizedBox(height: 4),
            Text('${'address'.tr}: ${m.gara_address}',
                style: const TextStyle(
                    fontSize: 14, color: ColorHex.grey_shade600)),
            const SizedBox(height: 4),
            Text('${'code'.tr}: ${m.appointment_id}',
                style: const TextStyle(
                    fontSize: 14, color: ColorHex.grey_shade600)),
          ],
        ),
      ),
    );
  }

  // báo giá
  Widget _quoteCard(AppointmentModel m) {
    final price = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
        .format(m.quoteAmount ?? 600000);
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
                'Báo giá: $price',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Thời gian: ${m.appointment_time}',
                style: const TextStyle(
                    fontSize: 14, color: ColorHex.grey_shade600),
              ),
              const SizedBox(height: 4),
              const Text(
                'Xác nhận trong vòng 4 tiếng',
                style: TextStyle(fontSize: 12, color: ColorHex.grey_shade600),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  // TODO: Xem chi tiết báo giá
                },
                child: const Text(
                  'Chi tiết báo giá',
                  style: TextStyle(color: ColorHex.total_color),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Gọi API từ chối báo giá
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: ColorHex.grey_shade600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'cancel'.tr,
                        style: const TextStyle(color: ColorHex.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Gọi API đồng ý báo giá
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorHex.total_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'next'.tr,
                        style: const TextStyle(color: ColorHex.white),
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
  }

  // đặt cọc
  Widget _depositCard(AppointmentModel m) {
    final deposit = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
        .format(m.depositAmount ?? 200000);
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
                'Đặt cọc: $deposit',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorHex.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Hướng dẫn đặt cọc: Vui lòng chuyển khoản trước khi đến.',
                style: TextStyle(fontSize: 12, color: ColorHex.grey_shade600),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Gọi API đặt cọc
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorHex.total_color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'deposit'.tr,
                    style: const TextStyle(color: ColorHex.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // sửa chữa
  Widget _repairCard(AppointmentModel m) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                'Thời gian: ${m.appointment_time}',
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

// thanh toan
  Widget _paymentCard(AppointmentModel m) {
    final total = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
        .format(m.totalAmount ?? 600000); // Giả sử totalAmount là int
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: ColorHex.grey_shade300,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thanh toán: $total',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorHex.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vui lòng thanh toán số tiền còn lại.',
                style: TextStyle(fontSize: 12, color: ColorHex.grey_shade600),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Gọi API thanh toán
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorHex.total_color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'pay'.tr,
                    style: const TextStyle(color: ColorHex.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lostlostCard(AppointmentModel m) {
    final total = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
        .format(m.totalAmount ?? 600000); // Giả sử totalAmount là int
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: ColorHex.grey_shade300,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'final_settlement: $total',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorHex.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vui lòng thanh toán số tiền còn lại.',
                style: TextStyle(fontSize: 12, color: ColorHex.grey_shade600),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Gọi API thanh toán
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorHex.total_color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'pay'.tr,
                    style: const TextStyle(color: ColorHex.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(Appointmentcontroller controller) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // TODO: gọi API hủy yêu cầu
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorHex.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              minimumSize: const Size(double.infinity, 45),
            ),
            child: Text(
              'cancel_request'.tr,
              style: const TextStyle(fontSize: 14, color: ColorHex.white),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.appointmentbook);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorHex.total_color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              minimumSize: const Size(double.infinity, 45),
            ),
            child: Text(
              'reschedule_appt'.tr,
              style: const TextStyle(fontSize: 14, color: ColorHex.white),
            ),
          ),
        ),
      ],
    );
  }
}
