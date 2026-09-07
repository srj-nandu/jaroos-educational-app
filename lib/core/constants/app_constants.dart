/// Application-wide constants for JAROOS
/// Tagline: Learn • Play • Grow
class AppConstants {
  // App Branding
  static const String appName = 'JAROOS';
  static const String appTagline = 'Learn • Play • Grow';
  static const String appSubTitle = 'An Interactive Educational App for Kids';
  static const String appVersion = '1.0.0';

  // Target Age Group
  static const String targetAgeGroup = 'Ages 3–8 Years';

  // Timers & Delays
  static const int splashDurationSeconds = 2;
  static const int animationDurationMs = 600;

  // Storage Keys (SharedPreferences)
  static const String keyIsLoggedIn = 'jaroos_is_logged_in';
  static const String keyAuthToken = 'jaroos_auth_token';
  static const String keyUserData = 'jaroos_user_data';
  static const String keyActiveChildProfile = 'jaroos_active_child_profile';
  static const String keyTotalCoins = 'jaroos_total_coins';
  static const String keySoundEnabled = 'jaroos_sound_enabled';
  static const String keyTtsEnabled = 'jaroos_tts_enabled';

  // Learning Module IDs
  static const String moduleAlphabet = 'alphabet';
  static const String moduleNumbers = 'numbers';
  static const String moduleColors = 'colors';
  static const String moduleShapes = 'shapes';
  static const String moduleAnimals = 'animals';
  static const String moduleFruits = 'fruits';
  static const String moduleStories = 'stories';
  static const String moduleRhymes = 'rhymes';
  static const String moduleQuiz = 'quiz';
  static const String moduleProgress = 'progress';

  // Private constructor to prevent instantiation
  AppConstants._();
}
