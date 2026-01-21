import 'package:dio/dio.dart';
import 'package:homies/data/models/error.dart';
import 'package:homies/data/models/home.dart';

class HomeApi {
  final Dio dio;
  HomeApi(this.dio);

  Future<Invite> create(String name) async {
    try {
      final res = await dio.post('/house/create', data: {'name': name});
      return Invite.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is! String) {
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

  Future<InviteInfo> getInviteInfo(Invite invite) async {
    try {
      final res = await dio.get('/house/${invite.code}');
      return InviteInfo.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is! String) {
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

  Future<bool> join(Invite invite) async {
    try {
      await dio.post('/house/${invite.code}');
      return true;
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is! String) {
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

  Future<bool> leave() async {
    try {
      await dio.delete('/user/me/house');
      return true;
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is! String) {
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
