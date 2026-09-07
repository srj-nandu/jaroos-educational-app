import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jaroos/core/services/tts_service.dart';
import 'package:jaroos/providers/auth_provider.dart';
import 'package:jaroos/providers/learning_provider.dart';
import 'package:jaroos/services/ai_service.dart';
import 'package:jaroos/features/ai_buddy/screens/ai_buddy_screen.dart';
import 'package:jaroos/features/ai_stories/screens/ai_story_generator_screen.dart';

Widget createTestAiWidget({
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
  group('AiService Unit Tests', () {
    final aiService = const ModularAiService(simulateDelay: false);

    test('Safety filter intercepts unsafe words and redirects gracefully', () async {
      final response1 = await aiService.askJaroosBuddy('Is there a gun or monster?');
      expect(response1.contains('That sounds a little scary!'), isTrue);

      final response2 = await aiService.askJaroosBuddy('I want to fight and kill');
      expect(response2.contains('cheerful and bright'), isTrue);
    });

    test('Answers curious child questions with accurate STEM explanations', () async {
      final skyReply = await aiService.askJaroosBuddy('Why is the sky blue?');
      expect(skyReply.contains('rainbow'), isTrue);
      expect(skyReply.contains('short waves'), isTrue);

      final spiderReply = await aiService.askJaroosBuddy('How many legs does a spider have?');
      expect(spiderReply.contains('8 legs'), isTrue);

      final birdReply = await aiService.askJaroosBuddy('Why do birds sing?');
      expect(birdReply.contains('chirp'), isTrue);

      final jokeReply = await aiService.askJaroosBuddy('Tell me a joke!');
      expect(jokeReply.isNotEmpty, isTrue);
    });

    test('Generates personalized bedtime moral story', () async {
      final story = await aiService.generateBedtimeStory(
        hero: 'Brave Bunny',
        theme: 'Sharing Toys',
        setting: 'Candy Kingdom',
      );

      expect(story.title, 'The Adventures of Brave Bunny in Candy Kingdom');
      expect(story.hero, 'Brave Bunny');
      expect(story.heroEmoji, '🐰');
      expect(story.theme, 'Sharing Toys');
      expect(story.setting, 'Candy Kingdom');
      expect(story.paragraphs.length, 3);
      expect(story.moral.contains('Sharing Toys'), isTrue);
    });

    test('Evaluates child pronunciation accurately', () async {
      final feedbackExact = await aiService.evaluatePronunciation(
        targetWord: 'Elephant',
        spokenWord: 'Elephant',
      );
      expect(feedbackExact.accuracyScore, 100);
      expect(feedbackExact.isSuperStar, isTrue);

      final feedbackClose = await aiService.evaluatePronunciation(
        targetWord: 'Elephant',
        spokenWord: 'Elefant',
      );
      expect(feedbackClose.accuracyScore, 85);
      expect(feedbackClose.isSuperStar, isFalse);
    });
  });

  group('AiBuddyScreen Widget Tests', () {
    testWidgets('Renders Sparky avatar, greeting message and chips', (tester) async {
      await tester.pumpWidget(createTestAiWidget(home: const AiBuddyScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Sparky - AI Buddy 🌟'), findsOneWidget);
      expect(find.textContaining("I'm Sparky, your AI Learning Buddy!"), findsOneWidget);
      expect(find.text('Why is the sky blue? ☀️'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Tapping curiosity chip sends question and receives response', (tester) async {
      await tester.pumpWidget(createTestAiWidget(home: const AiBuddyScreen()));
      await tester.pumpAndSettle();

      // Tap on curiosity chip
      final chipFinder = find.text('Why is the sky blue? ☀️');
      expect(chipFinder, findsOneWidget);
      await tester.tap(chipFinder);
      await tester.pumpAndSettle();

      // Verify AI answered with rainbow/blue light explanation
      expect(find.textContaining('Sunlight looks white'), findsOneWidget);
    });
  });

  group('AiStoryGeneratorScreen Widget Tests', () {
    testWidgets('Renders hero, theme, and setting pickers', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestAiWidget(home: const AiStoryGeneratorScreen()));
      await tester.pumpAndSettle();

      expect(find.text('AI Story Magic ✨'), findsOneWidget);
      expect(find.text('Choose Your Hero'), findsOneWidget);
      expect(find.text('Baby Dragon'), findsOneWidget);
      expect(find.text('Brave Bunny'), findsOneWidget);

      expect(find.text('Choose A Moral Theme'), findsOneWidget);
      expect(find.text('Kindness'), findsOneWidget);

      expect(find.text('Choose Magical Setting'), findsOneWidget);
      expect(find.text('Enchanted Forest'), findsOneWidget);
      expect(find.text('Generate Bedtime Story'), findsOneWidget);
    });

    testWidgets('Generates story, awards coins, and displays story cards', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final learning = LearningProvider();
      final initialCoins = learning.coins;

      await tester.pumpWidget(createTestAiWidget(
        home: const AiStoryGeneratorScreen(),
        learningProvider: learning,
      ));
      await tester.pumpAndSettle();

      // Ensure visible and tap generate story
      final generateBtn = find.text('Generate Bedtime Story');
      await tester.ensureVisible(generateBtn);
      await tester.tap(generateBtn);
      await tester.pumpAndSettle();

      // Verify coins were rewarded (+10)
      expect(learning.coins, initialCoins + 10);

      // Verify story reader appears
      final readToMeBtn = find.text('Read to Me 🔊');
      expect(readToMeBtn, findsOneWidget);
      expect(find.text('Golden Lesson'), findsOneWidget);
      expect(find.textContaining('+10 Golden Coins Earned'), findsOneWidget);

      // Tap read to me
      await tester.ensureVisible(readToMeBtn);
      await tester.tap(readToMeBtn);
      await tester.pumpAndSettle();
    });
  });
}
