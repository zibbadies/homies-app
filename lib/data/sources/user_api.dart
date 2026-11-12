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
}
