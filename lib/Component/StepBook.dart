import 'package:app_hm/Global/ColorHex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StepBook extends StatelessWidget {
  final int currentStep;
  final List<String> labels;

  const StepBook({
    super.key,
    required this.currentStep,
    this.labels = const ['service', 'address', 'time', 'confirm'],
  });

  @override
  Widget build(BuildContext context) {
    // Dịch tại thời điểm build
    final translatedLabels = labels.map((key) => key.tr).toList();

    // Chỉ các bước từ 1 đến currentStep được active
    List<bool> steps = List.generate(
        translatedLabels.length, (index) => currentStep >= (index + 1));

    return Row(
      children: List.generate(translatedLabels.length * 2 - 1, (index) {
        if (index.isEven) {
          int stepIndex = index ~/ 2;
          return _StepCircle(
            number: (stepIndex + 1).toString(),
            label: translatedLabels[stepIndex],
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
                  ? ColorHex.total_color
                  : ColorHex.grey_shade300,
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
    super.key,
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
          backgroundColor:
              isActive ? ColorHex.total_color : ColorHex.grey_shade300,
          child: Text(
            number,
            style: TextStyle(
              color: isActive ? ColorHex.white : ColorHex.black,
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
