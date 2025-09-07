import 'package:homies/data/models/avatar.dart';
import 'package:homies/data/models/user.dart';

class Account extends User {
  // aggiugni cose che sono solamente per l'account

  const Account({required super.uid, required super.name, required super.avatar});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      uid: json['uid'],
      name: json['name'],
      avatar: Avatar.fromJson(json['avatar']),
    );
  }
}
