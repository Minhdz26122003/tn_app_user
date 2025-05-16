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
    this.services,
  });

  //Trả về index để dùng trong Stepper/Timeline
  int get currentStatusIndex {
    if (status != null && status! >= 0 && status! <= 8) {
      return status!;
    } else {
      return 0;
    }
  }

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
      // json['service_id'] có thể là int hoặc String, ta parse về int:
      service_id: json['service_id'] is int
          ? json['service_id'] as int
          : int.tryParse(json['service_id'].toString()) ?? 0,

      service_name: json['service_name']?.toString() ?? '',
      // Giá có thể là num hoặc String, ép về int:
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      // Time giữ nguyên chuỗi
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
