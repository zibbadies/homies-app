import 'package:homies/data/models/user.dart';

class Home {
  final String name;
  final String invite;
  final List<User> members;

  const Home({required this.name, required this.invite, required this.members});

  factory Home.fromJson(Map<String, dynamic> json) {
    return Home(
      name: json['name'],
      invite: json['invite'],
      members: (json['members'] as List<dynamic>)
          .map((memberJson) => User.fromJson(memberJson))
          .toList(),
    );
  }
}

class Invite {
  final String code;
  
  const Invite({required this.code});

  factory Invite.fromJson(Map<String, dynamic> json) {
    return Invite(code: json['invite']);
  }
}

class InviteInfo {
  final String name;
  final String invite;
  final List<User> members;

  const InviteInfo({required this.name, required this.invite, required this.members});

  factory InviteInfo.fromJson(Map<String, dynamic> json) {
    return InviteInfo(
      name: json['name'],
      invite: json['invite'],
      members: (json['members'] as List<dynamic>)
          .map((memberJson) => User.fromJson(memberJson))
          .toList(),
    );
  }
}
