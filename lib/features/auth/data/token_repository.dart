import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:github/github.dart';

import '../../../core/constants/app_constants.dart';

final tokenRepositoryProvider = Provider<TokenRepository>((ref) {
  return TokenRepository();
});

class TokenRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.tokenStorageKey);
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.tokenStorageKey, value: token);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: AppConstants.tokenStorageKey);
  }

  Future<String?> getUsername() async {
    return await _storage.read(key: AppConstants.usernameStorageKey);
  }

  Future<void> saveUsername(String username) async {
    await _storage.write(key: AppConstants.usernameStorageKey, value: username);
  }

  Future<void> deleteUsername() async {
    await _storage.delete(key: AppConstants.usernameStorageKey);
  }

  Future<bool> validateToken(String token) async {
    try {
      final github = GitHub(auth: Authentication.withToken(token));
      final user = await github.users.getCurrentUser();
      if (user.login != null) {
        await saveUsername(user.login!);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearAll() async {
    await deleteToken();
    await deleteUsername();
  }
}
