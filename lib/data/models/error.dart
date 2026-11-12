class ErrorWithCode implements Exception {
  final String message;
  final String code;

  const ErrorWithCode({required this.message, required this.code});

  factory ErrorWithCode.fromJson(Map<String, dynamic> json) {
    final error = json['error'];
    if (error is Map && error['message'] is String && error['code'] is String) {
      return ErrorWithCode(message: error['message'], code: error['code']);
    }
    return const ErrorWithCode(
      code: 'internal_error',
      message: 'Unknown server error',
    );
  }

  @override
  String toString() => 'ErrorWithCode($code): $message';
}
