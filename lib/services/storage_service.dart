import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

/// Local storage service managing persistence via SharedPreferences.
class StorageService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Persist authenticated user session
  Future<bool> saveUser(UserModel user) async {
    final prefs = await _getPrefs();
    final userJson = jsonEncode(user.toJson());
    await prefs.setBool(AppConstants.keyIsLoggedIn, true);
    if (user.token != null) {
      await prefs.setString(AppConstants.keyAuthToken, user.token!);
    }
    return prefs.setString(AppConstants.keyUserData, userJson);
  }

  /// Retrieve cached user session
  Future<UserModel?> getUser() async {
    final prefs = await _getPrefs();
    final isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
    if (!isLoggedIn) return null;

    final userJson = prefs.getString(AppConstants.keyUserData);
    if (userJson == null) return null;

    try {
      final Map<String, dynamic> map = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// Retrieve stored authentication token
  Future<String?> getToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(AppConstants.keyAuthToken);
  }

  /// Check if user has an active session
  Future<bool> isLoggedIn() async {
    final prefs = await _getPrefs();
    return prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  /// Clear session data upon logout
  Future<void> clearSession() async {
    final prefs = await _getPrefs();
    await prefs.remove(AppConstants.keyIsLoggedIn);
    await prefs.remove(AppConstants.keyAuthToken);
    await prefs.remove(AppConstants.keyUserData);
  }
}
