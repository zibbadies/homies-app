import 'package:homies/data/models/user.dart';

class Home {
  final String name;
  final List<User> members;

  Home({required this.name, required this.members});

  factory Home.fromJson(Map<String, dynamic> json) {
    return Home(
      name: json['name'],
      members: (json['members'] as List<dynamic>)
          .map((memberJson) => User.fromJson(memberJson))
          .toList(),
    );
  }
}
