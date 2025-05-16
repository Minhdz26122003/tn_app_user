class AccessoryModel {
  int? accessory_id;
  String? accessory_name;
  int? quantity;
  double? price;
  String? supplier;
  String? description;
  double? sub_total;

  AccessoryModel({
    this.accessory_id,
    this.accessory_name,
    this.supplier,
    this.quantity,
    this.price,
    this.description,
    this.sub_total,
  });

  factory AccessoryModel.fromJson(Map<String, dynamic> json) {
    return AccessoryModel(
      accessory_id: json['accessory_id'] is int
          ? json['accessory_id'] as int
          : int.tryParse(json['accessory_id'].toString()) ?? 0,
      accessory_name: json['accessory_name']?.toString() ?? '',
      quantity: json['quantity'] is int
          ? json['quantity'] as int
          : int.tryParse(json['quantity'].toString()) ?? 0,
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      supplier: json['supplier']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      sub_total: json['sub_total'] != null
          ? double.tryParse(json['sub_total'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessory_id'] = accessory_id;
    data['accessory_name'] = accessory_name;
    data['quantity'] = quantity;
    data['price'] = price;
    data['description'] = description;
    data['supplier'] = supplier;
    data['sub_total'] = sub_total;
    // data['sub_total'] = supplier;
    return data;
  }
}
