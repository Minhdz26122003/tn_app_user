import 'dart:convert';

import 'package:app_hm/Controller/Appointment/AppointmentController.dart';
import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Model/Payment/PaymentModel.dart';
import 'package:app_hm/Services/APICaller.dart';
import 'package:app_hm/Utils/Utils.dart';
import 'package:app_hm/View/Payment/VnPayWebViewPage%20.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_links/app_links.dart';

import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

class PaymentController extends GetxController {
  final String baseUrl = "https://wecarmih.loca.lt/apihm/User/";
  //final String baseUrl = "http://192.168.1.2/apihm/User/";
  late final AppLinks _appLinks; // Khởi tạo AppLinks
  StreamSubscription? _appLinksSubscription; // Để lắng nghe Deep Links

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
    _appLinks = AppLinks(); // Khởi tạo instance của AppLinks
    _initAppLinks();
    super.onInit();
  }

  @override
  void onClose() {
    print('on close second');
    _appLinksSubscription?.cancel();
    super.onClose();
  }

  Future<void> _initAppLinks() async {
    // Initial deep link
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _handleDeepLink(uri.toString());
      }
    } on PlatformException {
      print('Failed to get initial app link.');
    } catch (e) {
      print('Error getting initial app link: $e');
    }

    // Stream of incoming deep links
    _appLinksSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri.toString());
      }
    }, onError: (err) {
      print('Failed to get app link stream: $err');
    });
  }

  void _handleDeepLink(String link) {
    print('Deep link received: $link');
    final uri = Uri.parse(link);

    if (uri.scheme == 'apphm' && uri.host == 'payment') {
      // Đảm bảo khớp với scheme và host bạn đã cấu hình
      final outcome = uri.queryParameters['outcome'];
      final message = uri.queryParameters['message'];
      final paymentId = uri.queryParameters['payment_id'];
      final amount = uri.queryParameters['amount'];
      final responseCode = uri.queryParameters['vnp_ResponseCode'];
      final transactionStatus = uri.queryParameters['vnp_TransactionStatus'];

      // Xử lý kết quả thanh toán tại đây
      if (outcome == 'success') {
        Get.snackbar(
          'Thanh toán thành công',
          'Đơn hàng $paymentId đã được thanh toán thành công với số tiền $amount VNĐ.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );
        // Rất quan trọng: Bạn cần làm mới dữ liệu lịch hẹn ở đây để hiển thị trạng thái mới.
        // Get.back(result: true); // Truyền true để báo hiệu đã có thay đổi
        // Lấy lại AppointmentController để làm mới dữ liệu
        final Appointmentcontroller appointmentController =
            Get.find<Appointmentcontroller>();
        final int? appointmentId = int.tryParse(
            uri.queryParameters['appointment_id'] ??
                ''); // Lấy lại appointment_id nếu có
        if (appointmentId != null) {
          appointmentController.getSettlementUser(appointmentId);
          // Sau khi xử lý xong ở PaymentScreen, chúng ta có thể quay về màn hình trước
          // Nếu bạn đang ở PaymentScreen, Get.back() sẽ đưa bạn về Appointment Detail
          // Nếu bạn muốn đảm bảo quay về Appointment Detail dù có thể đã qua nhiều màn hình,
          // bạn có thể dùng Get.until hoặc Get.off/Get.offAll nếu bạn quản lý route bằng tên.
          Get.back(); // Quay về PaymentScreen, sau đó PaymentScreen sẽ tự động đóng nếu cần
          Get.back(); // Thêm một Get.back() nữa để đóng PaymentScreen và quay về Appointment Detail
        } else {
          // Xử lý nếu không lấy được appointment_id từ deep link (cần cập nhật return_url.php để truyền appointment_id)
          print(
              'Warning: appointment_id not found in deep link for successful payment.');
          // Bạn có thể quay lại trang AppointmentDetail và refresh tất cả lịch hẹn hoặc yêu cầu người dùng refresh.
          Get.back(); // Quay về màn hình trước
        }
      } else {
        Get.snackbar(
          'Thanh toán thất bại',
          '$message (Mã VNPAY: $responseCode, Trạng thái: $transactionStatus)',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        // Get.back(result: false); // Truyền false để báo hiệu không có thay đổi hoặc thất bại
        Get.back(); // Quay về màn hình trước
      }
    }
  }

  Future<void> createVnPayPayment({
    required int appointment_id,
    required double total_price,
  }) async {
    try {
      print('Bắt đầu gọi API createVnPayPayment...');
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final now = DateTime.now();
      final time = DateFormat('MM/dd/yyyy HH:mm:ss').format(now);
      final keyCert = Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + time);
      final params = {
        'keyCert': keyCert,
        'time': time,
        'uid': uid,
        'appointment_id': appointment_id,
        'total_price': total_price,
      };

      print('Params gửi đi: $params');
      var responseData =
          await APICaller.getInstance().post('Payment/add_online.php', params);
      Get.back(); // Đóng loading dialog
      print('Đã nhận phản hồi từ API');
      print('responseData: $responseData');

      if (responseData == null) {
        Get.snackbar(
          'Lỗi',
          'Không nhận được phản hồi từ máy chủ.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return;
      }

      if (responseData['status'] == 'success') {
        final String? vnpayUrl = responseData['payment_url']?.toString();

        if (vnpayUrl != null && vnpayUrl.isNotEmpty) {
          print('VNPAY URL: $vnpayUrl');

          final result = await Get.to<bool>(
            () => VnPayWebViewPage(url: vnpayUrl),
            fullscreenDialog: true,
          );
          if (result == true) {
            Get.back();
            Get.back();
            Get.snackbar('Thành công', 'Thanh toán hoàn tất.',
                snackPosition: SnackPosition.TOP);
          } else {
            Get.snackbar('Hủy/Thất bại', 'Giao dịch chưa hoàn thành.',
                snackPosition: SnackPosition.TOP);
          }
        } else {
          Get.snackbar(
            'Lỗi',
            'URL thanh toán VNPAY không hợp lệ hoặc không có.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
          );
        }
      } else {
        String errorMessage = 'Có lỗi xảy ra khi tạo URL thanh toán.';
        if (responseData['error'] != null &&
            responseData['error']['message'] != null) {
          errorMessage = responseData['error']['message'];
        }

        Get.snackbar(
          'Lỗi tạo thanh toán',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      Get.back();
      print('Lỗi tổng quát khi gọi API VNPAY: $e');
      Get.snackbar(
        'Lỗi',
        'Đã xảy ra lỗi không mong muốn: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
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
}
