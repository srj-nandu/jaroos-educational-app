import 'package:flutter/material.dart';

/// Centralized color palette for the JAROOS child-friendly design system.
/// Designed specifically for children aged 3–8: bright, cheerful, high-contrast,
/// and soft on young eyes.
class AppColors {
  // Brand Primary & Secondary
  static const Color primary = Color(0xFF4FC3F7); // Sky Blue
  static const Color primaryDark = Color(0xFF0288D1);
  static const Color primaryLight = Color(0xFFE1F5FE);

  static const Color secondary = Color(0xFFFFB300); // Sunshine Yellow
  static const Color secondaryDark = Color(0xFFFF8F00);
  static const Color secondaryLight = Color(0xFFFFF8E1);

  // Child-Friendly Accent Colors
  static const Color coral = Color(0xFFFF7043); // Cheerful Orange
  static const Color candyPink = Color(0xFFFF6584); // Bubblegum Pink
  static const Color mintGreen = Color(0xFF66BB6A); // Meadow Green
  static const Color lavender = Color(0xFFAB47BC); // Magic Purple
  static const Color electricBlue = Color(0xFF29B6F6); // Vibrant Blue
  static const Color peach = Color(0xFFFFAB91); // Soft Peach

  // Monster Mascot & Pop-Art Theme (Welcome & Auth Screens)
  static const Color monsterGreen = Color(0xFF8CE600); // Lush Lime Green Mascot
  static const Color monsterGreenDark = Color(0xFF72BA00); // Darker Green for Buttons/Accents
  static const Color monsterGreenField = Color(0xFF7BCF00); // Field background on green
  static const Color monsterDarkNavy = Color(0xFF0D1333); // Deep contrast navy text & buttons
  static const Color warmCream = Color(0xFFFAF8EE); // Warm Cream Welcome Canvas
  static const Color periwinkle = Color(0xFF8EA4F8); // Playful top blob
  static const Color googleRed = Color(0xFFEA4335); // Google social pill
  static const Color facebookBlue = Color(0xFF4267B2); // Facebook social pill

  // Neutral & Canvas Colors
  static const Color background = Color(0xFFFFFDF7); // Gentle Cream Storybook
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF7F4EB);
  static const Color border = Color(0xFFEADBCE);

  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50); // Deep friendly charcoal
  static const Color textSecondary = Color(0xFF607D8B); // Slate
  static const Color textLight = Color(0xFF90A4AE); // Soft subtitle
  static const Color textWhite = Colors.white;

  // Feedback Colors
  static const Color success = Color(0xFF4CAF50); // Right answer green
  static const Color warning = Color(0xFFFFA000);
  static const Color error = Color(0xFFEF5350); // Friendly red
  static const Color starGold = Color(0xFFFFD700); // Rewards & Stars

  // Gradients for Module Cards & Buttons
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunGradient = LinearGradient(
    colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pinkGradient = LinearGradient(
    colors: [Color(0xFFFF8DA1), Color(0xFFFF6584)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF81C784), Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFFBA68C8), Color(0xFF9C27B0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [
      Color(0xFFE1F5FE), // Soft sky blue top
      Color(0xFFFFF9C4), // Warm sunlight middle
      Color(0xFFFFFDF7), // Soft cream bottom
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadows
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF2C3E50).withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> tactileButtonShadow(Color baseColor) => [
    BoxShadow(
      color: baseColor.withValues(alpha: 0.35),
      blurRadius: 10,
      offset: const Offset(0, 5),
    ),
  ];

  AppColors._();
}
