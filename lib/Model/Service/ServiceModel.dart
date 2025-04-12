class ServiceModel {
  String? service_id;
  String? service_name;
  String? type_id;
  String? description;
  String? service_img;
  String? pirce;
  String? time;

  ServiceModel(
      {this.service_id,
      this.service_name,
      this.type_id,
      this.description,
      this.service_img,
      this.pirce,
      this.time});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    service_id = json['service_id'];
    service_name = json['service_name'];
    type_id = json['type_id'];
    description = json['description'];
    service_img = json['service_img'];
    pirce = json['pirce'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = service_id;
    data['service_name'] = service_name;
    data['type_id'] = type_id;
    data['description'] = description;
    data['service_img'] = service_img;
    data['pirce'] = pirce;
    data['time'] = time;

    return data;
  }
}
