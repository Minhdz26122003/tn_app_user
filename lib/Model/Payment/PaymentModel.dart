class PaymentModel {
  int? payment_id;
  int? appointment_id;
  String? payment_date;
  int? form;
  int? status;
  double? total_price;

  PaymentModel({
    this.payment_id,
    this.appointment_id,
    this.payment_date,
    this.form,
    this.status,
    this.total_price,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      payment_id: json['payment_id'] is int
          ? json['payment_id'] as int
          : int.tryParse(json['payment_id'].toString()) ?? 0,
      appointment_id: json['appointment_id'] is int
          ? json['appointment_id'] as int
          : int.tryParse(json['appointment_id'].toString()) ?? 0,
      payment_date: json['payment_date']?.toString() ?? '',
      form: json['form'] is int
          ? json['form'] as int
          : int.tryParse(json['form'].toString()) ?? 0,
      status: json['status'] is int
          ? json['status'] as int
          : int.tryParse(json['status'].toString()) ?? 0,
      total_price: json['total_price'] != null
          ? double.tryParse(json['total_price'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_id '] = payment_id;
    data['appointment_id '] = appointment_id;
    data['payment_date'] = payment_date;
    data['form'] = form;
    data['status'] = status;
    data['total_price'] = total_price;

    return data;
  }
}
