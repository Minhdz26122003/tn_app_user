class NotificationModel {
  String? uuid;
  String? title;
  String? body;
  String? macNumber;
  String? teamUuid;
  int? status;
  String? timeCreated;

  NotificationModel(
      {this.uuid,
      this.title,
      this.body,
      this.macNumber,
      this.teamUuid,
      this.status,
      this.timeCreated});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    title = json['title'];
    body = json['body'];
    macNumber = json['macNumber'];
    teamUuid = json['teamUuid'];
    status = json['status'];
    timeCreated = json['timeCreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['title'] = title;
    data['body'] = body;
    data['macNumber'] = macNumber;
    data['teamUuid'] = teamUuid;
    data['status'] = status;
    data['timeCreated'] = timeCreated;
    return data;
  }
}
