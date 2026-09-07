import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jaroos/core/services/tts_service.dart';
import 'package:jaroos/providers/learning_provider.dart';
import 'package:jaroos/features/quiz/screens/quiz_screen.dart';

Widget createTestQuizApp() {
  return MultiProvider(
    providers: [
      Provider<TtsService>(create: (_) => ModularTtsService(simulateDelay: false)),
      ChangeNotifierProvider<LearningProvider>(create: (_) => LearningProvider()),
    ],
    child: const MaterialApp(
      home: QuizScreen(),
    ),
  );
}

void main() {
  group('QuizScreen Widget & Logic Tests', () {
    testWidgets('Renders Quiz Arena, starts quiz, answers correctly, and sees results', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestQuizApp());
      await tester.pumpAndSettle();

      // 1. Verify Topic Selection Screen
      expect(find.text('Quiz Arena 🏆'), findsOneWidget);
      expect(find.text('Test Your Knowledge!'), findsOneWidget);
      expect(find.text('Animals & Friends'), findsOneWidget);
      expect(find.text('Alphabet & Phonics'), findsOneWidget);

      // 2. Start Animals & Friends Quiz
      await tester.tap(find.text('Animals & Friends'));
      await tester.pumpAndSettle();

      // 3. Verify Question 1 of 5
      expect(find.text('Question 1 of 5'), findsOneWidget);
      expect(find.text('Which animal says "Meow Meow"?'), findsOneWidget);
      expect(find.text('Cat'), findsOneWidget);

      // 4. Select Correct Answer: "Cat"
      await tester.tap(find.text('Cat'));
      await tester.pumpAndSettle();

      // 5. Verify Immediate Feedback
      expect(find.text('Next Question ➡️'), findsOneWidget);
      expect(find.textContaining('Cats make a cheerful "Meow Meow" sound!'), findsOneWidget);

      // 6. Navigate through remaining questions (Q2, Q3, Q4, Q5)
      // Q2
      await tester.tap(find.text('Next Question ➡️'));
      await tester.pumpAndSettle();
      expect(find.text('Question 2 of 5'), findsOneWidget);
      await tester.tap(find.text('Lion')); // Q2 answer
      await tester.pumpAndSettle();

      // Q3
      await tester.tap(find.text('Next Question ➡️'));
      await tester.pumpAndSettle();
      expect(find.text('Question 3 of 5'), findsOneWidget);
      await tester.tap(find.text('Cow')); // Q3 answer
      await tester.pumpAndSettle();

      // Q4
      await tester.tap(find.text('Next Question ➡️'));
      await tester.pumpAndSettle();
      expect(find.text('Question 4 of 5'), findsOneWidget);
      await tester.tap(find.text('Octopus')); // Q4 answer
      await tester.pumpAndSettle();

      // Q5
      await tester.tap(find.text('Next Question ➡️'));
      await tester.pumpAndSettle();
      expect(find.text('Question 5 of 5'), findsOneWidget);
      await tester.tap(find.text('Penguin')); // Q5 answer
      await tester.pumpAndSettle();

      // 7. Finish Quiz and view Results Screen
      expect(find.text('See My Results! 🌟'), findsOneWidget);
      await tester.tap(find.text('See My Results! 🌟'));
      await tester.pumpAndSettle();

      // 8. Verify Results
      expect(find.text('100%'), findsOneWidget);
      expect(find.text('5 of 5 Questions Correct'), findsOneWidget);
      expect(find.text('+50 Coins Earned!'), findsOneWidget);
      expect(find.text('Try Again 🔄'), findsOneWidget);
      expect(find.text('Choose Another Quiz'), findsOneWidget);
    });
  });
}
