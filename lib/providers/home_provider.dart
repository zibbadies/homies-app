import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/error.dart';
import 'package:homies/data/models/home.dart';
import 'package:homies/data/repos/home_repo.dart';
import 'package:homies/data/sources/home_api.dart';
import 'package:homies/providers/dio_provider.dart';
import 'package:homies/providers/user_provider.dart';

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

class HomeStateNotifier extends Notifier<bool?> {
  @override
  bool? build() {
    // Watch overviewProvider and derive home state from it
    final overviewState = ref.read(overviewProvider);
    return overviewState.when(
      data: (overview) => true,
      error: (e, __) {
        if (e is ErrorWithCode) {
          return e.code != "user_not_in_house";
        }
        return true;
      },
      loading: () => null,
    );
  }

  // Manual override if needed (e.g., after creating home but before API refresh)
  void setHasHome(bool hasHome) {
    state = hasHome;
  }

  void reset() {
    state = null;
  }
}

final homeStateProvider = NotifierProvider<HomeStateNotifier, bool?>(
  HomeStateNotifier.new,
);
