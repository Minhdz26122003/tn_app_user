class AccessaryModel {
  int? accessary_id;
  String? accessary_name;
  String? quanity;
  String? price;
  String? supplier;
  String? description;

  AccessaryModel({
    this.accessary_id,
    this.accessary_name,
    this.supplier,
    this.quanity,
    this.price,
    this.description,
  });

  AccessaryModel.fromJson(Map<String, dynamic> json) {
    accessary_id = json['accessary_id'];
    accessary_name = json['accessary_name'];
    quanity = json['quanity'];
    price = json['	price'];
    description = json['description'];
    supplier = json['supplier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessary_id'] = accessary_id;
    data['accessary_name'] = accessary_name;
    data['quanity'] = quanity;
    data['	price'] = price;
    data['description'] = description;
    data['supplier'] = supplier;
    return data;
  }
}
