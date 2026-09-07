/// Application build flavor / variant
enum AppFlavor {
  /// Clean, production-ready build for global users
  /// Clean onboarding, zero-start streak/coins, no prefilled mock data
  global,

  /// Preloaded evaluation build for testing, viva evaluation, and examiners
  /// Preloaded learner "Aria", 7-day streak, 320 XP, Silver league, demo credentials
  testing;

  /// Detects active flavor from dart-define `--dart-define=APP_FLAVOR=global` or `testing`
  /// Defaults to `testing` for smooth development and testing experience
  static AppFlavor get current {
    const flavorStr = String.fromEnvironment('APP_FLAVOR', defaultValue: 'testing');
    if (flavorStr.toLowerCase() == 'global') {
      return AppFlavor.global;
    }
    return AppFlavor.testing;
  }

  static bool get isGlobal => current == AppFlavor.global;
  static bool get isTesting => current == AppFlavor.testing;
}
