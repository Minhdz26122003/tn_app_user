class TypeServiceModel {
  String? type_id;
  String? type_name;

  TypeServiceModel({
    this.type_id,
    this.type_name,
  });

  TypeServiceModel.fromJson(Map<String, dynamic> json) {
    type_id = json['type_id'];
    type_name = json['type_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type_id'] = type_id;
    data['type_name'] = type_name;

    return data;
  }
}
