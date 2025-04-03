class AccountModel {
  int? uid;
  String? fullname;
  String? email;
  String? phonenum;
  String? birthday;
  String? username;
  String? timeCreated;
  String? avatar;
  int? status;
  int? gender;
  String? address;

  AccountModel(
      {this.uid,
      this.fullname,
      this.birthday,
      this.email,
      this.phonenum,
      this.username,
      this.timeCreated,
      this.avatar,
      this.status,
      this.gender,
      this.address});

  AccountModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    fullname = json['fullname'];
    email = json['email'];
    phonenum = json['phonenum'];
    username = json['userName'];
    timeCreated = json['timeCreated'];
    avatar = json['avatar'];
    birthday = json['birthday'];
    status = json['status'];
    gender = json['gender'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['fullname'] = fullname;
    data['email'] = email;
    data['phonenum'] = phonenum;
    data['userName'] = username;
    data['timeCreated'] = timeCreated;
    data['avatar'] = avatar;
    data['birthday'] = birthday;
    data['status'] = status;
    data['gender'] = gender;
    data['address'] = address;
    return data;
  }
}
