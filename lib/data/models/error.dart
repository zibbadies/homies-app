class ErrorWithCode {
  final String message;
  final String code;

  const ErrorWithCode({required this.message, required this.code});

  factory ErrorWithCode.fromJson(Map<String, dynamic> json) {
    return ErrorWithCode(
      message: json['error']['message'],
      code: json['error']['code'],
    );
  }
}
