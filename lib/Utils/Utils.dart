import 'dart:convert';
import 'dart:io';
import 'package:app_hm/Global/ColorHex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future saveStringWithKey(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(key, value);
  }

  static Future saveIntWithKey(String key, int value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt(key, value);
  }

  static Future getStringValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key) ?? '';
  }

  static Future getIntValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(key) ?? 0;
  }

  static Future getBoolValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(key) ?? false;
  }

  static Future saveBoolWithKey(String key, bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(key, value);
  }

  static Future<void> removeKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(key);
  }

  static void showSnackBar(
      {required String title,
      required String message,
      Color? colorText = Colors.white,
      Widget? icon,
      bool isDismissible = true,
      Duration duration = const Duration(seconds: 2),
      Duration animationDuration = const Duration(seconds: 1),
      Color? backgroundColor = Colors.black,
      SnackPosition? direction = SnackPosition.TOP,
      Curve? animation}) {
    Get.snackbar(
      title,
      message,
      colorText: colorText,
      duration: duration,
      animationDuration: animationDuration,
      icon: icon,
      backgroundColor: backgroundColor!.withOpacity(0.3),
      snackPosition: direction,
      forwardAnimationCurve: animation,
    );
  }

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static getImagePicker(int source) async {
    ImagePicker picker = ImagePicker();
    File? file;
    try {
      await picker
          .pickImage(
        source: source == 1 ? ImageSource.camera : ImageSource.gallery,
      )
          .then((value) {
        if (value != null) {
          file = File(value.path);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error file: $e');
      }
    }
    return file;
  }

  static String getStatusString(int value) {
    switch (value) {
      case 2:
        return 'Đang cân';
      case 3:
        return 'Tạm dừng';
      case 4:
        return 'Đã cân (chưa KCS)';
      case 5:
        return 'Đã KCS';
      case 6:
        return 'Chốt kế toán';
      default:
        return '---';
    }
  }

  static String getScaleType(int value) {
    return value == 0 ? 'Cân lẻ' : 'Cân lô'; // 1 cân  lô
  }

  static Color getOutputText(int value) {
    switch (value) {
      case 0:
        return ColorHex.status_0;
      case 1:
        return ColorHex.status_1;
      case 2:
        return ColorHex.status_2;
      case 3:
        return ColorHex.status_3;
      case 4:
        return ColorHex.status_4;
      case 5:
        return ColorHex.status_5;
      default:
        return Colors.transparent;
    }
  }
}
