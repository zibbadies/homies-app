import 'package:dio/dio.dart';
import 'package:homies/data/models/overview.dart';

class UserApi {
  final Dio dio;
  UserApi(this.dio);

  Future<Overview> getOverview() async {
    try {
      final res = await dio.get('/user/me/overview');
      return Overview.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        final errorMessage =
            errorData['error'] ?? 'An unexpected error occurred';
        throw errorMessage;
      }
      throw 'Network error occurred';
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }
}
