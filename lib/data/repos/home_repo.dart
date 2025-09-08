import 'package:homies/data/models/home.dart';
import 'package:homies/data/sources/home_api.dart';

class HomeRepository {
  final HomeApi api;

  HomeRepository(this.api);

  Future<Invite> create(String name) async {
    final invite = await api.create(name);

    return invite;
  }

  Future<bool> join(Invite invite) async {
    final success = await api.join(invite);

    return success;
  }

  Future<InviteInfo> getInviteInfo(Invite invite) async {
    final inviteInfo = await api.getInviteInfo(invite);

    return inviteInfo;
  }
}
