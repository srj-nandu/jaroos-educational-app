import 'package:flutter/material.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/authentication/screens/login_screen.dart';
import '../../features/authentication/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/alphabet/screens/alphabet_screen.dart';
import '../../features/numbers/screens/numbers_screen.dart';
import '../../features/colors/screens/colors_screen.dart';
import '../../features/shapes/screens/shapes_screen.dart';
import '../../features/animals/screens/animals_screen.dart';
import '../../features/fruits/screens/fruits_screen.dart';
import '../../features/stories/screens/stories_screen.dart';
import '../../features/rhymes/screens/rhymes_screen.dart';
import '../../features/quiz/screens/quiz_screen.dart';
import '../../features/progress/screens/progress_screen.dart';
import '../../features/achievements/screens/achievements_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/parent/screens/parent_dashboard_screen.dart';
import '../../features/ai_buddy/screens/ai_buddy_screen.dart';
import '../../features/ai_stories/screens/ai_story_generator_screen.dart';

/// Centralized route registry and route generator for JAROOS.
/// Maps all 19 screens and supplies playful custom page transitions.
class AppRoutes {
  // Screen Route Identifiers
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String alphabet = '/alphabet';
  static const String numbers = '/numbers';
  static const String colors = '/colors';
  static const String shapes = '/shapes';
  static const String animals = '/animals';
  static const String fruits = '/fruits';
  static const String stories = '/stories';
  static const String rhymes = '/rhymes';
  static const String quiz = '/quiz';
  static const String progress = '/progress';
  static const String achievements = '/achievements';
  static const String profile = '/profile';
  static const String parentDashboard = '/parent-dashboard';
  static const String aiBuddy = '/ai-buddy';
  static const String aiStoryGenerator = '/ai-story-generator';

  /// Generates routes with smooth playful transitions (Fade + Scale)
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildPageRoute(const SplashScreen(), settings);

      case login:
        return _buildPageRoute(const LoginScreen(), settings);

      case register:
        return _buildPageRoute(const RegisterScreen(), settings);

      case home:
        return _buildPageRoute(const HomeScreen(), settings);

      case alphabet:
        return _buildPageRoute(const AlphabetScreen(), settings);

      case numbers:
        return _buildPageRoute(const NumbersScreen(), settings);

      case colors:
        return _buildPageRoute(const ColorsScreen(), settings);

      case shapes:
        return _buildPageRoute(const ShapesScreen(), settings);

      case animals:
        return _buildPageRoute(const AnimalsScreen(), settings);

      case fruits:
        return _buildPageRoute(const FruitsScreen(), settings);

      case stories:
        return _buildPageRoute(const StoriesScreen(), settings);

      case rhymes:
        return _buildPageRoute(const RhymesScreen(), settings);

      case quiz:
        return _buildPageRoute(const QuizScreen(), settings);

      case progress:
        return _buildPageRoute(const ProgressScreen(), settings);

      case achievements:
        return _buildPageRoute(const AchievementsScreen(), settings);

      case profile:
        return _buildPageRoute(const ProfileScreen(), settings);

      case parentDashboard:
        return _buildPageRoute(const ParentDashboardScreen(), settings);

      case aiBuddy:
        return _buildPageRoute(const AiBuddyScreen(), settings);

      case aiStoryGenerator:
        return _buildPageRoute(const AiStoryGeneratorScreen(), settings);

      default:
        return _buildPageRoute(
          Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings,
        );
    }
  }

  /// Child-friendly playful page transition (Fade + gentle Scale)
  static PageRouteBuilder _buildPageRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const double beginScale = 0.95;
        const double endScale = 1.0;
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: beginScale, end: endScale).animate(curvedAnimation),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  /// Temporary graceful placeholder for future phases
  static PageRouteBuilder _buildPlaceholderRoute(String title, String subtitle, RouteSettings settings) {
    return _buildPageRoute(
      Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_stories_rounded, size: 72, color: Color(0xFF4FC3F7)),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 16, color: Color(0xFF607D8B)),
              ),
            ],
          ),
        ),
      ),
      settings,
    );
  }

  AppRoutes._();
}
