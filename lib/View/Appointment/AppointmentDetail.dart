import 'package:app_hm/Global/ColorHex.dart';
import 'package:app_hm/Model/Appointment/ApointmentModel.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:get/get.dart';

class Appoointmentdetail extends StatelessWidget {
  const Appoointmentdetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppointmentModel model = Get.arguments;

    final currentStep = model.currentStatusIndex;

    return Scaffold(
      appBar: AppBar(
        title:
            Text('detail_service'.tr, style: TextStyle(color: ColorHex.white)),
        backgroundColor: ColorHex.total_color,
        leading: BackButton(color: ColorHex.white),
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
                    Text('code'.tr + ':${model.appointment_id!}',
                        style: TextStyle(
                            fontSize: 14, color: ColorHex.grey_shade600)),
                  ]),
            ),
          ),

          // Timeline
          ...List.generate(Utils.steps.length, (i) {
            return TimelineTile(
              isFirst: i == 0,
              isLast: i == Utils.steps.length - 1,
              indicatorStyle: IndicatorStyle(
                width: 20,
                color: i <= currentStep
                    ? ColorHex.total_color
                    : (ColorHex.grey_shade300 ?? ColorHex.grey),
              ),
              beforeLineStyle: LineStyle(
                color: i <= currentStep - 1
                    ? ColorHex.total_color
                    : (ColorHex.grey_shade300 ?? ColorHex.grey),
                thickness: 4,
              ),
              afterLineStyle: LineStyle(
                color: i < currentStep
                    ? ColorHex.total_color
                    : (ColorHex.grey_shade300 ?? ColorHex.grey),
                thickness: 4,
              ),
              endChild: Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(
                  Utils.steps[i],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        i == currentStep ? FontWeight.bold : FontWeight.normal,
                    color: i <= currentStep ? ColorHex.black : ColorHex.grey,
                  ),
                ),
              ),
            );
          }),

          SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            OutlinedButton(
              onPressed: () {/* hủy */},
              child: Text('cancel_request'.tr),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorHex.total_color),
              onPressed: () {/* đặt lại */},
              child: Text('reschedule_appt'.tr),
            ),
          ]),
          SizedBox(height: 24),
        ]),
      ),
    );
  }
}
