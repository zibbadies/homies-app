import 'package:dio/dio.dart';
import 'package:homies/data/models/error.dart';
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
        throw ErrorWithCode.fromJson(errorData);
      }
      throw ErrorWithCode(
        code: "internal_error",
        message: 'Network error occurred',
      );
    } catch (e) {
      throw ErrorWithCode(
        code: "internal_error",
        message: 'An unexpected error occured',
      );
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
        throw ErrorWithCode.fromJson(errorData);
      }
      throw ErrorWithCode(
        code: "internal_error",
        message: 'Network error occurred',
      );
    } catch (e) {
      throw ErrorWithCode(
        code: "internal_error",
        message: 'An unexpected error occured',
      );
    }
  }
}
