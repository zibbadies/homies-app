class Token {
  final String value;

  const Token({required this.value});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(value: json['token']);
  }
}

class AuthState {
  final bool isAuthenticated;
  final Token? token;

  const AuthState({this.isAuthenticated = false, this.token});
}
