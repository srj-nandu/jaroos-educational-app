import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jaroos/models/user_model.dart';
import 'package:jaroos/models/learning_module_model.dart';
import 'package:jaroos/models/lesson_model.dart';
import 'package:jaroos/models/quiz_model.dart';
import 'package:jaroos/models/achievement_model.dart';
import 'package:jaroos/models/progress_model.dart';
import 'package:jaroos/services/auth_service.dart';
import 'package:jaroos/services/storage_service.dart';
import 'package:jaroos/providers/auth_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UserModel Tests', () {
    test('UserModel serializes and deserializes correctly', () {
      final now = DateTime.now();
      final user = UserModel(
        id: 'usr_test_1',
        name: 'Anita Roy',
        email: 'anita@example.com',
        childName: 'Leo',
        childAge: 5,
        token: 'test_token_123',
        createdAt: now,
      );

      final json = user.toJson();
      expect(json['id'], 'usr_test_1');
      expect(json['email'], 'anita@example.com');
      expect(json['childName'], 'Leo');
      expect(json['childAge'], 5);
      expect(json['token'], 'test_token_123');

      final deserialized = UserModel.fromJson(json);
      expect(deserialized.id, user.id);
      expect(deserialized.name, user.name);
      expect(deserialized.email, user.email);
      expect(deserialized.childName, user.childName);
      expect(deserialized.childAge, user.childAge);
      expect(deserialized.token, user.token);
    });

    test('UserModel copyWith works as expected', () {
      final user = UserModel(
        id: '1',
        name: 'Parent',
        email: 'p@test.com',
        childName: 'Kid',
        childAge: 4,
        createdAt: DateTime.now(),
      );

      final updated = user.copyWith(childName: 'Super Kid', childAge: 5);
      expect(updated.childName, 'Super Kid');
      expect(updated.childAge, 5);
      expect(updated.email, 'p@test.com');
    });
  });

  group('MockAuthService Tests', () {
    late MockAuthService authService;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      authService = MockAuthService(storageService: StorageService());
    });

    test('Login succeeds with demo learner credentials', () async {
      final user = await authService.login(
        email: 'learner@jaroos.com',
        password: 'password123',
      );

      expect(user.email, 'learner@jaroos.com');
      expect(user.childName, 'Aarav');
      expect(user.token, isNotNull);
      expect(user.token!.startsWith('mock_jwt_header'), isTrue);
    });

    test('Login fails with incorrect password', () async {
      expect(
        () async => await authService.login(
          email: 'learner@jaroos.com',
          password: 'wrong_password',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Login fails with unregistered email', () async {
      expect(
        () async => await authService.login(
          email: 'nonexistent@jaroos.com',
          password: 'password123',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Registration succeeds with new email', () async {
      final newUser = await authService.register(
        name: 'Devika Nair',
        email: 'devika@test.com',
        password: 'securePass123',
        childName: 'Diya',
        childAge: 6,
      );

      expect(newUser.email, 'devika@test.com');
      expect(newUser.childName, 'Diya');
      expect(newUser.childAge, 6);
      expect(newUser.token, isNotNull);
    });

    test('Registration fails with duplicate email', () async {
      expect(
        () async => await authService.register(
          name: 'Another User',
          email: 'learner@jaroos.com',
          password: 'password123',
          childName: 'Sam',
          childAge: 4,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('AuthProvider State Management Tests', () {
    late AuthProvider authProvider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      authProvider = AuthProvider(authService: MockAuthService(storageService: StorageService()));
    });

    test('Initial state is unauthenticated', () {
      expect(authProvider.isAuthenticated, isFalse);
      expect(authProvider.user, isNull);
      expect(authProvider.isLoading, isFalse);
      expect(authProvider.errorMessage, isNull);
    });

    test('Successful login updates provider state', () async {
      final success = await authProvider.login(
        email: 'learner@jaroos.com',
        password: 'password123',
      );

      expect(success, isTrue);
      expect(authProvider.isAuthenticated, isTrue);
      expect(authProvider.user?.childName, 'Aarav');
      expect(authProvider.errorMessage, isNull);
    });

    test('Failed login sets error message', () async {
      final success = await authProvider.login(
        email: 'learner@jaroos.com',
        password: 'wrongpassword',
      );

      expect(success, isFalse);
      expect(authProvider.isAuthenticated, isFalse);
      expect(authProvider.errorMessage, isNotNull);
    });

    test('Logout resets provider state', () async {
      await authProvider.login(
        email: 'learner@jaroos.com',
        password: 'password123',
      );
      expect(authProvider.isAuthenticated, isTrue);

      await authProvider.logout();
      expect(authProvider.isAuthenticated, isFalse);
      expect(authProvider.user, isNull);
    });
  });

  group('Domain Models Tests', () {
    test('LearningModuleModel calculates progress and serializes correctly', () {
      const module = LearningModuleModel(
        id: 'alphabet',
        title: 'Alphabet',
        subtitle: 'Learn A to Z',
        icon: Icons.abc,
        route: '/alphabet',
        primaryColor: Color(0xFF4FC3F7),
        secondaryColor: Color(0xFF29B6F6),
        totalLessons: 26,
        completedLessons: 13,
        order: 1,
      );

      expect(module.progressPercentage, 0.5);
      expect(module.isCompleted, isFalse);

      final json = module.toJson();
      expect(json['id'], 'alphabet');
      expect(json['totalLessons'], 26);
      expect(json['completedLessons'], 13);

      final fromJson = LearningModuleModel.fromJson(json);
      expect(fromJson.id, module.id);
      expect(fromJson.title, module.title);
      expect(fromJson.progressPercentage, 0.5);
    });

    test('LessonModel serializes and copies correctly', () {
      const lesson = LessonModel(
        id: 'alpha_a',
        moduleId: 'alphabet',
        title: 'Letter A',
        symbol: 'A',
        pronunciationWord: 'Apple',
        description: 'A is for Apple',
        funFact: 'Apples float in water!',
        imageAsset: 'assets/alphabets/a.png',
        order: 1,
        isCompleted: true,
      );

      final json = lesson.toJson();
      expect(json['id'], 'alpha_a');
      expect(json['symbol'], 'A');
      expect(json['isCompleted'], isTrue);

      final deserialized = LessonModel.fromJson(json);
      expect(deserialized.pronunciationWord, 'Apple');
      expect(deserialized.isCompleted, isTrue);

      final modified = lesson.copyWith(isCompleted: false);
      expect(modified.isCompleted, isFalse);
    });

    test('QuizQuestion and QuizResult scoring calculation', () {
      const question = QuizQuestion(
        id: 'q1',
        moduleId: 'animals',
        question: 'Which animal says Meow?',
        options: ['Dog', 'Cat', 'Cow', 'Lion'],
        correctOptionIndex: 1,
        explanation: 'Cats meow!',
      );

      expect(question.isCorrect(1), isTrue);
      expect(question.isCorrect(0), isFalse);

      final result = QuizResult.calculate(
        id: 'res_1',
        moduleId: 'animals',
        userId: 'usr_001',
        totalQuestions: 5,
        correctAnswers: 5,
      );

      expect(result.scorePercentage, 100.0);
      expect(result.starsEarned, 3);
      expect(result.coinsEarned, 50);

      final partialResult = QuizResult.calculate(
        id: 'res_2',
        moduleId: 'animals',
        userId: 'usr_001',
        totalQuestions: 5,
        correctAnswers: 3,
      );

      expect(partialResult.scorePercentage, 60.0);
      expect(partialResult.starsEarned, 2);
    });

    test('AchievementModel and ProgressModel tracking', () {
      const achievement = AchievementModel(
        id: 'first_lesson',
        title: 'First Lesson',
        description: 'Completed your first lesson',
        icon: Icons.star,
        badgeColor: Color(0xFFFFD700),
        rewardCoins: 50,
        requiredCount: 1,
        currentCount: 1,
        isUnlocked: true,
      );

      expect(achievement.progressPercentage, 1.0);
      expect(achievement.isUnlocked, isTrue);

      final progress = ProgressModel(
        userId: 'usr_001',
        overallPercentage: 75.0,
        currentStreakDays: 5,
        totalCoins: 250,
        totalLessonsCompleted: 15,
        totalQuizzesAttempted: 4,
        averageQuizScore: 88.5,
        completedModuleIds: const ['alphabet', 'colors'],
        moduleProgress: const {'alphabet': 1.0, 'colors': 1.0, 'numbers': 0.5},
        lastActiveDate: DateTime.now(),
      );

      final json = progress.toJson();
      expect(json['totalCoins'], 250);
      expect(json['currentStreakDays'], 5);

      final fromJson = ProgressModel.fromJson(json);
      expect(fromJson.totalCoins, 250);
      expect(fromJson.moduleProgress['numbers'], 0.5);
    });
  });
}

