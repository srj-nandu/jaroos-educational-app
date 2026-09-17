import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jaroos/core/services/tts_service.dart';
import 'package:jaroos/features/virtual_simulator/screens/virtual_simulator_screen.dart';
import 'package:jaroos/providers/auth_provider.dart';
import 'package:jaroos/providers/learning_provider.dart';
import 'package:jaroos/services/ai_service.dart';

Widget createTestSimulatorApp({
  required Widget home,
  AiService? aiService,
  TtsService? ttsService,
  LearningProvider? learningProvider,
}) {
  return MultiProvider(
    providers: [
      Provider<AiService>(
        create: (_) => aiService ?? const ModularAiService(simulateDelay: false),
      ),
      Provider<TtsService>(
        create: (_) => ttsService ?? ModularTtsService(simulateDelay: false),
      ),
      ChangeNotifierProvider<AuthProvider>(
        create: (_) => AuthProvider(),
      ),
      ChangeNotifierProvider<LearningProvider>(
        create: (_) => learningProvider ?? LearningProvider(),
      ),
    ],
    child: MaterialApp(
      home: home,
    ),
  );
}

void main() {
  group('VirtualSimulatorScreen Widget & Interaction Tests', () {
    testWidgets('Renders VirtualSimulatorScreen, character stage, speech bubble, and buttons', (tester) async {
      await tester.pumpWidget(
        createTestSimulatorApp(
          home: const VirtualSimulatorScreen(),
        ),
      );
      await tester.pump();

      // Header verification
      expect(find.text('Virtual Buddy 🎮'), findsOneWidget);

      // Speech bubble initial greeting
      expect(find.textContaining("Hi there! I'm your interactive buddy!"), findsOneWidget);

      // Action control buttons
      expect(find.text('Snacks 🍎'), findsOneWidget);
      expect(find.text('Dance 💃'), findsOneWidget);
      expect(find.text('Repeat 🎙️'), findsOneWidget);
      expect(find.text('High Five 🖐️'), findsOneWidget);

      // Character image asset presence
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('Tapping High Five awards coins and updates character speech', (tester) async {
      final learning = LearningProvider();
      final initialCoins = learning.coins;

      await tester.pumpWidget(
        createTestSimulatorApp(
          home: const VirtualSimulatorScreen(),
          learningProvider: learning,
        ),
      );
      await tester.pump();

      // Tap High Five button
      await tester.tap(find.text('High Five 🖐️'));
      await tester.pump();

      // Verifies 5 coins were awarded
      expect(learning.coins, equals(initialCoins + 5));

      // Verifies character high five speech
      expect(find.textContaining('High five, champ!'), findsOneWidget);
    });

    testWidgets('Snack feeding bottom sheet opens and feeds pizza to buddy with coin reward', (tester) async {
      final learning = LearningProvider();
      final initialCoins = learning.coins;

      await tester.pumpWidget(
        createTestSimulatorApp(
          home: const VirtualSimulatorScreen(),
          learningProvider: learning,
        ),
      );
      await tester.pump();

      // Open snack sheet
      await tester.tap(find.text('Snacks 🍎'));
      await tester.pumpAndSettle();

      // Verify snacks are listed
      expect(find.text('Feed a Snack to Your Buddy! 🍎'), findsOneWidget);
      expect(find.text('Pizza'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Cookie'), findsOneWidget);

      // Feed Pizza
      await tester.tap(find.text('Pizza'));
      await tester.pumpAndSettle();

      // Verifies coins awarded and eating speech displayed
      expect(learning.coins, equals(initialCoins + 5));
      expect(find.textContaining('Munch, munch, crunch!'), findsOneWidget);
    });

    testWidgets('Voice Repeat mode toggles and repeats phrase chips and custom inputs', (tester) async {
      await tester.pumpWidget(
        createTestSimulatorApp(
          home: const VirtualSimulatorScreen(),
        ),
      );
      await tester.pump();

      // Toggle Repeat mode
      await tester.tap(find.text('Repeat 🎙️'));
      await tester.pump();

      // Quick repeat chip appears
      expect(find.text('I love learning! 🚀'), findsOneWidget);
      expect(find.text('Type words to repeat...'), findsOneWidget);

      // Tap quick repeat chip
      await tester.tap(find.text('I love learning! 🚀'));
      await tester.pump();

      // Verifies mimicry repeat
      expect(find.textContaining('I love learning! 🚀'), findsWidgets);

      // Test custom text input repeat
      await tester.enterText(find.byType(TextField), 'You are super cool!');
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pump();

      expect(find.textContaining('You are super cool!'), findsOneWidget);
    });

    testWidgets('AI companion answers curious STEM questions and updates speech bubble', (tester) async {
      final aiService = const ModularAiService(simulateDelay: false);

      await tester.pumpWidget(
        createTestSimulatorApp(
          home: const VirtualSimulatorScreen(),
          aiService: aiService,
        ),
      );
      await tester.pump();

      // Tap curiosity chip "Why is the sky blue? ☀️"
      expect(find.text('Why is the sky blue? ☀️'), findsOneWidget);
      await tester.tap(find.text('Why is the sky blue? ☀️'));
      await tester.pump(); // starts AI
      await tester.pumpAndSettle(); // settles async answer

      // Verifies answer about sunlight / rainbow scattering appears
      expect(find.textContaining('rainbow'), findsOneWidget);
    });

    testWidgets('Dress-up accessory toggles display sunglasses and crown', (tester) async {
      await tester.pumpWidget(
        createTestSimulatorApp(
          home: const VirtualSimulatorScreen(),
        ),
      );
      await tester.pump();

      // Open accessory menu and toggle sunglasses
      expect(find.text('🕶️ 😎'), findsNothing);
      await tester.tap(find.byIcon(Icons.palette_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cool Sunglasses'));
      await tester.pumpAndSettle();
      expect(find.text('🕶️ 😎'), findsOneWidget);

      // Open accessory menu and toggle crown
      expect(find.text('👑'), findsNothing);
      await tester.tap(find.byIcon(Icons.palette_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Golden Crown'));
      await tester.pumpAndSettle();
      expect(find.text('👑'), findsOneWidget);
    });
  });
}
