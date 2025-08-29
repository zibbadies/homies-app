import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/credentials.dart';
import 'package:homies/data/models/token.dart';
import 'package:homies/data/models/user.dart';
import 'package:homies/data/repos/auth_repo.dart';
import 'package:homies/data/sources/auth_api.dart';
import 'package:homies/providers/dio_provider.dart';
import 'package:homies/providers/storage_provider.dart';

final authApiProvider = Provider((ref) => AuthApi(ref.watch(dioProvider)));
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    ref.watch(authApiProvider),
    ref.watch(secureStorageProvider),
  ),
);

final loginProvider = FutureProvider.autoDispose.family<User, Credentials>((
  ref,
  credentials,
) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.login(credentials.name, credentials.password);
});

final registerProvider = FutureProvider.autoDispose.family<Token, Credentials>((
  ref,
  credentials,
) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.register(credentials.name, credentials.password);
});

final tokenProvider = FutureProvider<String?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.getToken();
});
