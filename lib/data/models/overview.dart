import 'package:homies/data/models/user.dart';
import 'package:homies/data/models/home.dart';

class Overview {
  final User user;
  final InviteInfo home;
  final List items; // TODO

  const Overview({required this.user, required this.home, required this.items});

  factory Overview.fromJson(Map<String, dynamic> json) {
    return Overview(
      user: User.fromJson(json['user']),
      home: InviteInfo.fromJson(json['house']),
      items: json['items'],
    );
  }
}
