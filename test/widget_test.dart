import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:jaroos/main.dart';
import 'package:jaroos/core/services/tts_service.dart';
import 'package:jaroos/features/splash/screens/splash_screen.dart';
import 'package:jaroos/features/authentication/screens/welcome_screen.dart';
import 'package:jaroos/features/authentication/screens/login_screen.dart';
import 'package:jaroos/features/authentication/screens/register_screen.dart';
import 'package:jaroos/features/home/screens/home_screen.dart';
import 'package:jaroos/features/alphabet/screens/alphabet_screen.dart';
import 'package:jaroos/providers/auth_provider.dart';
import 'package:jaroos/providers/language_provider.dart';
import 'package:jaroos/providers/learning_provider.dart';
import 'package:jaroos/providers/parent_provider.dart';
import 'package:jaroos/services/storage_service.dart';

Widget createTestApp() {
  return MultiProvider(
    providers: [
      Provider<StorageService>(create: (_) => StorageService()),
      Provider<TtsService>(create: (_) => ModularTtsService(simulateDelay: false)),
      ChangeNotifierProvider<LanguageProvider>(create: (_) => LanguageProvider()),
      ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ChangeNotifierProvider<LearningProvider>(create: (_) => LearningProvider()),
      ChangeNotifierProvider<ParentProvider>(create: (_) => ParentProvider()),
    ],
    child: const JaroosApp(),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Full Splash -> Welcome -> Login -> Register navigation and UI verification', (WidgetTester tester) async {
    // Set a phone screen size to prevent layout bounds issues
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    // Build JAROOS App with Provider tree
    await tester.pumpWidget(createTestApp());

    // 1. Verify Splash Screen branding
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('Learn • Play • Grow'), findsOneWidget);

    // 2. Fast forward 2 seconds splash timer
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // 3. Verify Welcome Screen elements (Screen 1 in design mockup)
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Learn & Play.\nLevel Up Your World.'), findsOneWidget);
    expect(find.text('Start Learning'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);

    // 4. Tap "Log in" to navigate to redesigned Login Screen (Screen 2 in design mockup)
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Ready to learn?'), findsOneWidget);
    expect(find.text('Facebook'), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);
    expect(find.text('Demo Login'), findsOneWidget);

    // 5. Test Demo Login populates credentials
    await tester.tap(find.text('Demo Login'));
    await tester.pumpAndSettle();
    expect(find.text('learner@jaroos.com'), findsAtLeastNWidgets(1));

    // 6. Navigate to Register Screen
    final registerFinder = find.text('Sign Up');
    expect(registerFinder, findsOneWidget);
    await tester.tap(registerFinder);
    await tester.pumpAndSettle();

    // 7. Verify Register Screen elements
    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(find.text('Join JAROOS! 🌟'), findsOneWidget);
    expect(find.text('Child’s Age:'), findsOneWidget);
    expect(find.text('5 Yrs'), findsOneWidget);

    // 8. Test Age selection chip
    await tester.tap(find.text('6 Yrs'));
    await tester.pumpAndSettle();

    // 9. Navigate back to Login Screen
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);

    // Populate credentials again
    await tester.tap(find.text('Demo Login'));
    await tester.pumpAndSettle();

    // 10. Test Login submission with "Let's JAROOS!"
    await tester.tap(find.text("Let's JAROOS!"));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsNothing);

    // 11. Verify HomeScreen UI, Bottom Navigation Bar, and modules
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Hey, Aarav! 👋'), findsOneWidget);
    expect(find.text('Courses'), findsOneWidget); // Verifies Bottom Navigation Bar!
    expect(find.text('Alphabet'), findsAtLeastNWidgets(1));
    expect(find.text('Numbers'), findsOneWidget);
    expect(find.text('Colors'), findsOneWidget);

    // 12. Navigate from Home to Alphabet Module
    await tester.tap(find.text('Alphabet').first);
    await tester.pumpAndSettle();
    expect(find.byType(AlphabetScreen), findsOneWidget);
    expect(find.text('Alphabet (A to Z) 🔤'), findsOneWidget);
  });
}
