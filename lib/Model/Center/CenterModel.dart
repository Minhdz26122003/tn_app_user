class CenterModel {
  String? gara_id;
  String? gara_name;
  String? gara_address;
  String? phone;
  String? email;
  String? gara_img;
  String? x_location;
  String? y_location;

  CenterModel(
      {this.gara_id,
      this.gara_name,
      this.gara_address,
      this.phone,
      this.email,
      this.gara_img,
      this.x_location,
      this.y_location});

  CenterModel.fromJson(Map<String, dynamic> json) {
    gara_id = json['gara_id'];
    gara_name = json['gara_name'];
    gara_address = json['gara_address'];
    phone = json['phone'];
    email = json['email'];
    gara_img = json['gara_img'];
    x_location = json['x_location'];
    y_location = json['y_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gara_id'] = gara_id;
    data['gara_name'] = gara_name;
    data['gara_address'] = gara_address;
    data['phone'] = phone;
    data['email'] = email;
    data['gara_img'] = gara_img;
    data['x_location'] = x_location;
    data['y_location'] = y_location;
    return data;
  }
}
