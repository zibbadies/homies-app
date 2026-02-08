import 'package:dio/dio.dart';
import 'package:homies/data/models/error.dart';
import 'package:homies/data/models/home.dart';
import 'package:homies/utils/handle_request.dart';

class HomeApi {
  final Dio dio;
  HomeApi(this.dio);

  Future<Invite> create(String name) async {
    return handleDioRequest(() async {
      final res = await dio.post('/house/create', data: {'name': name});
      return Invite.fromJson(res.data);
    });
  }

  Future<InviteInfo> getInviteInfo(Invite invite) async {
    return handleDioRequest(() async {
      final res = await dio.get('/house/${invite.code}');
      return InviteInfo.fromJson(res.data);
    });
  }

  Future<bool> join(Invite invite) async {
    return handleDioRequest(() async {
      await dio.post('/house/${invite.code}');
      return true;
    });
  }

  Future<bool> leave() async {
    return handleDioRequest(() async {
      await dio.delete('/user/me/house');
      return true;
    });
  }
}
