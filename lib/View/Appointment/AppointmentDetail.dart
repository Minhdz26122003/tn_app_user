import 'package:app_hm/Controller/Appointment/Appointmentcontroller.dart';
import 'package:app_hm/Controller/Payment/PaymentController.dart';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Model/Appointment/ApointmentModel.dart';
import 'package:app_hm/Model/Deposits/DepositModel.dart';
import 'package:app_hm/Model/Payment/PaymentModel.dart';
import 'package:app_hm/Router/AppPage.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Appoointmentdetail extends StatelessWidget {
  const Appoointmentdetail();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Appointmentcontroller>();

    // final Appointmentcontroller controller = Get.put(Appointmentcontroller());
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
        final appt = controller.pendingAppointments.firstWhereOrNull(
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
              const SizedBox(height: 24),
              if (currentStep == 0)
                _buildButtons(currentStep, controller, context, appointmentId),
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
    final PaymentController paymentController = Get.put(PaymentController());
    switch (step) {
      // Status 0: Đang xử lý yêu cầu
      case 0:
        return _processingCard(m);
      // Status 1: Báo giá
      case 1:
        if (paymentController.deposit.value?.appointment_id != appointmentId ||
            (paymentController.deposit.value == null &&
                !paymentController.isLoading.value)) {
          // Sử dụng addPostFrameCallback để tránh lỗi setState/markNeedsBuild trong quá trình build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Kiểm tra xem widget còn mounted không trước khi gọi setState hoặc các hàm của controller
            if (context.mounted) {
              paymentController.fetchDeposit(appointmentId);
            }
          });
        }
        return _quoteCard(
            m, controller, context, appointmentId, paymentController);
      // Status 2: Chấp nhận báo giá
      case 2:
        return _confirmQuoteCard(m, controller);
      // Status 3: Đang sửa
      case 3:
        return _repairCard(m);
      // Status 4: Hoàn thành
      case 4:
        return _completeCard(m);
      // Status 5: Quyết toán
      case 5:
        return _settlementCard(m, controller, context);
      // Status 6: Thanh toán
      case 6:
        return _paymentCard(m);
      // Status 7:Đã thanh toán
      case 7:
        return _paymentedCard(m);
      default:
        return const SizedBox.shrink();
    }
  }

  // Hàm tiện ích để hiển thị thông tin đặt cọc
  Widget _buildDepositInfoRow(String label, String value,
      {Color? color, FontWeight? fontWeight}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  color: ColorHex.black)), // Sử dụng màu từ ColorHex của bạn
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: fontWeight ?? FontWeight.w500,
                  color: color ??
                      ColorHex.black), // Sử dụng màu từ ColorHex của bạn
            ),
          ),
        ],
      ),
    );
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
            Text('${'Mã lịch hẹn'}: #${m.appointment_id}',
                style: const TextStyle(fontSize: 14, color: ColorHex.black)),
            const SizedBox(height: 4),
            Text('${'date'.tr}: $dateStr',
                style: const TextStyle(fontSize: 14, color: ColorHex.black)),
            const SizedBox(height: 4),
            Text('${'time'.tr}: $timeStr',
                style: const TextStyle(fontSize: 14, color: ColorHex.black)),
            const SizedBox(height: 4),
            Text('${'address'.tr}: ${m.gara_address}',
                style: const TextStyle(fontSize: 14, color: ColorHex.black)),
            const SizedBox(height: 4),
            Text('${'Hotline gara'.tr}: ${m.phone}',
                style: const TextStyle(fontSize: 14, color: ColorHex.black)),
            const SizedBox(height: 8),
            Text('Thông tin cá nhân:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text('${'fullname'.tr}: ${m.fullname}',
                style: const TextStyle(fontSize: 14, color: ColorHex.black)),
            Text('${'Số điện thoại'.tr}: ${m.phone}',
                style: const TextStyle(fontSize: 14, color: ColorHex.black)),
            Text('${'Xe'.tr}: ${m.name}',
                style: const TextStyle(fontSize: 14, color: ColorHex.black)),
            Text('${'license_plate'.tr}: ${m.license_plate}',
                style: const TextStyle(fontSize: 14, color: ColorHex.black)),
            const SizedBox(height: 8),
            if (m.services != null && m.services!.isNotEmpty) ...[
              Text('Dịch vụ đã đặt:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
              const SizedBox(height: 12),
            ],
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
  Widget _quoteCard(
    AppointmentModel m,
    Appointmentcontroller
        appointmentController, // Đổi tên để phân biệt với paymentController
    BuildContext context,
    int appointmentId,
    PaymentController paymentController, // Tham số PaymentController
  ) {
    // Định dạng tiền tệ
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return Obx(() {
      // Lấy thông tin đặt cọc từ paymentController
      final DepositModel? deposit = paymentController.deposit.value;
      final bool isLoadingDeposit = paymentController.isLoading.value;

      // Điều kiện để hiển thị nút thanh toán đặt cọc
      bool canPayDeposit = deposit != null &&
          deposit.status == 0 && // 0: Chưa thanh toá
          deposit.amount != null &&
          deposit.amount! > 0;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: ColorHex.grey_shade300, // Sử dụng màu từ ColorHex của bạn
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${'service'.tr}:',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Divider(),
                // Danh sách từng service
                if (m.services == null || m.services!.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("Không có dịch vụ nào được chọn.",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700])),
                  )
                else
                  ...m.services!.map((s) {
                    final price = currencyFormatter.format(
                        double.tryParse(s.price?.toString() ?? '0') ?? 0);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              s.service_name ?? 'N/A',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(price,
                              style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    );
                  }).toList(),
                const Divider(),

                // Hiển thị thông tin đặt cọc
                if (isLoadingDeposit)
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: CircularProgressIndicator(),
                  ))
                else if (deposit != null &&
                    deposit.amount != null &&
                    deposit.amount! > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'Thông tin đặt cọc:',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorHex.black), // Màu tùy chỉnh
                      ),
                      const SizedBox(height: 10),
                      _buildDepositInfoRow('Số tiền cần cọc:',
                          currencyFormatter.format(deposit.amount ?? 0),
                          color: (deposit.status == 1
                              ? Colors.green
                              : ColorHex.total_color), // Màu cho số tiền
                          fontWeight: FontWeight.bold),
                      if (deposit.created_at != null)
                        _buildDepositInfoRow(
                            'Ngày tạo yêu cầu cọc:',
                            DateFormat('dd/MM/yyyy HH:mm')
                                .format(DateTime.parse(deposit.created_at!))),
                      _buildDepositInfoRow(
                          'Trạng thái cọc:',
                          deposit.status == 0
                              ? 'Chưa thanh toán'
                              : (deposit.status == 1
                                  ? 'Đã thanh toán'
                                  : 'Thất bại'),
                          color: deposit.status == 0
                              ? Colors.orange[700]
                              : (deposit.status == 1
                                  ? Colors.green
                                  : Colors.red),
                          fontWeight: FontWeight.bold),
                      if (deposit.status == 1 && deposit.deposit_date != null)
                        _buildDepositInfoRow(
                            'Ngày thanh toán cọc:',
                            DateFormat('dd/MM/yyyy HH:mm')
                                .format(DateTime.parse(deposit.deposit_date!))),
                      const SizedBox(height: 16),
                    ],
                  )
                else if (deposit != null &&
                    (deposit.amount == null || deposit.amount == 0))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Text(
                        'Lịch hẹn này không yêu cầu đặt cọc.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700],
                            fontSize: 14),
                      ),
                    ),
                  )
                else // deposit == null (chưa có thông tin từ API)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Text(
                        'Không tải được thông tin đặt cọc. Vui lòng thử lại.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.red[700],
                            fontSize: 14),
                      ),
                    ),
                  ),

                // Nút Thanh toán chỉ hiển thị nếu cần và deposit.status == 0)
                if (canPayDeposit)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          paymentController.depositPayment(
                            deposit.deposit_id!,
                            appointmentId,
                            deposit.amount!,
                          );
                        },
                        icon: const Icon(Icons.payment, color: Colors.white),
                        label: Text(
                          'Thanh toán đặt cọc ${currencyFormatter.format(deposit.amount ?? 0)}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorHex.total_color, // Màu nút
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),

                // Nút Hủy lịch hẹn và Đồng ý báo giá

                if (deposit == null ||
                    deposit.status !=
                        1) // Nếu chưa có cọc hoặc cọc chưa thanh toán
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _showCancelDialog(
                                appointmentController, context, appointmentId);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: ColorHex.grey_shade600), // Màu viền
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('cancel'.tr,
                              style: const TextStyle(
                                  color: ColorHex.black, fontSize: 14)),
                        ),
                      ),
                    ],
                  )
                else if (deposit != null &&
                    deposit.status == 1) // Nếu đã đặt cọc thành công
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Text(
                        "Bạn đã đặt cọc thành công.\nGara sẽ sớm xử lý lịch hẹn của bạn.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

// chấp nhận báo giá
  Widget _confirmQuoteCard(
      AppointmentModel m, Appointmentcontroller controller) {
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
              const Icon(
                Icons.check_circle_outline,
                size: 48,
                color: Colors.green,
              ),
              const SizedBox(height: 12),
              Text(
                'Báo giá đã được chấp nhận',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Cảm ơn bạn đã xác nhận. Nhân viên của chúng tôi sẽ sớm tiến hành dịch vụ.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
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
    //double totalPrice = 0;
    int totalTime = 0;
    if (m.services != null) {
      for (var service in m.services!) {
        totalTime += _parseDurationToMinutes(service.time ?? '0:00:00');
      }
    }

    final formattedTime = '$totalTime phút';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề với icon để minh họa
              const Row(
                children: [
                  Icon(Icons.build_circle_outlined,
                      size: 28, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Đang sửa chữa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorHex.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Thời gian và chi phí dự kiến
              Row(
                children: [
                  const Icon(Icons.schedule,
                      size: 20, color: ColorHex.grey_shade600),
                  const SizedBox(width: 4),
                  Text(
                    formattedTime,
                    style: const TextStyle(
                        fontSize: 14, color: ColorHex.grey_shade600),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Mô tả ngắn về trạng thái
              const Text(
                'Xe của bạn đang được sửa chữa tại gara. Nhân viên sẽ cập nhật khi hoàn thành.',
                style: TextStyle(fontSize: 14, color: ColorHex.grey_shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hoàn thành
  Widget _completeCard(AppointmentModel m) {
    int totalTime = 0;
    if (m.services != null) {
      for (var svc in m.services!) {
        totalTime += _parseDurationToMinutes(svc.time ?? '0:00:00');
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Icon & Tiêu đề hoàn thành
              Row(
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 28, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    'Hoàn thành',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const Text(
                'Xe của bạn đã được sửa chữa xong. Cảm ơn bạn đã tin tưởng sử dụng dịch vụ!',
                style: TextStyle(fontSize: 14, color: ColorHex.grey_shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Quyết toán
  Widget _settlementCard(AppointmentModel m, Appointmentcontroller controller,
      BuildContext context) {
    final svTotal = controller.serviceTotal.value;
    final ptTotal = controller.partsTotal.value;
    final grandTotal = controller.totalAmount.value;
    final totalAfter = controller.totalAfter.value;
    final depositAmount = controller.depositAmount.value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề với icon
              const Row(
                children: [
                  Icon(Icons.receipt_long, size: 28, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    'Quyết toán',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: ColorHex.status_3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // (chi phí dịch vụ + phụ tùng)
              // Total dịch vụ
              Row(
                children: [
                  const Text('- Dịch vụ: ',
                      style: TextStyle(
                          fontSize: 13, color: ColorHex.grey_shade600)),
                  const Spacer(),
                  Text(
                    NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                        .format(svTotal),
                    style: const TextStyle(
                        fontSize: 13, color: ColorHex.grey_shade600),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Total phụ tùng
              Row(
                children: [
                  const Text('- Phụ tùng: ',
                      style: TextStyle(
                          fontSize: 13, color: ColorHex.grey_shade600)),
                  const Spacer(),
                  Text(
                    NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                        .format(ptTotal),
                    style: const TextStyle(
                        fontSize: 13, color: ColorHex.grey_shade600),
                  ),
                ],
              ),
              const Divider(height: 20),
              // (chi phí dịch vụ + phụ tùng)

              // Total dịch vụ
              Row(
                children: [
                  const Text('- Tiền cọc: ',
                      style: TextStyle(
                          fontSize: 13, color: ColorHex.grey_shade600)),
                  const Spacer(),
                  Text(
                    NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                        .format(depositAmount),
                    style: const TextStyle(
                        fontSize: 13, color: ColorHex.grey_shade600),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Tổng cộng
              Row(
                children: [
                  const Text('Tổng cộng:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ColorHex.black,
                      )),
                  const Spacer(),
                  Text(
                    NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                        .format(totalAfter),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              //  xem chi tiết, tải hóa đơn
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: controller.isLoadingSettlement.value
                          ? null
                          : () async {
                              controller.acceptBill(m.appointment_id!);
                              Get.back(); // đóng bottom sheet
                            },
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: ColorHex.grey),
                        backgroundColor: ColorHex.total_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon: const Icon(
                        Icons.done,
                        color: ColorHex.white,
                      ),
                      label: Text('confirm'.tr,
                          style: const TextStyle(
                              color: ColorHex.white, fontSize: 13)),
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

  // Thanh toán
  Widget _paymentCard(AppointmentModel m) {
    final controller = Get.put(PaymentController());

    if (m.appointment_id != null && controller.payment.value == null) {
      controller.fetchPayment(m.appointment_id!); // <-- Thay đổi ở đây
    }

    return Obx(() {
      if (controller.isLoadingPayment.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final pay = controller.payment.value;
      final formattedPrice = NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
          .format(pay?.total_price ?? 0);
      final isPendingDirectPayment = pay?.form == 2 && pay?.status == 0;

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
              // Tiêu đề với icon và màu của type1
              const Row(
                children: [
                  Icon(
                    Icons.payment,
                    color: ColorHex.status_0,
                    size: 28,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Thanh toán',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ColorHex.status_0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (isPendingDirectPayment) ...[
                Text(
                  'Bạn đã chọn thanh toán trực tiếp. Vui lòng thanh toán tại gara khi đến nhận xe. Thanh toán của bạn đang chờ xác nhận từ quản trị viên.',
                  style: TextStyle(color: Colors.orange[800]),
                ),
                const SizedBox(height: 16),
              ] else ...[
                // Chọn phương thức
                const Text(
                  'Chọn phương thức thanh toán',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ColorHex.grey_shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Theme(
                  data: Theme.of(Get.context!).copyWith(
                    radioTheme: RadioThemeData(
                      fillColor: MaterialStateProperty.all(ColorHex.applyColor),
                    ),
                  ),
                  child: Obx(() => Column(
                        children: [
                          RadioListTile<int>(
                            title: const Text(
                              'Thanh toán online',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            value: 1,
                            groupValue: controller.selectedMethod.value,
                            onChanged: (v) =>
                                controller.selectedMethod.value = v!,
                            contentPadding: EdgeInsets.zero,
                          ),
                          RadioListTile<int>(
                            title: const Text(
                              'Thanh toán trực tiếp',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            value: 2,
                            groupValue: controller.selectedMethod.value,
                            onChanged: (v) =>
                                controller.selectedMethod.value = v!,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 16),
              ],
              // Hướng dẫn thanh toán trực tiếp
              if (controller.selectedMethod.value == 2) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 16, top: 13),
                  decoration: BoxDecoration(
                    color: ColorHex.status_0.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vui lòng thanh toán trực tiếp tại gara:',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: ColorHex.status_0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'SH1KT02, Vinhomes OCP2, Văn Giang, Hưng Yên, Việt Nam',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextButton.icon(
                        onPressed: () => MapsLauncher.launchCoordinates(
                            20.9518, 105.978, 'WeCar Auto Văn Giang'),
                        icon: const Icon(Icons.map,
                            size: 20, color: ColorHex.status_0),
                        label: const Text(
                          'Chỉ đường',
                          style: TextStyle(
                            color: ColorHex.status_0,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Divider(thickness: 1),

              // Tổng cộng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng cộng:',
                    style: Theme.of(Get.context!)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    formattedPrice,
                    style:
                        Theme.of(Get.context!).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ColorHex.status_0,
                            ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Nút xác nhận
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.selectedMethod.value == 0
                      ? null
                      : () {
                          if (controller.selectedMethod.value == 1) {
                            Get.toNamed(
                              Routes.payment,
                              arguments: {
                                'appointment_id': m.appointment_id,
                                'total_price': pay?.total_price ?? 0,
                              },
                            );
                          } else {
                            controller.paymentOffline(pay?.payment_id ?? 0);
                            Get.back();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorHex.border_5,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    textStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  child: const Text(
                    'Xác nhận thanh toán',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Đã thanh toán
  Widget _paymentedCard(AppointmentModel m) {
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
            ],
          ),
        ),
      );
    });
  }

  // btn hủy lịch
  Widget _buildButtons(int currentStep, Appointmentcontroller controller,
      BuildContext context, int appointmentId) {
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
        // const SizedBox(width: 12),
        // Expanded(
        //   child: ElevatedButton(
        //     onPressed: () {
        //       controller.acceptQuote(appointmentId);
        //       Get.back();
        //     },
        //     style: ElevatedButton.styleFrom(
        //       side: const BorderSide(color: ColorHex.grey),
        //       backgroundColor: ColorHex.total_color,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(15),
        //       ),
        //     ),
        //     child: Text('accept'.tr,
        //         style: const TextStyle(color: ColorHex.white)),
        //   ),
        // ),
      ],
    );
  }

  // Dialog hủy lịch
  void _showCancelDialog(Appointmentcontroller controller, BuildContext context,
      int appointmentId) {
    showDialog(
      context: context,
      builder: (_) => SafeArea(
        child: AlertDialog(
          title: Text('Xác nhận hủy'.tr,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        size: 48,
                        color: Colors.green,
                      ),
                      title: Text('Lý do hủy hẹn'.tr,
                          style: const TextStyle(
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
                            // print(
                            //     "nhap ly do: ${controller.cancelreason.text}");
                            controller.cancelAppoint(
                                appointmentId, controller.cancelreason.text);

                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorHex.total_color,
                          ),
                          child: Text('Xác nhận hủy'.tr,
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: Text('Có, hủy'.tr,
                  style: const TextStyle(color: Colors.white)),
            ),
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

              final totalAmt = controller.totalAfter.value ?? 0;
              final depositAmount = controller.depositAmount.value ?? 0;

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

                  // Tiền cọc
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tiền cọc:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      Text(
                        NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                            .format(depositAmount),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent),
                      ),
                    ],
                  ),
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
