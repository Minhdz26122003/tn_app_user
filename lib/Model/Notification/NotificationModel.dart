class NotificationModel {
  int? noti_id;
  int? uid;
  String? title;
  String? body;
  int? status;
  String? time_created;

  NotificationModel(
      {this.noti_id,
      this.uid,
      this.title,
      this.body,
      this.status,
      this.time_created});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    noti_id = json['noti_id'];
    uid = json['uid'];
    title = json['title'];
    body = json['body'];
    status = json['status'];
    time_created = json['time_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['noti_id'] = noti_id;
    data['uid'] = uid;
    data['title'] = title;
    data['body'] = body;
    data['status'] = status;
    data['time_created'] = time_created;
    return data;
  }
}
