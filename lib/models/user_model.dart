class UserModel {
  UserModel({
    String? id,
    String? userID,
    String? name,
    String? email,
  }) {
    _id = id;
    _userID = userID;
    _name = name;
    _email = email;
  }

  UserModel.fromJson(dynamic json) {
    _id = json['id'];
    _userID = json['user_id'];
    _name = json['name'];
    _email = json['email'];
  }

  String? _id;
  String? _userID;
  String? _name;
  String? _email;

  String get id => _id ?? "";

  String get userID => _userID ?? "";

  String get name => _name ?? "";

  String get email => _email ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_id != null) map['id'] = _id;
    if (_userID != null) map['user_id'] = _userID;
    if (_name != null) map['name'] = _name;
    if (_email != null) map['email'] = _email;
    return map;
  }
}
