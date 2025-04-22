import 'package:app_hm/Model/Appointment/ApointmentModel.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:get/get.dart';

class Appoointmentdetail extends StatelessWidget {
  const Appoointmentdetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppointmentModel model = Get.arguments;
    final steps = [
      "Đang xử lý yêu cầu",
      "Báo giá",
      "Sửa chữa",
      "Quyết toán",
      "Thanh toán",
    ];
    final currentStep = model.currentStatusIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết dịch vụ", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2D74FF),
        leading: BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Card(
            margin: EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.gara_name!,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text("${model.appointment_time!}",
                        style: TextStyle(fontSize: 14)),
                    SizedBox(height: 4),
                    Text(model.gara_address!, style: TextStyle(fontSize: 14)),
                    SizedBox(height: 4),
                    Text("Mã dịch vụ: ${model.appointment_id!}",
                        style:
                            TextStyle(fontSize: 14, color: Colors.grey[600])),
                  ]),
            ),
          ),

          // Timeline
          ...List.generate(steps.length, (i) {
            return TimelineTile(
              isFirst: i == 0,
              isLast: i == steps.length - 1,
              indicatorStyle: IndicatorStyle(
                width: 20,
                color: i <= currentStep
                    ? Color(0xFF2D74FF)
                    : (Colors.grey[300] ?? Colors.grey),
              ),
              beforeLineStyle: LineStyle(
                color: i <= currentStep - 1
                    ? Color(0xFF2D74FF)
                    : (Colors.grey[300] ?? Colors.grey),
                thickness: 4,
              ),
              afterLineStyle: LineStyle(
                color: i < currentStep
                    ? Color(0xFF2D74FF)
                    : (Colors.grey[300] ?? Colors.grey),
                thickness: 4,
              ),
              endChild: Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(
                  steps[i],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        i == currentStep ? FontWeight.bold : FontWeight.normal,
                    color: i <= currentStep ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            );
          }),

          SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            OutlinedButton(
              onPressed: () {/* hủy */},
              child: Text("Huỷ yêu cầu"),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFF2D74FF)),
              onPressed: () {/* đặt lại */},
              child: Text("Đặt lại lịch"),
            ),
          ]),
          SizedBox(height: 24),
        ]),
      ),
    );
  }
}
