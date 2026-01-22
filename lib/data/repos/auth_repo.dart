import 'package:homies/data/models/auth.dart';
import 'package:homies/data/sources/auth_api.dart';
import 'package:homies/services/storage_service.dart';

class AuthRepository {
  final AuthApi api;
  final SecureStorageService storage;

  AuthRepository(this.api, this.storage);

  Future<Token> register(String name, String password) async {
    final token = await api.register(name, password);
    await storage.saveToken(token.value);

    return token;
  }

  Future<Token> login(String name, String password) async {
    final token = await api.login(name, password);
    await storage.saveToken(token.value);

    return token;
  }

  Future<void> logout() async {
    await storage.deleteToken();
  }

  Future<Token> getToken() async {
    return storage.getToken();
  }
}
