class UserModel {
  int? uid;
  String? username;
  String? fullname;
  String? birthday;
  String? email;
  String? address;
  String? phonenum;
  int? gender;
  String? avatar;
  int? status;

  UserModel(
      {this.uid,
      this.username,
      this.fullname,
      this.birthday,
      this.email,
      this.address,
      this.phonenum,
      this.gender,
      this.avatar,
      this.status});

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    username = json['username'];
    fullname = json['fullname'];
    birthday = json['birthday'];
    email = json['email'];
    address = json['address'];
    phonenum = json['phonenum'];
    gender = json['gender'];
    avatar = json['avatar'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['username'] = username;
    data['fullname'] = fullname;
    data['birthday'] = birthday;
    data['email'] = email;
    data['address'] = address;
    data['phonenum'] = phonenum;
    data['gender'] = gender;
    data['avatar'] = avatar;
    data['status'] = status;
    return data;
  }
}

// class Pagination {
//   int? totalCount;
//   int? totalPage;

//   Pagination({this.totalCount, this.totalPage});

//   Pagination.fromJson(Map<String, dynamic> json) {
//     totalCount = json['totalCount'];
//     totalPage = json['totalPage'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['totalCount'] = totalCount;
//     data['totalPage'] = totalPage;
//     return data;
//   }
// }

// class Error {
//   int? code;
//   String? message;

//   Error({this.code, this.message});

//   Error.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['code'] = code;
//     data['message'] = message;
//     return data;
//   }
// }
