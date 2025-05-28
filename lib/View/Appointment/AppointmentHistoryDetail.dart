import 'package:app_hm/Controller/Appointment/Appointmentcontroller.dart';
import 'package:app_hm/Controller/Payment/PaymentController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Model/Appointment/ApointmentModel.dart';
import 'package:app_hm/Model/Payment/PaymentModel.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Appointmenthistorydetail extends StatelessWidget {
  const Appointmenthistorydetail();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Appointmentcontroller>();

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
        final appt = controller.historyAppointments.firstWhereOrNull(
          (a) => a.appointment_id == appointmentId,
        );
        if (appt == null) {
          return const Center(
              child: Text('Lịch hẹn không tồn tại hoặc đã bị hủy'));
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
      // Status 7:Đã thanh toán
      case 7:
        return _paymentedCard(m, context);
      case 8:
        return _canceledCard(m);
      default:
        return const SizedBox.shrink();
    }
  }

  // Đã thanh toán
  Widget _paymentedCard(AppointmentModel m, BuildContext context) {
    final controller = Get.put(PaymentController());

    if (m.appointment_id != null && controller.payment.value == null) {
      controller.fetchPayment(m.appointment_id!);
    }

    return Obx(() {
      if (controller.isLoadingPayment.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final pay = controller.payment.value;
      if (pay == null) return const SizedBox();

      final formattedPrice = NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
          .format(pay.total_price ?? 0);
      final formText = pay.form == 1 ? 'Online' : 'Trực tiếp';
      final statusColor = Colors.green;

      return Card(
        margin: const EdgeInsets.all(12),
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.verified,
                    color: Colors.green,
                    size: 28,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Đã thanh toán',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Người dùng: ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(m.fullname ?? ''),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Số điện thoại: ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(m.phonenum ?? ''),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Email: ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Text(
                      m.email ?? '',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Hình thức: ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(formText),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Ngày thanh toán: ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(pay.payment_date ?? 'Không rõ'),
                ],
              ),
              if (pay.form == 1 && pay.status == 1) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      'Mã giao dịch: ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Flexible(child: Text(('${pay.payment_id ?? 0}'))),
                  ],
                ),
              ],
              const Divider(thickness: 1, height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tổng cộng:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    formattedPrice,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        openSettlementDetails(m.appointment_id ?? 0, context);
                      },
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: ColorHex.grey),
                        backgroundColor: ColorHex.status_update_vote_3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon: const Icon(
                        Icons.visibility_outlined,
                        color: ColorHex.white,
                      ),
                      label: const Text('Chi tiết',
                          style:
                              TextStyle(color: ColorHex.white, fontSize: 13)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  // Đã hủy
  Widget _canceledCard(AppointmentModel m) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      color: Colors.red.shade50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề dịch vụ
            // Dịch vụ
            const SizedBox(height: 6),
            if (m.services != null && m.services!.isNotEmpty) ...[
              Text('Dịch vụ đã đặt:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ...m.services!.map((svc) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(child: Text(svc.service_name ?? '')),
                        Text(
                            '${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(svc.price)}'),
                      ],
                    ),
                  )),
            ],
            const SizedBox(height: 8),

            // Ngày giờ hẹn
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  '${m.appointment_date ?? ''} - ${m.appointment_time ?? ''}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Trung tâm bảo dưỡng
            Row(
              children: [
                const Icon(Icons.location_on, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    m.gara_name ?? 'Không rõ trung tâm',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.account_box_rounded,
                    size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  m.fullname ?? 'Không có tên',
                  style: const TextStyle(fontSize: 14),
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  m.phonenum ?? 'Không có số điện thoại',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Biển số xe
            Row(
              children: [
                const Icon(Icons.directions_car, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Biển số ',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  m.license_plate ?? 'Không có biển số',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Trạng thái đã hủy
            Row(
              children: const [
                Icon(Icons.cancel, color: Colors.red),
                SizedBox(width: 6),
                Text(
                  'Lịch hẹn đã hủy',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            // Nếu có lý do hủy
            if ((m.reason ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Lý do: ${m.reason}',
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void openSettlementDetails(int appointmentId, BuildContext context) {
    final controller = Get.find<Appointmentcontroller>();
    controller.getSettlementUser(appointmentId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (_, scrollCtrl) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              if (controller.isLoadingSettlement.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final totalAmt = controller.totalAmount.value ?? 0;

              return ListView(
                controller: scrollCtrl,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const Text(
                    'Hoá đơn thanh toán',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),

                  // Chi tiết dịch vụ
                  const Text('Chi tiết dịch vụ',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ...controller.serviceList.map((svc) {
                    final price = (svc.price ?? 0);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(svc.service_name ?? '',
                          style: const TextStyle(fontSize: 12)),
                      trailing: Text(
                          NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                              .format(price),
                          style: const TextStyle(color: ColorHex.status_0)),
                    );
                  }),

                  const Divider(),

                  // Chi tiết phụ tùng
                  const Text('Chi tiết phụ tùng',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ...controller.accessList.map((acc) {
                    final subTotal = (acc.sub_total ?? 0);
                    return ListTile(
                      visualDensity: const VisualDensity(vertical: -4),
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                          (acc.accessory_name ?? '') +
                              (' x') +
                              (acc.quantity?.toString() ?? ''),
                          style: const TextStyle(fontSize: 12)),
                      trailing: Text(
                          NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                              .format(subTotal),
                          style: const TextStyle(color: ColorHex.status_0)),
                    );
                  }),

                  const Divider(),

                  // Tổng cộng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tổng cộng:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                            .format(totalAmt),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Nút hành động
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(color: ColorHex.grey),
                            backgroundColor: ColorHex.grey_shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          icon: const Icon(
                            Icons.close,
                            color: ColorHex.black,
                          ),
                          label: const Text(
                            'Đóng',
                            style: TextStyle(color: ColorHex.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
