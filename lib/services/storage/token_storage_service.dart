import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A service class for securely handling the user's authentication token.
class TokenStorageService {
  // Create a private instance of FlutterSecureStorage
  final _storage = const FlutterSecureStorage();

  // A private key to identify the token in storage
  static const _tokenKey = 'auth_token';

  /// Saves the authentication token to secure storage.
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Retrieves the authentication token from secure storage.
  /// Returns null if no token is found.
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Deletes the authentication token from secure storage (for logout).
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}