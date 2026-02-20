import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homies/data/models/auth.dart';
import 'package:homies/data/repos/auth_repo.dart';
import 'package:homies/data/sources/auth_api.dart';
import 'package:homies/providers/dio_provider.dart';
import 'package:homies/providers/lists_provider.dart';
import 'package:homies/providers/storage_provider.dart';
import 'package:homies/providers/user_provider.dart';

final authApiProvider = Provider((ref) => AuthApi(ref.watch(dioProvider)));
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    ref.watch(authApiProvider),
    ref.watch(secureStorageProvider),
  ),
);

class AuthNotifier extends AsyncNotifier<AuthState> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  Future<AuthState> build() async {
    final token = await _repo.getToken();

    if (token != null) {
      return AuthState(isAuthenticated: true, token: token);
    }

    return const AuthState();
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final token = await _repo.login(username, password);
      return AuthState(isAuthenticated: true, token: token);
    });
  }

  Future<void> register(String username, String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final token = await _repo.register(username, password);
      return AuthState(isAuthenticated: true, token: token);
    });
  }

  void reset() {
    ref.invalidate(userProvider);
    ref.invalidate(homeProvider);
    ref.invalidate(listsProvider);
    ref.invalidate(todoListProvider);
    
    state = const AsyncData(AuthState(isAuthenticated: false));
  }

  void logout() async {
    await _repo.logout();
    reset();
  }

  /*Future<void> refreshToken() async {
      state = await AsyncValue.guard(() async {
        final newToken = await _repo.refreshToken();
        return AuthState(isAuthenticated: true, token: newToken);
      });
  }*/
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
