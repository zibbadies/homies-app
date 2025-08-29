import 'package:dio/dio.dart';
import 'package:homies/data/models/token.dart';
import 'package:homies/data/models/user.dart';

class AuthApi {
  final Dio dio;
  AuthApi(this.dio);

  Future<Token> register(String name, String password) async {
    final res = await dio.post(
      '/register',
      data: {
        'name': name,
        'pwd': password,
      },
    );
    return Token.fromJson(res.data);
  }

  Future<User> login(String name, String password) async {
    final res = await dio.post(
      '/login',
      data: {
        'name': name,
        'pwd': password,
      },
    );
    return User.fromJson(res.data);
  }
}
