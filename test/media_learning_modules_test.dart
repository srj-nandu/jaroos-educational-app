import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jaroos/core/services/tts_service.dart';
import 'package:jaroos/providers/learning_provider.dart';
import 'package:jaroos/features/animals/screens/animals_screen.dart';
import 'package:jaroos/features/fruits/screens/fruits_screen.dart';
import 'package:jaroos/features/stories/screens/stories_screen.dart';
import 'package:jaroos/features/rhymes/screens/rhymes_screen.dart';

Widget createTestMediaApp(Widget screen) {
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
  group('AnimalsScreen Widget Tests', () {
    testWidgets('Renders animals, categories, and opens detail dialog', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestMediaApp(const AnimalsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Animal Friends 🦁'), findsOneWidget);
      expect(find.text('Lion'), findsOneWidget);
      expect(find.text('Roar!'), findsOneWidget);

      // Tap Lion card to open interactive detail
      await tester.tap(find.text('Lion'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Sound: "Roar!"'), findsOneWidget);
      expect(find.text('Hear Lion\'s Sound'), findsOneWidget);
    });
  });

  group('FruitsScreen Widget Tests', () {
    testWidgets('Renders fruits and veggies and supports category filtering', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestMediaApp(const FruitsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Fruits & Veggies 🍎🥕'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Carrot'), findsOneWidget);

      // Tap Apple card
      await tester.tap(find.text('Apple'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Pronounce "Apple"'), findsOneWidget);
    });
  });

  group('StoriesScreen Widget Tests', () {
    testWidgets('Renders bedtime stories and opens Story Reader with Read to Me', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestMediaApp(const StoriesScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Bedtime Stories 📖'), findsOneWidget);
      expect(find.text('ആമയും മുയലും'), findsOneWidget);

      // Tap on story card to open story reader
      await tester.tap(find.text('ആമയും മുയലും'));
      await tester.pumpAndSettle();

      expect(find.text('Read to Me'), findsOneWidget);
      expect(find.text('Moral of the Story'), findsOneWidget);
    });
  });

  group('RhymesScreen Widget Tests', () {
    testWidgets('Renders classic rhymes and opens Sing-Along Reader', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createTestMediaApp(const RhymesScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Fun Rhymes 🎵'), findsOneWidget);
      expect(find.text('Twinkle, Twinkle, Little Star'), findsOneWidget);

      // Tap on rhyme card to open sing-along player
      await tester.tap(find.text('Twinkle, Twinkle, Little Star'));
      await tester.pumpAndSettle();

      expect(find.text('Sing / Play Rhyme 🎵'), findsOneWidget);
      expect(find.text('🎶 Sing along with the words! 🎶'), findsOneWidget);
    });
  });
}
