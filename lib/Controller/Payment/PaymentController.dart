import 'dart:convert';

import 'package:app_hm/Controller/Appointment/AppointmentController.dart';
import 'package:app_hm/Global/Constant.dart';
import 'package:app_hm/Model/Deposits/DepositModel.dart';
import 'package:app_hm/Model/Payment/PaymentModel.dart';
import 'package:app_hm/Router/AppPage.dart';
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
  RxBool isLoading = false.obs;
  // Biến giữ PaymentModel
  int uid = 0;
  RxList<PaymentModel> paymentList = RxList<PaymentModel>();
  RxInt selectedMethod = 0.obs;
  // theo dõi đối tượng chọn bắt đầu là null
  Rxn<PaymentModel> payment = Rxn<PaymentModel>();
  Rxn<DepositModel> deposit = Rxn<DepositModel>();

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

  // Hàm tạo thanh toán VNPAY cho tiền đặt cọc
  Future<void> depositPayment(
      int depositId, int appointmentId, double amount) async {
    isLoading.value = true;
    DateTime t = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(t);
    String keyCert =
        Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime);

    var param = {
      "keyCert": keyCert,
      "time": formattedTime,
      "deposit_id": depositId,
      "amount": amount,
      "uid": uid,
      "appointment_id": appointmentId,
    };

    try {
      var data =
          await APICaller.getInstance().post('Payment/pay_deposit.php', param);

      debugPrint('Phản hồi từ API add_deposit_online.php: $data');

      if (data != null && data['status'] == 'success') {
        String paymentUrl = data['data']['payment_url'];
        debugPrint('VNPAY Deposit URL: $paymentUrl');
        if (paymentUrl != null && paymentUrl.isNotEmpty) {
          print('VNPAY URL: $paymentUrl');

          final result = await Get.to<bool>(
            () => VnPayWebViewPage(url: paymentUrl),
            fullscreenDialog: true,
          );
          if (result == true) {
            Get.back();
            Get.snackbar('Thành công', 'Thanh toán tiền cọc hoàn tất.',
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
        // Lấy thông báo lỗi cụ thể từ server nếu có
        final serverMessage = data?['error']?['message']?.toString();
        final msg = serverMessage ??
            'Không thể khởi tạo thanh toán VNPAY cho tiền cọc.'; //
        Utils.showSnackBar(title: 'Lỗi', message: msg); //
        debugPrint('Lỗi khi tạo URL thanh toán cọc VNPAY: $msg'); //
      }
    } catch (e) {
      debugPrint('Lỗi API createVnPayDepositPayment: $e');
      Utils.showSnackBar(
          title: 'Lỗi',
          message: 'Không thể kết nối tới máy chủ khi tạo thanh toán cọc.');
    } finally {
      isLoading.value = false;
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

      print('responseData: $responseData');

      if (responseData == null) {
        Get.snackbar(
          'Lỗi',
          'Không nhận được phản hồi từ máy chủ hoặc đã thanh toán rồi.',
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
            Get.offAndToNamed(Routes.personal);

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

  /// Fetch thông tin cọc
  Future<void> fetchDeposit(int appointmentId) async {
    isLoading.value = true;
    try {
      DateTime timeNow = DateTime.now();
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      String keyCert =
          Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime);

      var param = {
        "keyCert": keyCert,
        "time": formattedTime,
        "uid": uid, // Đảm bảo uid được khởi tạo trong PaymentController
        "appointment_id": appointmentId,
      };

      debugPrint(
          'Fetching deposit for appointment_id: $appointmentId with UID: $uid');
      var data =
          await APICaller.getInstance().post('Payment/get_deposit.php', param);

      if (data != null && data['status'] == 'success') {
        if (data['data'] != null && data['data']['deposit'] != null) {
          deposit.value = DepositModel.fromJson(data['data']['deposit']);
          debugPrint('Loaded deposit: ${deposit.value!.toJson()}');
        } else {
          deposit.value = null; // Không có đặt cọc
          debugPrint('No deposit found for appointment ID: $appointmentId');
        }
      } else {
        final msg =
            data?['error']?['message'] ?? 'Không tải được thông tin đặt cọc.';
        debugPrint('Error fetching deposit: $msg');
        Get.snackbar(
          'Lỗi',
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        deposit.value = null;
      }
    } catch (e) {
      debugPrint('Exception while fetching deposit: $e');
      Get.snackbar(
        'Lỗi hệ thống',
        'Không thể kết nối tới máy chủ hoặc xảy ra lỗi mạng khi lấy đặt cọc.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      deposit.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch thông tin payment từ server
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

  Future<void> paymentOffline(int payID) async {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(now);

    final params = {
      "keyCert":
          Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "payment_id": payID,
    };

    try {
      // Gọi API
      final response =
          await APICaller.getInstance().post('Payment/add_offline.php', params);

      if (response == null) {
        Utils.showSnackBar(
          title: 'notification'.tr,
          message: 'Không nhận được phản hồi từ máy chủ.',
        );
        return;
      }

      final status = response['status'] as String?;

      switch (status) {
        case 'success':
          Utils.showSnackBar(
            title: 'notification'.tr,
            message: response['error']?['message'] ??
                'Xác nhận thanh toán offline thành công!',
          );
          break;

        case 'exists':
          Utils.showSnackBar(
            title: 'notification'.tr,
            message: response['error']?['message'] ??
                'Bạn đã xác nhận thanh toán offline trước đó.',
          );
          break;

        case 'error':
          Utils.showSnackBar(
            title: 'notification'.tr,
            message: response['error']?['message'] ??
                'Đã có lỗi xảy ra, vui lòng thử lại.',
          );
          break;

        default:
          Utils.showSnackBar(
            title: 'notification'.tr,
            message: 'Phản hồi không xác định từ server.',
          );
      }
    } catch (e) {
      Utils.showSnackBar(
        title: 'notification'.tr,
        message: 'Lỗi khi gọi API: $e',
      );
    }
  }
}
