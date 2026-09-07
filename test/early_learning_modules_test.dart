import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jaroos/core/services/tts_service.dart';
import 'package:jaroos/providers/learning_provider.dart';
import 'package:jaroos/features/alphabet/screens/alphabet_screen.dart';
import 'package:jaroos/features/numbers/screens/numbers_screen.dart';
import 'package:jaroos/features/colors/screens/colors_screen.dart';
import 'package:jaroos/features/shapes/screens/shapes_screen.dart';

Widget createTestModuleApp(Widget screen) {
  return MultiProvider(
    providers: [
      Provider<TtsService>(create: (_) => ModularTtsService(simulateDelay: false)),
      ChangeNotifierProvider<LearningProvider>(create: (_) => LearningProvider()),
    ],
    child: MaterialApp(
      home: screen,
    ),
  );
}

void main() {
  group('TtsService Unit Tests', () {
    test('TtsService handles speech requests gracefully', () async {
      final tts = ModularTtsService();
      expect(tts.isSpeaking, isFalse);

      final speakFuture = tts.speak('A for Apple');
      expect(tts.isSpeaking, isTrue);
      expect(tts.currentSpeech.value, 'A for Apple');

      await speakFuture;
      expect(tts.isSpeaking, isFalse);
    });

    test('TtsService stop resets speaking state', () async {
      final tts = ModularTtsService();
      tts.speak('Long paragraph to speak aloud');
      expect(tts.isSpeaking, isTrue);

      await tts.stop();
      expect(tts.isSpeaking, isFalse);
      expect(tts.currentSpeech.value, isNull);
    });
  });

  group('AlphabetScreen Widget Tests', () {
    testWidgets('Renders A to Z and opens detail dialog on tap', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestModuleApp(const AlphabetScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Alphabet (A to Z) 🔤'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);

      // Tap letter A card to open interactive popup
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('A for Apple'), findsOneWidget);
      expect(find.text('Hear Pronunciation'), findsOneWidget);
    });
  });

  group('NumbersScreen Widget Tests', () {
    testWidgets('Renders 1 to 20 and displays counting items', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestModuleApp(const NumbersScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Numbers (1 to 20) 🔢'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('One'), findsOneWidget);

      // Tap number 1 card to open counting dialog
      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Number One'), findsOneWidget);
    });
  });

  group('ColorsScreen Widget Tests', () {
    testWidgets('Renders color cards and opens mixing tip dialog', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestModuleApp(const ColorsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Colors Palette 🎨'), findsOneWidget);
      expect(find.text('Red'), findsOneWidget);
      expect(find.text('Blue'), findsOneWidget);

      // Tap Red card to open detail
      await tester.tap(find.text('Red'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Pronounce "Red"'), findsOneWidget);
    });
  });

  group('ShapesScreen Widget Tests', () {
    testWidgets('Renders shapes and displays sides info', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestModuleApp(const ShapesScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Shapes & Geometry 🔺'), findsOneWidget);
      expect(find.text('Circle'), findsOneWidget);
      expect(find.text('Square'), findsOneWidget);

      // Tap Circle card to open detail
      await tester.tap(find.text('Circle'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Pronounce "Circle"'), findsOneWidget);
    });
  });
}
