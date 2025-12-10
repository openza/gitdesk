import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/token_repository.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, bool>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final tokenRepo = ref.read(tokenRepositoryProvider);
    final token = await tokenRepo.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<bool> login(String token) async {
    state = const AsyncValue.loading();

    final tokenRepo = ref.read(tokenRepositoryProvider);
    final isValid = await tokenRepo.validateToken(token);

    if (isValid) {
      await tokenRepo.saveToken(token);
      state = const AsyncValue.data(true);
      return true;
    } else {
      state = const AsyncValue.data(false);
      return false;
    }
  }

  Future<void> logout() async {
    final tokenRepo = ref.read(tokenRepositoryProvider);
    await tokenRepo.clearAll();
    state = const AsyncValue.data(false);
  }
}

// Provider to get current username
final currentUsernameProvider = FutureProvider<String?>((ref) async {
  final tokenRepo = ref.read(tokenRepositoryProvider);
  return await tokenRepo.getUsername();
});
