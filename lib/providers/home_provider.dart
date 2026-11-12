import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/home.dart';
import 'package:homies/data/repos/home_repo.dart';
import 'package:homies/data/sources/home_api.dart';
import 'package:homies/providers/dio_provider.dart';

final homeApiProvider = Provider((ref) => HomeApi(ref.watch(dioProvider)));
final homeRepositoryProvider = Provider(
  (ref) => HomeRepository(ref.watch(homeApiProvider)),
);

/// Query: info about the home an invite code points to.
/// autoDispose so family instances don't pile up per entered code.
final inviteInfoProvider = FutureProvider.autoDispose.family<Home, Invite>(
  (ref, invite) => ref.read(homeRepositoryProvider).getInviteInfo(invite),
);

/// Mutation: create a home. `null` means "not requested yet".
class CreateHomeNotifier extends AsyncNotifier<Invite?> {
  @override
  Future<Invite?> build() async => null;

  Future<void> create(String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(homeRepositoryProvider).create(name),
    );
  }
}

final createHomeProvider = AsyncNotifierProvider<CreateHomeNotifier, Invite?>(
  CreateHomeNotifier.new,
);

/// Mutation: join the home behind an invite code.
class JoinHomeNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async => false;

  Future<void> join(Invite invite) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(homeRepositoryProvider).join(invite),
    );
  }
}

final joinHomeProvider = AsyncNotifierProvider<JoinHomeNotifier, bool>(
  JoinHomeNotifier.new,
);

/// Mutation: leave the current home.
class LeaveHomeNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async => false;

  Future<void> leave() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(homeRepositoryProvider).leave(),
    );
  }
}

final leaveHomeProvider = AsyncNotifierProvider<LeaveHomeNotifier, bool>(
  LeaveHomeNotifier.new,
);
