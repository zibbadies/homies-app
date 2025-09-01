class User {
  final String name;
  final String avatar;
  final String house;

  User({required this.name, required this.avatar, required this.house});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      avatar: json['avatar'],
      house: json['house'],
    );
  }
}
