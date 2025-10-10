import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/home.dart';
import 'package:homies/data/repos/home_repo.dart';
import 'package:homies/data/sources/home_api.dart';
import 'package:homies/providers/dio_provider.dart';

final homeApiProvider = Provider((ref) => HomeApi(ref.watch(dioProvider)));
final homeRepositoryProvider = Provider(
  (ref) => HomeRepository(ref.watch(homeApiProvider)),
);

final createHomeProvider = FutureProvider.family<Invite, String>(
  (ref, name) => ref.read(homeRepositoryProvider).create(name),
);

final inviteInfoProvider = FutureProvider.family<InviteInfo, Invite>(
  (ref, invite) => ref.read(homeRepositoryProvider).getInviteInfo(invite),
);

final joinHomeProvider = FutureProvider.family<bool, Invite>(
  (ref, invite) => ref.read(homeRepositoryProvider).join(invite),
);

