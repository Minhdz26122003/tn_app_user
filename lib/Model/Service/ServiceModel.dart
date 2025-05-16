class ServiceModel {
  int? service_id;
  String? service_name;
  int? type_id;
  String? description;
  String? service_img;
  double? price;
  String? time;

  ServiceModel(
      {this.service_id,
      this.service_name,
      this.type_id,
      this.description,
      this.service_img,
      this.price,
      this.time});

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    //print('ServiceModel raw json: $json'); // <--- add this
    return ServiceModel(
      // json['service_id'] có thể là int hoặc String, ta parse về int:
      service_id: json['service_id'] is int
          ? json['service_id'] as int
          : int.tryParse(json['service_id'].toString()) ?? 0,

      service_name: json['service_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      type_id: json['type_id'] is int
          ? json['type_id'] as int
          : int.tryParse(json['type_id'].toString()) ?? 0,
      service_img: json['service_img']?.toString() ?? '',
      // Giá có thể là num hoặc String, ép về double:
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
    data['type_id'] = type_id;
    data['description'] = description;
    data['service_img'] = service_img;
    data['price'] = price;
    data['time'] = time;

    return data;
  }
}
