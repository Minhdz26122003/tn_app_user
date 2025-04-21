class CarModel {
  int? car_id;
  String? uid;
  String? license_plate;
  String? name;
  String? manufacturer;
  String? year_manufacture;

  CarModel({
    this.car_id,
    this.uid,
    this.license_plate,
    this.name,
    this.manufacturer,
    this.year_manufacture,
  });

  CarModel.fromJson(Map<String, dynamic> json) {
    car_id = json['car_id'];
    uid = json['uid'];
    license_plate = json['license_plate'];
    name = json['name'];
    manufacturer = json['manufacturer'];
    year_manufacture = json['year_manufacture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['car_id'] = car_id;
    data['uid'] = uid;
    data['license_plate'] = license_plate;
    data['name'] = name;
    data['manufacturer'] = manufacturer;
    data['year_manufacture'] = year_manufacture;

    return data;
  }
}
