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

  double? quoteAmount; // Thêm cho báo giá
  double? depositAmount; // Thêm cho đặt cọc
  double? totalAmount;

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
  });

  // Trả về index để dùng trong Stepper/Timeline
  int get currentStatusIndex {
    if (status != null && status! >= 0 && status! <= 5) {
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

    quoteAmount = json['quoteAmount'];
    depositAmount = json['depositAmount'];
    totalAmount = json['totalAmount'];
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
    return data;
  }
}
