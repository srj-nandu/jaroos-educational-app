import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:jaroos/main.dart';
import 'package:jaroos/core/services/tts_service.dart';
import 'package:jaroos/features/splash/screens/splash_screen.dart';
import 'package:jaroos/features/authentication/screens/login_screen.dart';
import 'package:jaroos/features/authentication/screens/register_screen.dart';
import 'package:jaroos/features/home/screens/home_screen.dart';
import 'package:jaroos/features/alphabet/screens/alphabet_screen.dart';
import 'package:jaroos/providers/auth_provider.dart';
import 'package:jaroos/providers/learning_provider.dart';
import 'package:jaroos/services/storage_service.dart';

Widget createTestApp() {
  return MultiProvider(
    providers: [
      Provider<StorageService>(create: (_) => StorageService()),
      Provider<TtsService>(create: (_) => ModularTtsService(simulateDelay: false)),
      ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ChangeNotifierProvider<LearningProvider>(create: (_) => LearningProvider()),
    ],
    child: const JaroosApp(),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Full Splash -> Login -> Register navigation and UI verification', (WidgetTester tester) async {
    // Set a phone screen size to prevent any layout bounds issues
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

    // 3. Verify Login Screen elements
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome Back! 👋'), findsOneWidget);
    expect(find.text('Try Demo Learner Account (1-Tap)'), findsOneWidget);

    // 4. Test 1-Tap Demo button populates credentials
    await tester.tap(find.text('Try Demo Learner Account (1-Tap)'));
    await tester.pumpAndSettle();
    expect(find.text('learner@jaroos.com'), findsAtLeastNWidgets(1));

    // 5. Navigate to Register Screen
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    // 6. Verify Register Screen elements
    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(find.text('Join the Adventure! 🚀'), findsOneWidget);
    expect(find.text('Child Age'), findsOneWidget);

    // Check that age chips (3 to 8) exist
    expect(find.text('3'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);

    // 7. Test Age selection
    await tester.tap(find.text('6'));
    await tester.pumpAndSettle();
    expect(find.text('6 Years Old'), findsOneWidget);

    // 8. Test Back to Login navigation
    await tester.tap(find.text('Back to Login'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);

    // 9. Test Login submission with populated demo account
    await tester.tap(find.text("Let's Play & Learn!"));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsNothing);

    // 10. Verify HomeScreen UI and modules
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Hi, Aarav! 👋'), findsOneWidget);
    expect(find.text('Learning Adventures 🚀'), findsOneWidget);
    expect(find.text('Alphabet'), findsOneWidget);
    expect(find.text('Numbers'), findsOneWidget);
    expect(find.text('Colors'), findsOneWidget);

    // 11. Navigate from Home to Alphabet Module
    await tester.tap(find.text('Alphabet'));
    await tester.pumpAndSettle();
    expect(find.byType(AlphabetScreen), findsOneWidget);
    expect(find.text('Alphabet (A to Z) 🔤'), findsOneWidget);
  });
}
