class CarModel {
  String? car_id;
  String? uid;
  String? license_plate;
  String? color_car;
  String? manufacturer;
  String? year_manufacturer;

  CarModel({
    this.car_id,
    this.uid,
    this.license_plate,
    this.color_car,
    this.manufacturer,
    this.year_manufacturer,
  });

  CarModel.fromJson(Map<String, dynamic> json) {
    car_id = json['car_id'];
    uid = json['uid'];
    license_plate = json['license_plate'];
    color_car = json['color_car'];
    manufacturer = json['manufacturer'];
    year_manufacturer = json['year_manufacturer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['car_id'] = car_id;
    data['uid'] = uid;
    data['license_plate'] = license_plate;
    data['color_car'] = color_car;
    data['manufacturer'] = manufacturer;
    data['year_manufacturer'] = year_manufacturer;

    return data;
  }
}
