import 'package:homies/data/models/user.dart';
import 'package:homies/data/models/home.dart';

class Overview {
  final User user;
  final Home home;
  final List items; // TODO

  Overview({required this.user, required this.home, required this.items});

  factory Overview.fromJson(Map<String, dynamic> json) {
    return Overview(
      user: User.fromJson(json['user']),
      home: Home.fromJson(json['house']),
      items: json['items'],
    );
  }
}
