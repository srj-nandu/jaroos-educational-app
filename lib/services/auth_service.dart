import 'dart:async';
import '../models/user_model.dart';
import 'storage_service.dart';

/// Abstract contract for Authentication operations in JAROOS.
/// Designed for plug-and-play swapping between MockAuthService (Phase 2)
/// and ApiAuthService (Phase 10 Node.js backend).
abstract class AuthService {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String childName,
    required int childAge,
  });

  Future<void> logout();

  Future<UserModel?> getCurrentUser();

  Future<bool> resetPassword(String email);
}

/// In-memory & local mock authentication provider with realistic simulated JWT.
class MockAuthService implements AuthService {
  final StorageService _storageService;

  // Pre-seeded demo accounts for academic viva and instant demonstration
  final List<Map<String, dynamic>> _registeredUsers = [
    {
      'id': 'usr_001',
      'name': 'Priya Sharma',
      'email': 'learner@jaroos.com',
      'password': 'password123',
      'childName': 'Aarav',
      'childAge': 5,
      'avatar': 'star_hero',
      'createdAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
    },
    {
      'id': 'usr_002',
      'name': 'Rahul Verma',
      'email': 'parent@jaroos.com',
      'password': 'password123',
      'childName': 'Ananya',
      'childAge': 6,
      'avatar': 'cute_owl',
      'createdAt': DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
    },
  ];

  MockAuthService({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate realistic network roundtrip
    await Future.delayed(const Duration(milliseconds: 500));

    final normalizedEmail = email.trim().toLowerCase();
    final userMap = _registeredUsers.firstWhere(
      (u) => (u['email'] as String).toLowerCase() == normalizedEmail,
      orElse: () => throw Exception('No account found with this email address.'),
    );

    if (userMap['password'] != password) {
      throw Exception('Incorrect password. Please verify and try again.');
    }

    // Generate simulated JWT token
    final fakeJwtToken = 'mock_jwt_header.${userMap['id']}_${DateTime.now().millisecondsSinceEpoch}.signature';

    final user = UserModel(
      id: userMap['id'] as String,
      name: userMap['name'] as String,
      email: userMap['email'] as String,
      childName: userMap['childName'] as String,
      childAge: (userMap['childAge'] as int?) ?? 5,
      avatar: (userMap['avatar'] as String?) ?? 'star_hero',
      token: fakeJwtToken,
      createdAt: DateTime.tryParse(userMap['createdAt'] as String) ?? DateTime.now(),
    );

    // Save persistent session
    await _storageService.saveUser(user);
    return user;
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String childName,
    required int childAge,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final normalizedEmail = email.trim().toLowerCase();
    final exists = _registeredUsers.any(
      (u) => (u['email'] as String).toLowerCase() == normalizedEmail,
    );

    if (exists) {
      throw Exception('An account with this email already exists. Try logging in.');
    }

    final newId = 'usr_${DateTime.now().millisecondsSinceEpoch}';
    final fakeJwtToken = 'mock_jwt_header.${newId}_${DateTime.now().millisecondsSinceEpoch}.signature';
    final now = DateTime.now();

    final newUserMap = {
      'id': newId,
      'name': name.trim(),
      'email': normalizedEmail,
      'password': password,
      'childName': childName.trim().isEmpty ? 'Super Learner' : childName.trim(),
      'childAge': childAge,
      'avatar': 'star_hero',
      'createdAt': now.toIso8601String(),
    };

    _registeredUsers.add(newUserMap);

    final user = UserModel(
      id: newId,
      name: name.trim(),
      email: normalizedEmail,
      childName: childName.trim().isEmpty ? 'Super Learner' : childName.trim(),
      childAge: childAge,
      avatar: 'star_hero',
      token: fakeJwtToken,
      createdAt: now,
    );

    await _storageService.saveUser(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    await _storageService.clearSession();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _storageService.getUser();
  }

  @override
  Future<bool> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final normalizedEmail = email.trim().toLowerCase();
    final exists = _registeredUsers.any(
      (u) => (u['email'] as String).toLowerCase() == normalizedEmail,
    );
    if (!exists) {
      throw Exception('No account found registered under this email.');
    }
    return true;
  }
}
