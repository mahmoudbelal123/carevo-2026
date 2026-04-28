import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/auth_repository.dart';
import '../../../../shared/models/profile_model.dart';

// Current session user — streams in real-time
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// Derived: is the user logged in?
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authRepositoryProvider).isAuthenticated;
});

// Current user profile (loaded once after login)
final profileProvider = FutureProvider.autoDispose<ProfileModel?>((ref) async {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) return null;
  return ref.watch(authRepositoryProvider).fetchProfile(user.id);
});

// Auth actions notifier
class AuthNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signIn(
            email: email,
            password: password,
          ),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signUp(
            email: email,
            password: password,
            fullName: fullName,
            phone: phone,
          ),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signOut(),
    );
  }
}

final authNotifierProvider =
    AsyncNotifierProvider.autoDispose<AuthNotifier, void>(AuthNotifier.new);
