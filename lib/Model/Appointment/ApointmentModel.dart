import 'package:app_hm/Model/Payment/PaymentModel.dart';

class AppointmentModel {
  int? appointment_id;
  int? uid;
  String? fullname;
  String? phonenum;
  String? email;
  String? name;
  String? phone;
  int? car_id;
  int? gara_id;
  String? gara_name;
  String? license_plate;
  String? gara_address;
  String? appointment_date;
  String? appointment_time;
  String? description;
  String? reason;
  int? status;
  String? created_at;

  // Thêm trường này để chứa danh sách dịch vụ
  List<ServiceDetail>? services;
  PaymentModel? payment;

  AppointmentModel({
    this.appointment_id,
    this.uid,
    this.fullname,
    this.phonenum,
    this.email,
    this.name,
    this.phone,
    this.appointment_date,
    this.car_id,
    this.gara_id,
    this.gara_name,
    this.license_plate,
    this.gara_address,
    this.appointment_time,
    this.description,
    this.reason,
    this.status,
    this.created_at,
    this.services,
    this.payment,
  });

  //Trả về index để dùng trong Stepper/Timeline
  int get currentStatusIndex {
    if (status != null && status! >= 0 && status! <= 8) {
      return status!;
    } else {
      return 0;
    }
  }

  // Helper để lấy tên dịch vụ (nếu có nhiều dịch vụ, có thể nối lại)
  String get serviceName {
    if (services != null && services!.isNotEmpty) {
      return services!.map((e) => e.service_name).join(', ');
    }
    return 'N/A';
  }

  // Trả về tổng tiền của dịch vụ
  double get totalAmount {
    if (payment != null && payment!.total_price != null) {
      return payment!.total_price!;
    }
    if (services != null && services!.isNotEmpty) {
      return services!
          .fold(0.0, (sum, service) => sum + (service.price ?? 0.0));
    }
    return 0.0;
  }

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    appointment_id = json['appointment_id'];
    uid = json['uid'];
    car_id = json['car_id'];
    gara_id = json['gara_id'];
    fullname = json['fullname'];
    phonenum = json['phonenum'];
    email = json['email'];
    phone = json['phone'];
    name = json['name'];
    gara_address = json['gara_address'];
    license_plate = json['license_plate'];
    gara_name = json['gara_name'];
    appointment_time = json['appointment_time'];
    description = json['description'];
    reason = json['reason'];
    appointment_date = json['appointment_date'];
    status = json['status'];
    created_at = json['created_at'];

    // Xử lý danh sách dịch vụ nếu có
    if (json['services'] != null && json['services'] is List) {
      services = (json['services'] as List)
          .map((item) => ServiceDetail.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      services = [];
    }
    if (json['payment'] != null) {
      payment = PaymentModel.fromJson(json['payment']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appointment_id'] = appointment_id;
    data['uid'] = uid;
    data['car_id'] = car_id;
    data['gara_id'] = gara_id;
    data['fullname'] = fullname;
    data['phonenum'] = phonenum;
    data['email'] = email;
    data['car_name'] = name;
    data['gara_name'] = gara_name;
    data['phone'] = phone;
    data['license_plate'] = license_plate;
    data['gara_address'] = gara_address;
    data['appointment_time'] = appointment_time;
    data['description'] = description;
    data['reason'] = reason;
    data['appointment_date'] = appointment_date;
    data['status'] = status;
    data['created_at'] = created_at;

    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (payment != null) {
      data['payment'] = payment!.toJson();
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
  String? time;

  ServiceDetail({
    this.service_id,
    this.service_name,
    this.service_img,
    this.price,
    this.time,
  });

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return ServiceDetail(
      service_id: json['service_id'] is int
          ? json['service_id'] as int
          : int.tryParse(json['service_id'].toString()) ?? 0,
      service_name: json['service_name']?.toString() ?? '',
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      time: json['time']?.toString() ?? '0:00:00',
    );
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
