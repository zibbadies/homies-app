import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:homies/data/models/auth.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<Token> getToken() async {
    return Token(value: _storage.read(key: 'auth_token'));
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
