// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:app_hm/Controller/Appointment/Appointmentcontroller.dart';
import 'package:app_hm/Controller/Payment/PaymentController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Model/Appointment/ApointmentModel.dart';
import 'package:app_hm/Utils/Utils.dart';

class Payment extends StatelessWidget {
  const Payment({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy dữ liệu từ arguments
    final Map<String, dynamic> args = Get.arguments;
    final int appointmentId = args['appointment_id'];

    // Khởi tạo hoặc tìm AppointmentController
    final appointmentController = Get.put(Appointmentcontroller());
    final paymentController = Get.put(PaymentController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      appointmentController.getSettlementUser(appointmentId);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Xác nhận Thanh toán',
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
        backgroundColor: ColorHex.total_color,
        leading: const BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thay thế Spacer và SizedBox cho nút thanh toán
            // bằng Expanded chứa ListView và nút thanh toán
            Expanded(
              child: Obx(() {
                if (appointmentController.isLoadingSettlement.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Lấy tổng tiền từ controller của appointment, đây sẽ là totalAmount của Settlement
                final totalAmt = appointmentController.totalAfter.value ?? 0;
                final deposit = appointmentController.depositAmount.value ?? 0;
                final formattedTotalAmt =
                    NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                        .format(totalAmt);
                final depositTotal =
                    NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                        .format(deposit);

                return ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Mã lịch hẹn:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '#${appointmentId}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(),

                    // Chi tiết dịch vụ
                    const Text('Chi tiết dịch vụ',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    ...appointmentController.serviceList.map((svc) {
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
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    ...appointmentController.accessList.map((acc) {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Số tiền đặt cọc:',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        Text('-' + depositTotal,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12)),
                      ],
                    ),
                    const Divider(thickness: 2),
                    const SizedBox(height: 24),
                    // Tổng cộng
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tổng cộng:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                          formattedTotalAmt,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Nút hành động "Tiếp tục thanh toán VNPAY"
                    SizedBox(
                      width: double.infinity,
                      child: Obx(() {
                        return ElevatedButton(
                          onPressed: paymentController.isProcessingOnline.value
                              ? null
                              : () {
                                  // Sử dụng totalAmt từ Settlement để thanh toán
                                  paymentController.createVnPayPayment(
                                    appointment_id: appointmentId,
                                    total_price: totalAmt,
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorHex.border_5,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: paymentController.isProcessingOnline.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'Tiếp tục thanh toán VNPAY',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
