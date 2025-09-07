import 'package:dio/dio.dart';
import 'package:homies/data/models/home.dart';

class HomeApi {
  final Dio dio;
  HomeApi(this.dio);

  Future<Invite> create(String name) async {
    try {
      final res = await dio.post('/house/create', data: {'name': name});
      return Invite.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        final errorMessage = errorData['error'] ?? 'Creation failed';
        throw Exception(errorMessage);
      }
      throw Exception('Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<InviteInfo> getInviteInfo(String invite) async {
    try {
      final res = await dio.get('/house/$invite');
      return InviteInfo.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        final errorMessage =
            errorData['error'] ?? 'An unexpected error occurred';
        throw Exception(errorMessage);
      }
      throw Exception('Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<bool> join(String invite) async {
    try {
      await dio.post('/house/$invite');
      return true;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        final errorMessage = errorData['error'] ?? 'Joining home has failed';
        throw Exception(errorMessage);
      }
      throw Exception('Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }
}
