import 'package:dio/dio.dart';
import 'package:homies/data/models/home.dart';
import 'package:homies/data/models/user.dart';
import 'package:homies/utils/handle_request.dart';

class UserApi {
  final Dio dio;
  UserApi(this.dio);

  Future<User> getUser() async {
    return handleDioRequest(() async {
      final res = await dio.get('/user/me');
      return User.fromJson(res.data);
    });
  }

  Future<Home> getHome() async {
    return handleDioRequest(() async {
      final res = await dio.get('/user/me/house');
      return Home.fromJson(res.data);
    });
  }

  /* deprecated
  Future<Overview> getOverview() async {
    try {
      final res = await dio.get('/user/me/overview');
      return Overview.fromJson(res.data);
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
*/
}
