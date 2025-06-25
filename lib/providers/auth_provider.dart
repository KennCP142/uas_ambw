import 'package:flutter/foundation.dart';
import 'package:uas_ambw/models/user.dart';
import 'package:uas_ambw/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  // Initialize - check if user is already logged in
  Future<void> initialize() async {
    _setLoading(true);
    try {
      // First try to get from Supabase session
      _currentUser = await _authService.getCurrentUser();

      // If not found, try to get from local storage
      if (_currentUser == null) {
        _currentUser = await _authService.getCurrentUserFromStorage();
      }

      _error = null;
    } catch (e) {
      _error = 'Failed to initialize auth: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Sign up with email and password
  Future<bool> signUp(String email, String password, {String? name}) async {
    _setLoading(true);
    try {
      final user = await _authService.signUp(email, password, name: name);
      _currentUser = user;
      _error = null;
      return user != null;
    } catch (e) {
      _error = 'Failed to sign up: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    try {
      final user = await _authService.signIn(email, password);
      _currentUser = user;
      _error = null;
      return user != null;
    } catch (e) {
      _error = 'Failed to sign in: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _currentUser = null;
      _error = null;
    } catch (e) {
      _error = 'Failed to sign out: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    _setLoading(true);
    try {
      await _authService.resetPassword(email);
      _error = null;
    } catch (e) {
      _error = 'Failed to reset password: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Helper method to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Clear errors
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
