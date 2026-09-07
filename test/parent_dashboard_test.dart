import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jaroos/core/services/tts_service.dart';
import 'package:jaroos/providers/auth_provider.dart';
import 'package:jaroos/providers/learning_provider.dart';
import 'package:jaroos/providers/parent_provider.dart';
import 'package:jaroos/features/parent/screens/parent_dashboard_screen.dart';
import 'package:jaroos/features/parent/widgets/parent_gate_dialog.dart';

Widget createTestParentApp({
  required Widget home,
  ParentProvider? parent,
  LearningProvider? learning,
  AuthProvider? auth,
}) {
  return MultiProvider(
    providers: [
      Provider<TtsService>(create: (_) => ModularTtsService(simulateDelay: false)),
      ChangeNotifierProvider<AuthProvider>(create: (_) => auth ?? AuthProvider()),
      ChangeNotifierProvider<LearningProvider>(create: (_) => learning ?? LearningProvider()),
      ChangeNotifierProvider<ParentProvider>(create: (_) => parent ?? ParentProvider()),
    ],
    child: MaterialApp(
      home: home,
    ),
  );
}

void main() {
  group('ParentProvider Unit Tests', () {
    test('Validates PIN and updates PIN correctly', () {
      final parent = ParentProvider();

      expect(parent.verifyPin('1234'), isTrue);
      expect(parent.verifyPin('9999'), isFalse);

      parent.updatePin('5678');
      expect(parent.verifyPin('5678'), isTrue);
      expect(parent.verifyPin('1234'), isFalse);
    });

    test('Generates and verifies math challenges', () {
      final parent = ParentProvider();
      parent.generateNewMathChallenge();
      expect(parent.mathQuestion.isNotEmpty, isTrue);

      // Verify math answer method
      expect(parent.verifyMathAnswer(999999), isFalse);
    });

    test('Screen time and module controls update properly', () {
      final parent = ParentProvider();

      expect(parent.settings.dailyTimeLimitMinutes, 30);
      parent.setDailyTimeLimit(45);
      expect(parent.settings.dailyTimeLimitMinutes, 45);

      expect(parent.isModuleEnabled('alphabet'), isTrue);
      parent.toggleModuleVisibility('alphabet');
      expect(parent.isModuleEnabled('alphabet'), isFalse);
      parent.toggleModuleVisibility('alphabet');
      expect(parent.isModuleEnabled('alphabet'), isTrue);
    });

    test('Loads Viva Demo Analytics accurately', () {
      final parent = ParentProvider();
      parent.loadVivaDemoAnalytics();

      expect(parent.settings.todayScreenTimeMinutes, 24);
      expect(parent.settings.weeklyMinutes.length, 7);
      expect(parent.settings.subjectAccuracy['Animals'], 98);
      expect(parent.settings.subjectAccuracy['Shapes'], 68);
    });

    test('LearningProvider resetProgress clears completed lessons and resets coins', () {
      final learning = LearningProvider();
      learning.addCoins(50);
      learning.completeLesson('alphabet');

      learning.resetProgress();
      expect(learning.coins, 100);
      expect(learning.totalLessonsCompleted, 0);
      expect(learning.totalQuizzesAttempted, 0);
    });
  });

  group('ParentGateDialog Widget Tests', () {
    testWidgets('Blocks incorrect PIN and unlocks on correct PIN 1234', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      bool unlocked = false;

      await tester.pumpWidget(createTestParentApp(
        home: Scaffold(
          body: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () {
                ParentGateDialog.show(ctx, onSuccess: () => unlocked = true);
              },
              child: const Text('Open Gate'),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      // Open gate dialog
      await tester.tap(find.text('Open Gate'));
      await tester.pumpAndSettle();

      expect(find.text('Grown-ups Only 👨‍👩‍👧'), findsOneWidget);
      expect(find.text('Default PIN: 1234'), findsOneWidget);

      // Enter wrong PIN
      await tester.enterText(find.byType(TextField), '0000');
      await tester.tap(find.text('Enter Parent Dashboard'));
      await tester.pumpAndSettle();

      expect(find.text('Incorrect PIN. Default is 1234'), findsOneWidget);
      expect(unlocked, isFalse);

      // Enter correct PIN
      await tester.enterText(find.byType(TextField), '1234');
      await tester.tap(find.text('Enter Parent Dashboard'));
      await tester.pumpAndSettle();

      expect(unlocked, isTrue);
      expect(find.byType(ParentGateDialog), findsNothing);
    });
  });

  group('ParentDashboardScreen Widget Tests', () {
    testWidgets('Renders dashboard, loads demo data, and shows controls', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      final parent = ParentProvider();
      final learning = LearningProvider();

      await tester.pumpWidget(createTestParentApp(
        home: const ParentDashboardScreen(),
        parent: parent,
        learning: learning,
      ));
      await tester.pumpAndSettle();

      // Verify sections
      expect(find.text('Parent Dashboard 👨‍👩‍👧'), findsOneWidget);
      expect(find.text('Daily Screen Time ⏳'), findsOneWidget);
      expect(find.text('Weekly Activity 📊'), findsOneWidget);
      expect(find.text('Subject Performance & Focus 🎯'), findsOneWidget);
      expect(find.text('Module Curriculum Controls 📚'), findsOneWidget);
      expect(find.text('Voice & Audio Preferences 🔊'), findsOneWidget);
      expect(find.text('Security & Safety Settings 🔐'), findsOneWidget);

      // Test "Demo Data" button in AppBar
      expect(find.text('Demo Data'), findsOneWidget);
      await tester.tap(find.text('Demo Data'));
      await tester.pumpAndSettle();

      expect(find.text('Loaded Viva Demo Analytics & Weekly Data 📊'), findsOneWidget);
      expect(parent.settings.todayScreenTimeMinutes, 24);

      // Test screen time limit chip tap
      await tester.tap(find.text('45 Min'));
      await tester.pumpAndSettle();
      expect(parent.settings.dailyTimeLimitMinutes, 45);
    });
  });
}
