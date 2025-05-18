import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Model/Payment/PaymentModel.dart';
import 'package:app_hm/Services/APICaller.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class PaymentController extends GetxController {
  // Biến giữ PaymentModel
  int uid = 0;
  RxList<PaymentModel> paymentList = RxList<PaymentModel>();
  RxInt selectedMethod = 0.obs;
  // theo dõi đối tượng chọn bắt đầu là null
  Rxn<PaymentModel> payment = Rxn<PaymentModel>();

  RxBool isLoadingPayment = false.obs;
  RxBool isProcessingOnline = false.obs;
  @override
  void onInit() async {
    uid = await Utils.getIntValueWithKey(Constant.UUID_USER_ACC);

    super.onInit();
  }

  @override
  void onClose() {
    print('on close second');
    super.onClose();
  }

  /// 1) Fetch thông tin payment từ server

  Future<void> fetchPayment(int appointmentId) async {
    isLoadingPayment.value = true;
    try {
      final time = DateFormat('MM/dd/yyyy HH:mm:ss').format(DateTime.now());
      final keyCert = Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + time);

      final params = {
        'keyCert': keyCert,
        'time': time,
        'uid': uid,
        'appointment_id': appointmentId,
      };

      final data =
          await APICaller.getInstance().post('Payment/get_payment.php', params);
      //print('dataa :$data');
      if (data != null && data['status'] == 'success') {
        final json = data['data'] as Map<String, dynamic>?;
        if (json != null) {
          payment.value = PaymentModel.fromJson(json);
          // debugPrint('Loaded payment: ${payment.value!.toJson()}');
        } else {
          throw 'Dữ liệu hoá đơn rỗng';
        }
      } else {
        final msg = data?['error']?['message'] ?? 'Không tải được hoá đơn';
        throw msg;
      }
    } catch (e) {
      debugPrint('Lỗi API fetchPayment: $e');
      //Utils.showSnackBar(title: 'Lỗi', message: e.toString());
    } finally {
      isLoadingPayment.value = false;
    }
  }

  Future<void> PaymentOffline(int payID) async {
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    var param = {
      "keyCert":
          Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "payment_id": payID,
    };
    try {
      var response =
          await APICaller.getInstance().post('Payment/add_offline.php', param);
      if (response != null && response['status'] == 'success') {
        Utils.showSnackBar(
          title: 'notification'.tr,
          message: response?['error']['message'] ??
              'Cập nhật phường thức thanh toán thành công!',
        );
      } else {
        Utils.showSnackBar(
          title: 'notification'.tr,
          message: response?['error']['message'],
        );
      }
    } catch (e) {
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  // Trả về URL thanh toán từ server rồi open WebView hoặc trình duyệt
  Future<void> startOnlinePayment({
    required int appointmentId,
    required double amount,
  }) async {
    isProcessingOnline.value = true;
    try {
      final now = DateTime.now();
      final time = DateFormat('MM/dd/yyyy HH:mm:ss').format(now);
      final keyCert = Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + time);

      final params = {
        'keyCert': keyCert,
        'time': time,
        'uid': uid,
        'appointment_id': appointmentId,
        'amount': amount,
      };

      final data = await APICaller.getInstance()
          .post('Payment/create_payment_url.php', params);

      if (data != null && data['status'] == 'success') {
        final url = data['data']['payment_url'] as String;
        // if (await canLaunch(url)) {
        //   await launch(url, forceSafariVC: true, forceWebView: true);
        // } else {
        //   throw 'Không thể mở URL thanh toán';
        // }
      } else {
        final msg = data?['error']?['message'] ?? 'Tạo thanh toán thất bại';
        Utils.showSnackBar(title: 'Lỗi', message: msg);
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: e.toString());
    } finally {
      isProcessingOnline.value = false;
    }
  }
}
