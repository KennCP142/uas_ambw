import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_ambw/models/user.dart' as my_models;
import 'package:uas_ambw/services/storage_service.dart';

class AuthService {
  final supabase = Supabase.instance.client;
  final StorageService _storageService = StorageService();

  // Sign up with email and password
  Future<my_models.User?> signUp(String email, String password, {String? name}) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (response.user != null) {
        final userData = {
          'id': response.user!.id,
          'email': email,
          'user_metadata': {'name': name},
        };
        return my_models.User.fromSupabase(userData);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<my_models.User?> signIn(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final userData = {
          'id': response.user!.id,
          'email': response.user!.email!,
          'user_metadata': response.user!.userMetadata,
        };

        final user = my_models.User.fromSupabase(userData);
        await _storageService.saveUser(user); // Save user to local storage
        return user;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      await _storageService.clearUser(); // Clear user from local storage
    } catch (e) {
      rethrow;
    }
  }

  // Get current user from Supabase
  Future<my_models.User?> getCurrentUser() async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser != null) {
        final userData = {
          'id': currentUser.id,
          'email': currentUser.email!,
          'user_metadata': currentUser.userMetadata,
        };
        return my_models.User.fromSupabase(userData);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Get current user from local storage (for persistence)
  Future<my_models.User?> getCurrentUserFromStorage() async {
    return await _storageService.getUser();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }
}
