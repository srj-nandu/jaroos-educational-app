import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jaroos/core/services/tts_service.dart';
import 'package:jaroos/models/user_model.dart';
import 'package:jaroos/providers/auth_provider.dart';
import 'package:jaroos/providers/learning_provider.dart';
import 'package:jaroos/features/progress/screens/progress_screen.dart';
import 'package:jaroos/features/achievements/screens/achievements_screen.dart';
import 'package:jaroos/features/profile/screens/profile_screen.dart';

Widget createTestApp({
  required Widget home,
  AuthProvider? auth,
  LearningProvider? learning,
}) {
  return MultiProvider(
    providers: [
      Provider<TtsService>(create: (_) => ModularTtsService(simulateDelay: false)),
      ChangeNotifierProvider<AuthProvider>(create: (_) => auth ?? AuthProvider()),
      ChangeNotifierProvider<LearningProvider>(create: (_) => learning ?? LearningProvider()),
    ],
    child: MaterialApp(
      home: home,
    ),
  );
}

void main() {
  group('LearningProvider Progress & Achievements Tests', () {
    test('Calculates overall progress, stars, and manages achievements', () {
      final provider = LearningProvider();

      expect(provider.modules.length, 10);
      expect(provider.achievements.length, 10);
      expect(provider.overallProgress, greaterThan(0));
      expect(provider.totalStars, greaterThan(0));
      expect(provider.unlockedAchievementsCount, greaterThan(0));

      final initialCoins = provider.coins;
      final success = provider.claimAchievementReward('badge_numbers');
      expect(success, isTrue);
      expect(provider.coins, initialCoins + 50);

      final progress = provider.progressData;
      expect(progress.totalCoins, provider.coins);
      expect(progress.currentStreakDays, provider.streakDays);
    });

    test('Quiz results update provider statistics', () {
      final provider = LearningProvider();
      final prevQuizzes = provider.totalQuizzesAttempted;

      provider.addQuizResult(score: 100, stars: 3, earnedCoins: 30);
      expect(provider.totalQuizzesAttempted, prevQuizzes + 1);
      expect(provider.averageQuizScore, greaterThan(90));
    });
  });

  group('ProgressScreen Widget Tests', () {
    testWidgets('Renders mastery hero, quick stats, and module breakdown', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestApp(home: const ProgressScreen()));
      await tester.pumpAndSettle();

      expect(find.text('My Learning Journey 🚀'), findsOneWidget);
      expect(find.text('Overall Mastery'), findsOneWidget);
      expect(find.text('Coins'), findsOneWidget);
      expect(find.text('Stars'), findsOneWidget);
      expect(find.text('Streak'), findsOneWidget);
      expect(find.text('Lessons'), findsOneWidget);
      expect(find.text('Achievements & Badges'), findsOneWidget);
      expect(find.text('Module Breakdown 📚'), findsOneWidget);
      expect(find.text('Alphabet'), findsOneWidget);
      expect(find.text('Numbers'), findsOneWidget);
    });
  });

  group('AchievementsScreen Widget Tests', () {
    testWidgets('Renders trophy room and opens detail dialog on tap', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestApp(home: const AchievementsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Trophy Room 🏆'), findsOneWidget);
      expect(find.text('Number Wizard'), findsOneWidget);
      expect(find.text('Rainbow Explorer'), findsOneWidget);

      // Tap on Number Wizard badge to open dialog
      await tester.tap(find.text('Number Wizard'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Awesome! 🌟'), findsOneWidget);

      // Dismiss dialog
      await tester.tap(find.text('Awesome! 🌟'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });
  });

  group('ProfileScreen Widget Tests', () {
    testWidgets('Renders profile, avatar carousel, updates avatar and edits profile', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      final auth = AuthProvider();
      await auth.updateChildProfile(
        childName: 'Aarav',
        childAge: 5,
        avatar: 'star_hero',
        favoriteSubject: 'Alphabet & Phonics 🔤',
      );

      await tester.pumpWidget(createTestApp(
        home: const ProfileScreen(),
        auth: auth,
      ));
      await tester.pumpAndSettle();

      expect(find.text('My Profile 👤'), findsOneWidget);
      expect(find.text('Aarav'), findsOneWidget);
      expect(find.text('5 Years Old'), findsOneWidget);
      expect(find.text('Choose Your Mascot Avatar 🎨'), findsOneWidget);
      expect(find.text('Sparky'), findsOneWidget);
      expect(find.text('Leo'), findsOneWidget);

      // Tap Leo avatar to switch mascot
      await tester.tap(find.text('Leo'));
      await tester.pumpAndSettle();

      // Verify Leo is now active in auth provider
      expect(auth.user?.avatar, 'lion_brave');

      // Tap edit button to open edit profile dialog
      await tester.tap(find.byIcon(Icons.edit_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Edit Learner Profile ✏️'), findsOneWidget);

      // Select age 6 chip in dialog
      await tester.tap(find.text('6 yrs'));
      await tester.pumpAndSettle();

      // Save changes
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsNothing);
      expect(auth.user?.childAge, 6);
    });
  });
}
