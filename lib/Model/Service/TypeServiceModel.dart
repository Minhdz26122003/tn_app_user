class TypeServiceModel {
  String? type_id;
  String? type_name;
  List<Service>? services;

  TypeServiceModel({
    this.type_id,
    this.type_name,
    this.services,
  });

  TypeServiceModel.fromJson(Map<String, dynamic> json) {
    type_id = json['type_id'];
    type_name = json['type_name'];
    if (json['services'] != null) {
      services = <Service>[];
      json['services'].forEach((v) {
        services!.add(Service.fromJson(v));
      });
    }
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
  String? service_id;
  String? service_name;
  String? type_id;
  String? description;
  String? service_img;
  String? price;
  String? time;

  Service(
      {this.service_id,
      this.service_name,
      this.type_id,
      this.description,
      this.service_img,
      this.price,
      this.time});

  Service.fromJson(Map<String, dynamic> json) {
    service_id = json['service_id'];
    service_name = json['service_name'];
    type_id = json['type_id'];
    description = json['description'];
    service_img = json['service_img'];
    price = json['price'];
    time = json['time'];
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
