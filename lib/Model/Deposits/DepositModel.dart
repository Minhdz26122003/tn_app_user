// File: Model/Payment/DepositModel.dart

class DepositModel {
  int? deposit_id;
  int? appointment_id;
  double? amount;
  int? status; // 0: Pending, 1: Paid, 2: Failed
  String? created_at;
  String? deposit_date;

  DepositModel({
    this.deposit_id,
    this.appointment_id,
    this.amount,
    this.status,
    this.created_at,
    this.deposit_date,
  });

  factory DepositModel.fromJson(Map<String, dynamic> json) {
    return DepositModel(
      deposit_id: json['deposit_id'] is int
          ? json['deposit_id'] as int
          : int.tryParse(json['deposit_id'].toString()) ?? 0,
      appointment_id: json['appointment_id'] is int
          ? json['appointment_id'] as int
          : int.tryParse(json['appointment_id'].toString()) ?? 0,
      amount: json['amount'] != null
          ? double.tryParse(json['amount'].toString())
          : null,
      status: json['status'] is int
          ? json['status'] as int
          : int.tryParse(json['status'].toString()) ?? 0,
      created_at: json['created_at']?.toString(),
      deposit_date: json['deposit_date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deposit_id'] = deposit_id;
    data['appointment_id'] = appointment_id;
    data['amount'] = amount;
    data['status'] = status;
    data['created_at'] = created_at;
    data['deposit_date'] = deposit_date;
    return data;
  }
}
