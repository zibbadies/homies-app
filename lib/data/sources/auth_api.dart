import 'package:dio/dio.dart';
import 'package:homies/data/models/token.dart';

class AuthApi {
  final Dio dio;
  AuthApi(this.dio);

  Future<Token> register(String name, String password) async {
    try {
      final res = await dio.post(
        '/auth/register',
        data: {'name': name, 'pwd': password},
      );
      return Token.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        final errorMessage = errorData['error'] ?? 'Registration failed';
        throw Exception(errorMessage);
      }
      throw Exception('Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Token> login(String name, String password) async {
    try {
      final res = await dio.post(
        '/auth/login',
        data: {'name': name, 'pwd': password},
      );
      return Token.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        final errorMessage = errorData['error'] ?? 'Login failed';
        throw Exception(errorMessage);
      }
      throw Exception('Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }
}
