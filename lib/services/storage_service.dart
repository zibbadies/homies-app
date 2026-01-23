import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:homies/data/models/auth.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<Token?> getToken() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) return null;

    return Token(value: token);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
