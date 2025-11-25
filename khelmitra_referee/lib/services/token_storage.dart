import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _tokenKey = 'khel_token';
  static const _baseUrlKey = 'khel_base_url';

  final FlutterSecureStorage _storage;

  TokenStorage([FlutterSecureStorage? impl]) : _storage = impl ?? const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> readToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> saveBaseUrl(String url) async {
    await _storage.write(key: _baseUrlKey, value: url);
  }

  Future<String?> readBaseUrl() async {
    return await _storage.read(key: _baseUrlKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
