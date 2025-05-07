class AppointmentModel {
  int? appointment_id;
  int? uid;
  int? car_id;
  int? gara_id;
  String? gara_name;
  String? gara_address;
  String? appointment_date;
  String? appointment_time;
  String? description;
  String? reason;
  int? status;
  String? created_at;

  // Tạo tạm thời
  double? quoteAmount;
  double? depositAmount;
  double? totalAmount;

  // Thêm trường này để chứa danh sách dịch vụ
  List<ServiceDetail>? services;

  AppointmentModel({
    this.appointment_id,
    this.uid,
    this.appointment_date,
    this.car_id,
    this.gara_id,
    this.gara_name,
    this.gara_address,
    this.appointment_time,
    this.description,
    this.reason,
    this.status,
    this.created_at,
    this.quoteAmount,
    this.depositAmount,
    this.totalAmount,
    this.services, // Thêm vào constructor
  });

  //Trả về index để dùng trong Stepper/Timeline
  int get currentStatusIndex {
    if (status != null && status! >= 0 && status! <= 5) {
      return status!;
    } else {
      return 0;
    }
  }

  // static const int PROCESSING = 0;
  // static const int QUOTE_APPOINT = 1;
  // static const int REPAIR = 2;
  // static const int SETTLEMENT_APPOINT = 3;
  // static const int PAY = 4;
  // static const int PAID = 5;
  // static const int CANCELLED = 6;

  // // Thêm trạng thái Thanh toán

  // // Cập nhật currentStatusIndex
  // int get currentStatusIndex {
  //   switch (status) {
  //     case PROCESSING:
  //       return 0;
  //     case QUOTE_APPOINT:
  //       return 1;
  //     case REPAIR:
  //       return 2;
  //     case SETTLEMENT_APPOINT:
  //       return 3;
  //     case PAY:
  //       return 4;
  //     case PAID:
  //       return 5;
  //     case CANCELLED:
  //       return 6;
  //     default:
  //       return 0;
  //   }
  // }

  // String get currentStatus {
  //   switch (status) {
  //     case PROCESSING:
  //       return 'Đang xử lý yêu cầu';
  //     case QUOTE_APPOINT:
  //       return 'Báo giá';
  //     case REPAIR:
  //       return 'Đang sửa chữa';
  //     case SETTLEMENT_APPOINT:
  //       return 'Quyết toán';
  //     case PAY:
  //       return 'Thanh toán';
  //     case PAID:
  //       return 'Đã thanh toán';
  //     case CANCELLED:
  //       return 'Đã hủy';
  //     default:
  //       return 'Không xác định';
  //   }
  // }

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    appointment_id = json['appointment_id'];
    uid = json['uid'];
    car_id = json['car_id'];
    gara_id = json['gara_id'];
    gara_address = json['gara_address'];
    gara_name = json['gara_name'];
    appointment_time = json['appointment_time'];
    description = json['description'];
    reason = json['reason'];
    appointment_date = json['appointment_date'];
    status = json['status'];
    created_at = json['created_at'];
    quoteAmount = json['quoteAmount'] != null
        ? double.tryParse(json['quoteAmount'].toString())
        : null;
    depositAmount = json['depositAmount'] != null
        ? double.tryParse(json['depositAmount'].toString())
        : null;
    totalAmount = json['totalAmount'] != null
        ? double.tryParse(json['totalAmount'].toString())
        : null;

    // Xử lý danh sách dịch vụ nếu có
    if (json['services'] != null && json['services'] is List) {
      services = (json['services'] as List)
          .map((item) => ServiceDetail.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      services = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appointment_id'] = appointment_id;
    data['uid'] = uid;
    data['car_id'] = car_id;
    data['gara_id'] = gara_id;
    data['gara_name'] = gara_name;
    data['gara_address'] = gara_address;
    data['appointment_time'] = appointment_time;
    data['description'] = description;
    data['reason'] = reason;
    data['appointment_date'] = appointment_date;
    data['status'] = status;
    data['created_at'] = created_at;
    data['quoteAmount'] = quoteAmount;
    data['depositAmount'] = depositAmount;
    data['totalAmount'] = totalAmount;
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// Model cho thông tin chi tiết dịch vụ
class ServiceDetail {
  int? service_id;
  String? service_name;
  String? service_img;
  double? price;
  String? time; // Hoặc có thể là int nếu thời gian là số phút

  ServiceDetail({
    this.service_id,
    this.service_name,
    this.service_img,
    this.price,
    this.time,
  });

  ServiceDetail.fromJson(Map<String, dynamic> json) {
    service_id = json['service_id'];
    service_name = json['service_name'];
    service_img = json['service_img'];
    price = json['price'] != null
        ? double.tryParse(json['price'].toString())
        : null;
    time = json['time']?.toString(); // Đảm bảo là String
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = service_id;
    data['service_name'] = service_name;
    data['service_img'] = service_img;
    data['price'] = price;
    data['time'] = time;
    return data;
  }
}
