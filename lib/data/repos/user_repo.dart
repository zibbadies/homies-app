import 'package:homies/data/models/overview.dart';
import 'package:homies/data/models/user.dart';
import 'package:homies/data/sources/user_api.dart';

class UserRepository {
  final UserApi api;

  UserRepository(this.api);
  
  Future<User> getUser() async {
    final user = await api.getUser();

    return user;
  }

  Future<Overview> getOverview() async {
    final overview = await api.getOverview();

    return overview;
  }
}
