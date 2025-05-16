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
              if (currentStep <= 2)
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
    switch (step) {
      // Status 0: Đang xử lý yêu cầu
      case 0:
        return _processingCard(m);
      // Status 1: Báo giá
      case 1:
        return _quoteCard(m, controller, context, appointmentId);
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
        return _completeCard(m); // Thêm widget cho trạng thái Thanh toán
      // Status 7: Hoàn thành
      case 7:
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
            Text('${'code'.tr}: #${m.appointment_id}',
                style: const TextStyle(
                    fontSize: 14, color: ColorHex.grey_shade600)),
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
                '${'service'.tr}:',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
        //totalPrice += service.price ?? 0;
        totalTime += _parseDurationToMinutes(service.time ?? '0:00:00');
      }
    }
    // final formattedPrice =
    //     NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(totalPrice);
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
              Row(
                children: const [
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
                        .format(grandTotal),
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
                      onPressed: () {
                        openSettlementDetails(m.appointment_id ?? 0, context);
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
                  // GestureDetector(
                  //   onTap: () {
                  //     //controller.downloadInvoice(m.idLichHen);
                  //   },
                  //   child: const Icon(Icons.download_rounded),
                  // ),
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
                            controller.CancelAppoint(
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
      backgroundColor: Colors.transparent, // để bo tròn đẹp hơn
      builder: (_) => SafeArea(
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6, // mở lên 60% màn hình
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (_, scrollCtrl) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              // Nếu đang load, hiện spinner
              if (controller.isLoadingSettlement.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Lấy giá trị, đảm bảo không null
              final totalAmt = controller.totalAmount.value ?? 0;

              return ListView(
                controller: scrollCtrl,
                children: [
                  // Drag handle
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
                      visualDensity: VisualDensity(vertical: -4),
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
                            backgroundColor: ColorHex.grey_shade300,
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
