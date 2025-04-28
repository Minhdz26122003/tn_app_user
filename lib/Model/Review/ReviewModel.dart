class ReviewModel {
  String? review_id;
  int? uid;
  String? service_id;
  String? content;
  String? star;
  String? created_at;

  ReviewModel({
    this.review_id,
    this.uid,
    this.service_id,
    this.content,
    this.star,
    this.created_at,
  });

  ReviewModel.fromJson(Map<String, dynamic> json) {
    review_id = json['review_id'];
    uid = json['uid'];
    service_id = json['service_id'];
    content = json['content'];
    star = json['star'];
    created_at = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['review_id'] = review_id;
    data['uid'] = uid;
    data['service_id'] = service_id;
    data['content'] = content;
    data['star'] = star;
    data['created_at'] = created_at;

    return data;
  }
}
