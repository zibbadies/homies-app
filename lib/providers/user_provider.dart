import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/home.dart';
import 'package:homies/data/models/user.dart';
import 'package:homies/data/repos/user_repo.dart';
import 'package:homies/data/sources/user_api.dart';
import 'package:homies/providers/dio_provider.dart';

final userApiProvider = Provider((ref) => UserApi(ref.watch(dioProvider)));
final userRepositoryProvider = Provider(
  (ref) => UserRepository(ref.watch(userApiProvider)),
);

final userProvider = FutureProvider<User>(
  (ref) => ref.read(userRepositoryProvider).getUser(),
);

/// Tracks when [homeProvider] last fetched successfully, so pages can skip
/// redundant refetches while the cached data is still fresh.
class HomeFreshness {
  DateTime? fetchedAt;
}

final homeFreshnessProvider = Provider<HomeFreshness>(
  (ref) => HomeFreshness(),
);

final homeProvider = FutureProvider<Home>((ref) async {
  // Capture the holder before the await so `ref` is never touched after the
  // request completes (the provider may have been invalidated mid-flight).
  final freshness = ref.read(homeFreshnessProvider);
  final home = await ref.read(userRepositoryProvider).getHome();
  freshness.fetchedAt = DateTime.now();
  return home;
});
