import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Appointmentcontroller extends GetxController {
  Map<String, bool> selectedServices = {
    "Sửa chữa chung": false,
    "Sửa chữa thân vỏ/đồng sơn": false,
    "Sửa chữa khác": false,
  };

  TextEditingController descriptionController = TextEditingController();
  String selectedCity = "Hà Nội";
  String? selectedServiceType;

  final List<String> serviceTypes = [
    "Bảo dưỡng định kỳ",
    "Thay dầu",
    "Kiểm tra điện",
  ];
}
