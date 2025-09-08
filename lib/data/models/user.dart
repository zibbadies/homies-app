import 'package:homies/data/models/avatar.dart';

class User {
  final String uid;
  final String name;
  final Avatar avatar;

  const User({required this.uid, required this.name, required this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(uid: json['uid'], name: json['name'], avatar: Avatar.fromJson(json['avatar']));
  }
}
