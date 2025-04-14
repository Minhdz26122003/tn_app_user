import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StepBook extends StatelessWidget {
  final int currentStep;
  final List<String> labels;

  const StepBook({
    Key? key,
    required this.currentStep,
    this.labels = const ["Dịch vụ", "Địa điểm", "Thời gian", "Xác nhận"],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Chỉ các bước từ 1 đến currentStep được active
    List<bool> steps =
        List.generate(labels.length, (index) => currentStep >= (index + 1));

    return Row(
      children: List.generate(labels.length * 2 - 1, (index) {
        if (index.isEven) {
          int stepIndex = index ~/ 2;
          return _StepCircle(
            number: (stepIndex + 1).toString(),
            label: labels[stepIndex],
            isActive: steps[stepIndex],
          );
        } else {
          // Đường nối
          int stepIndex = index ~/ 2;
          return Expanded(
            child: Container(
              height: 5,
              margin: const EdgeInsets.only(bottom: 18),
              color: stepIndex < (currentStep - 1)
                  ? Colors.blue
                  : Colors.grey.shade300,
            ),
          );
        }
      }),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final String number;
  final String label;
  final bool isActive;

  const _StepCircle({
    Key? key,
    required this.number,
    required this.label,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: isActive ? Colors.blue : Colors.grey.shade300,
          child: Text(
            number,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
