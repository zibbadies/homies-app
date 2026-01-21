import 'package:homies/data/models/lists.dart';
import 'package:homies/data/models/user.dart';
import 'package:homies/data/models/home.dart';

class Overview {
  final User user;
  final Home home;
  final List items; // TODO

  const Overview({required this.user, required this.home, required this.items});

  factory Overview.fromJson(Map<String, dynamic> json) {
    return Overview(
      user: User.fromJson(json['user']),
      home: Home.fromJson(json['house']),
      items: (json['items'] as List).map((e) => Item.fromJson(e)).toList(), // TODO: i don't really fking know if it returns items or lists
    );
  }
}
