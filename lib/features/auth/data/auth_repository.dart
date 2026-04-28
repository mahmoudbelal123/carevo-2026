import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../../core/api/supabase_client.dart';
import '../../../core/utils/error_handler.dart';
import '../../../shared/models/profile_model.dart';

class AuthRepository {
  const AuthRepository();

  User? get currentUser => supabase.auth.currentUser;
  Session? get currentSession => supabase.auth.currentSession;
  bool get isAuthenticated => currentUser != null;

  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;

  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      final user = response.user;
      if (user == null) throw const AuthException('Sign in failed.');
      return user;
    } on Object catch (e) {
      throw mapSupabaseError(e);
    }
  }

  Future<User> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'full_name': fullName, 'phone': phone},
      );
      final user = response.user;
      if (user == null) throw const AuthException('Sign up failed.');

      // Create profile row
      await supabase.from('profiles').upsert({
        'id': user.id,
        'full_name': fullName,
        'phone': phone,
        'role': 'customer',
      });

      return user;
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw mapSupabaseError(e);
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } on Object catch (e) {
      throw mapSupabaseError(e);
    }
  }

  Future<ProfileModel?> fetchProfile(String userId) async {
    try {
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (data == null) return null;
      return ProfileModel.fromJson(data);
    } on Object catch (e) {
      throw mapSupabaseError(e);
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (_) => const AuthRepository(),
);
