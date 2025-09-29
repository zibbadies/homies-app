import 'package:homies/data/models/overview.dart';
import 'package:homies/data/sources/user_api.dart';

class UserRepository {
  final UserApi api;

  UserRepository(this.api);

  Future<Overview> getOverview() async {
    final overview = await api.getOverview();
    print("daAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAai");

    return overview;
  }
}
