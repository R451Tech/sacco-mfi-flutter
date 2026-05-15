import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../../../models/user.dart';
import '../repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(apiClientProvider),
    ref.watch(secureStorageProvider),
  );
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AsyncValue.data(null)) {
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    state = const AsyncValue.loading();
    final repo = _ref.read(authRepositoryProvider);
    final hasToken = await repo.hasToken();
    if (hasToken) {
      final user = await repo.getSavedUser();
      state = user != null ? AsyncValue.data(user) : const AsyncValue.data(null);
    } else {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final repo = _ref.read(authRepositoryProvider);
    final result = await repo.login(email, password);
    result.when(
      success: (user) => state = AsyncValue.data(user),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final repo = _ref.read(authRepositoryProvider);
    final result = await repo.register(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
    );
    result.when(
      success: (user) => state = AsyncValue.data(user),
      failure: (message, code, data) => state = AsyncValue.error(message, StackTrace.current),
    );
  }

  Future<void> logout() async {
    final repo = _ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AsyncValue.data(null);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref);
});
