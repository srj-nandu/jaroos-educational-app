import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized typographic hierarchy for JAROOS.
/// Uses friendly, rounded characters (Fredoka / Nunito) that are easy for
/// young children to read and recognize.
class AppTextStyles {
  // Brand & Logo Style
  static TextStyle logoStyle = GoogleFonts.fredoka(
    fontSize: 42,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.5,
    color: AppColors.primaryDark,
  );

  static TextStyle logoTagline = GoogleFonts.fredoka(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.0,
    color: AppColors.candyPink,
  );

  // Headlines
  static TextStyle headlineLarge = GoogleFonts.fredoka(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static TextStyle headlineMedium = GoogleFonts.fredoka(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineSmall = GoogleFonts.fredoka(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Titles (Card titles, module headings)
  static TextStyle titleLarge = GoogleFonts.fredoka(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.fredoka(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle titleSmall = GoogleFonts.fredoka(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  // Body Text
  static TextStyle bodyLarge = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle bodyMedium = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle bodySmall = GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
  );

  // Button Labels
  static TextStyle buttonLarge = GoogleFonts.fredoka(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static TextStyle buttonMedium = GoogleFonts.fredoka(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Big Learning Character (for Alphabet A-Z, Numbers 1-10)
  static TextStyle learningBigCharacter = GoogleFonts.fredoka(
    fontSize: 72,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryDark,
  );

  AppTextStyles._();
}
