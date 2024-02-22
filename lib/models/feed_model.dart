class FeedModel {
  FeedModel({
    String? id,
    String? message,
    List<String>? images,
    String? userId,
    String? userName,
    List<Comments>? comments,
    num? createdAt,
  }) {
    _id = id;
    _message = message;
    _images = images;
    _userId = userId;
    _userName = userName;
    _comments = comments;
    _createdAt = createdAt;
  }

  FeedModel.fromJson(dynamic json) {
    _id = json['id'];
    _message = json['message'];
    _images = json['images'] != null ? json['images'].cast<String>() : [];
    _userId = json['user_id'];
    _userName = json['user_name'];
    if (json['comments'] != null) {
      _comments = [];
      json['comments'].forEach((v) {
        _comments?.add(Comments.fromJson(v));
      });
    }
    _createdAt = json['created_at'];
  }

  String? _id;
  String? _message;
  List<String>? _images;
  String? _userId;
  String? _userName;
  List<Comments>? _comments;
  num? _createdAt;

  String get id => _id ?? "";
  String get message => _message ?? "";

  List<String> get images => _images ?? [];

  String get userId => _userId ?? "";

  String get userName => _userName ?? "";

  List<Comments> get comments => _comments ?? [];

  num get createdAt => _createdAt ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_id != null) map['id'] = _id;
    if (_message != null) map['message'] = _message;
    if (_images != null) map['images'] = _images;
    if (_userId != null) map['user_id'] = _userId;
    if (_userName != null) map['user_name'] = _userName;
    if (_comments != null) {
      map['comments'] = _comments?.map((v) => v.toJson()).toList();
    }
    if (_createdAt != null) map['created_at'] = _createdAt;
    return map;
  }
}

class Comments {
  Comments({
    String? userId,
    String? userName,
    String? comment,
    num? createdAt,
  }) {
    _userId = userId;
    _userName = userName;
    _comment = comment;
    _createdAt = createdAt;
  }

  Comments.fromJson(dynamic json) {
    _userId = json['user_id'];
    _userName = json['user_name'];
    _comment = json['comment'];
    _createdAt = json['created_at'];
  }

  String? _userId;
  String? _userName;
  String? _comment;
  num? _createdAt;

  String get userId => _userId ?? "";

  String get userName => _userName ?? "";

  String get comment => _comment ?? "";

  num get createdAt => _createdAt ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_userId != null) map['user_id'] = _userId;
    if (_userName != null) map['user_name'] = _userName;
    if (_comment != null) map['comment'] = _comment;
    if (_createdAt != null) map['created_at'] = _createdAt;
    return map;
  }
}
