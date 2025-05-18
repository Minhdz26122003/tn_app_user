class TypeServiceModel {
  int? type_id;
  String? type_name;
  List<Service>? services;

  TypeServiceModel({
    this.type_id,
    this.type_name,
    this.services,
  });

  factory TypeServiceModel.fromJson(Map<String, dynamic> json) {
    List<Service>? services;
    if (json['services'] != null) {
      services = <Service>[];
      json['services'].forEach((v) {
        services!.add(Service.fromJson(v));
      });
    }
    return TypeServiceModel(
      // json['id'] hoặc json['service_type_id'] parse giống trên
      type_id: json['type_id'] is int
          ? json['type_id'] as int
          : int.tryParse(json['type_id'].toString()) ?? 0,

      // Tên kiểu String
      type_name: json['type_name']?.toString() ?? '',
      services: services,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type_id'] = type_id;
    data['type_name'] = type_name;
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Service {
  int? service_id;
  String? service_name;
  int? type_id;
  String? description;
  String? service_img;
  double? price;
  String? time;

  Service(
      {this.service_id,
      this.service_name,
      this.type_id,
      this.description,
      this.service_img,
      this.price,
      this.time});
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      service_id: json['service_id'] is int
          ? json['service_id'] as int
          : int.tryParse(json['service_id'].toString()) ?? 0,
      service_name: json['service_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      type_id: json['type_id'] is int
          ? json['type_id'] as int
          : int.tryParse(json['type_id'].toString()) ?? 0,
      service_img: json['service_img']?.toString() ?? '',
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
    data['type_id'] = type_id;
    data['description'] = description;
    data['service_img'] = service_img;
    data['price'] = price;
    data['time'] = time;

    return data;
  }
}
