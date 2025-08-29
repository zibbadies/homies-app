import 'package:homies/data/models/token.dart';
import 'package:homies/data/models/user.dart';
import 'package:homies/data/sources/auth_api.dart';
import 'package:homies/services/storage.dart';

class AuthRepository {
  final AuthApi api;
  final SecureStorageService storage;

  AuthRepository(this.api, this.storage);

  Future<Token> register(String name, String password) async {
    final token = await api.register(name, password);
    await storage.saveToken(token.token);

    return token;
  }

  Future<User> login(String name, String password) async {
    final user = await api.login(name, password);
    await storage.saveToken(user.token);

    return user;
  }

  Future<void> logout() async {
    await storage.deleteToken();
  }
  
  Future<String?> getToken() async {
    return storage.getToken();
  }
}
