import 'package:app_hm/Controller/Appointment/AppointmentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AppointmentBook extends StatelessWidget {
  const AppointmentBook({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Appointmentcontroller());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Đặt dịch vụ'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildStepIndicator(),
            const SizedBox(height: 16),
            _buildServiceOptions(controller),
            const SizedBox(height: 16),
            _buildAddDescription(controller, context),
            const SizedBox(height: 24),
            _buildDropdownTile(
                "TỈNH/THÀNH PHỐ", controller.selectedCity, () {}),
            const SizedBox(height: 16),
            _buildDropdownTile("LOẠI DỊCH VỤ",
                controller.selectedServiceType ?? "Chọn loại dịch vụ", () {
              _showServiceTypeDialog(controller, context);
            }),
            const SizedBox(height: 32),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // xử lý khi nhấn Tiếp theo
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  "Tiếp theo",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        _StepCircle(number: "1", label: "Dịch vụ", isActive: true),
        _StepCircle(number: "2", label: "Địa điểm"),
        _StepCircle(number: "3", label: "Thời gian"),
        _StepCircle(number: "4", label: "Xác nhận"),
      ],
    );
  }

  Widget _buildServiceOptions(Appointmentcontroller controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: controller.selectedServices.keys.map((key) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 12),
          child: CheckboxListTile(
            value: controller.selectedServices[key],
            onChanged: (value) {
              // setState(() {
              //   controller.selectedServices[key] = value ?? false;
              // });
            },
            title: Text(key),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddDescription(Appointmentcontroller controller, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("CHI TIẾT DỊCH VỤ",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            _showDescriptionDialog(controller, context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: const [
                Icon(Icons.add, color: Colors.blue),
                SizedBox(width: 8),
                Text("Thêm mô tả", style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "VinFast cung cấp Mobile Service tuỳ theo tình trạng của xe.",
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget _buildDropdownTile(String title, String value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _showServiceTypeDialog(Appointmentcontroller controller, context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView(
        shrinkWrap: true,
        children: controller.serviceTypes.map((type) {
          return ListTile(
            title: Text(type),
            onTap: () {
              // setState(() {
              //   controller.selectedServiceType = type;
              // });
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  void _showDescriptionDialog(Appointmentcontroller controller, context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Thêm mô tả"),
        content: TextField(
          controller: controller.descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(hintText: "Nhập mô tả..."),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Huỷ")),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Lưu")),
        ],
      ),
    );
  }
}

// Step Indicator Widget
class _StepCircle extends StatelessWidget {
  final String number;
  final String label;
  final bool isActive;

  const _StepCircle({
    required this.number,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: isActive ? Colors.blue : Colors.grey.shade300,
          child: Text(number,
              style: TextStyle(
                  color: isActive ? Colors.white : Colors.black, fontSize: 12)),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
