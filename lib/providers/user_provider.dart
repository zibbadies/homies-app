import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/overview.dart';
import 'package:homies/data/repos/user_repo.dart';
import 'package:homies/data/sources/user_api.dart';
import 'package:homies/providers/dio_provider.dart';

final userApiProvider = Provider((ref) => UserApi(ref.watch(dioProvider)));
final userRepositoryProvider = Provider(
  (ref) => UserRepository(ref.watch(userApiProvider)),
);

final overviewProvider = FutureProvider<Overview>(
  (ref) => ref.read(userRepositoryProvider).getOverview(),
);
