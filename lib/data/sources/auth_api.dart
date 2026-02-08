import 'package:dio/dio.dart';
import 'package:homies/data/models/auth.dart';
import 'package:homies/utils/handle_request.dart';

class AuthApi {
  final Dio dio;
  AuthApi(this.dio);

  Future<Token> register(String name, String password) async {
    return handleDioRequest(() async {
      final res = await dio.post(
        '/auth/register',
        data: {'name': name, 'pwd': password},
      );
      return Token.fromJson(res.data);
    });
  }

  Future<Token> login(String name, String password) async {
    return handleDioRequest(() async {
      final res = await dio.post(
        '/auth/login',
        data: {'name': name, 'pwd': password},
      );
      return Token.fromJson(res.data);
    });
  }
}
