import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Centralized Authentication State Provider for JAROOS.
/// Manages user authentication lifecycle, active profile, loading states, and error handling.
class AuthProvider with ChangeNotifier {
  final AuthService _authService;

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? MockAuthService();

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Check persisted session during app launch
  Future<bool> checkAutoLogin() async {
    _setLoading(true);
    try {
      final savedUser = await _authService.getCurrentUser();
      if (savedUser != null) {
        _user = savedUser;
        _errorMessage = null;
        _setLoading(false);
        return true;
      }
    } catch (_) {
      // Ignored during background auto login
    }
    _setLoading(false);
    return false;
  }

  /// Sign In with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _user = await _authService.login(email: email, password: password);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Register new parent/child account
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String childName,
    required int childAge,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _user = await _authService.register(
        name: name,
        email: email,
        password: password,
        childName: childName,
        childAge: childAge,
      );
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Send password reset request
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final success = await _authService.resetPassword(email);
      _setLoading(false);
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _user = null;
      _errorMessage = null;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Update child profile information (avatar, name, age, favorite subject)
  Future<void> updateChildProfile({
    String? childName,
    int? childAge,
    String? avatar,
    String? favoriteSubject,
  }) async {
    if (_user == null) {
      _user = UserModel(
        id: 'learner_default',
        name: 'Learner Parent',
        email: 'learner@jaroos.com',
        childName: childName ?? 'Little Learner',
        childAge: childAge ?? 5,
        avatar: avatar ?? 'star_hero',
        favoriteSubject: favoriteSubject ?? 'Alphabet & Phonics 🔤',
        createdAt: DateTime.now(),
      );
    } else {
      _user = _user!.copyWith(
        childName: childName,
        childAge: childAge,
        avatar: avatar,
        favoriteSubject: favoriteSubject,
      );
    }
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
