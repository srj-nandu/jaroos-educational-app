import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_constants.dart';

/// Interactive vector-rendered JAROOS Mascot & Logo widget.
/// Renders a cute animated mascot with friendly bubbly typography.
class JaroosLogo extends StatelessWidget {
  final double mascotSize;
  final double fontSize;
  final bool showTagline;
  final bool isAnimated;

  const JaroosLogo({
    super.key,
    this.mascotSize = 120,
    this.fontSize = 44,
    this.showTagline = true,
    this.isAnimated = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Mascot Illustration Container
        _buildCuteMascot(mascotSize),
        const SizedBox(height: 16),

        // Playful Multi-Color Bubbly JAROOS Text
        _buildBubblyTitle(fontSize),

        if (showTagline) ...[
          const SizedBox(height: 12),
          // Tagline Badge: "Learn • Play • Grow"
          _buildTaglineBadge(),
        ],
      ],
    );
  }

  /// Cute custom vector-styled mascot (A smiling learning star with friendly eyes and sparkles)
  Widget _buildCuteMascot(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [
            Color(0xFFFFF9C4),
            Color(0xFFFFD54F),
            Color(0xFFFFB300),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryDark.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.8),
            blurRadius: 10,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rosy Cheeks
          Positioned(
            left: size * 0.22,
            bottom: size * 0.32,
            child: Container(
              width: size * 0.16,
              height: size * 0.10,
              decoration: BoxDecoration(
                color: AppColors.candyPink.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(size * 0.08),
              ),
            ),
          ),
          Positioned(
            right: size * 0.22,
            bottom: size * 0.32,
            child: Container(
              width: size * 0.16,
              height: size * 0.10,
              decoration: BoxDecoration(
                color: AppColors.candyPink.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(size * 0.08),
              ),
            ),
          ),

          // Big Cute Cartoon Eyes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEye(size * 0.24),
              SizedBox(width: size * 0.14),
              _buildEye(size * 0.24),
            ],
          ),

          // Cheerful Smile
          Positioned(
            bottom: size * 0.24,
            child: Container(
              width: size * 0.28,
              height: size * 0.14,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF5D4037),
                    width: 3.5,
                  ),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),
          ),

          // Top Sparkle / Graduation Little Star
          Positioned(
            top: size * 0.08,
            right: size * 0.15,
            child: const Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  /// Cartoon Eye with reflective highlights
  Widget _buildEye(double eyeSize) {
    return Container(
      width: eyeSize,
      height: eyeSize * 1.15,
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E50),
        borderRadius: BorderRadius.circular(eyeSize / 2),
      ),
      child: Stack(
        children: [
          // White Glint
          Positioned(
            top: eyeSize * 0.18,
            left: eyeSize * 0.20,
            child: Container(
              width: eyeSize * 0.40,
              height: eyeSize * 0.40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: eyeSize * 0.20,
            right: eyeSize * 0.22,
            child: Container(
              width: eyeSize * 0.20,
              height: eyeSize * 0.20,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Bubbly multi-color text where each letter has a distinct joyful hue
  Widget _buildBubblyTitle(double size) {
    const letters = [
      ('J', AppColors.primaryDark),
      ('A', AppColors.secondaryDark),
      ('R', AppColors.candyPink),
      ('O', AppColors.mintGreen),
      ('O', AppColors.coral),
      ('S', AppColors.lavender),
    ];

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: letters.map((pair) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            child: Text(
              pair.$1,
              style: GoogleFonts.fredoka(
                fontSize: size,
                fontWeight: FontWeight.w800,
                color: pair.$2,
                shadows: [
                  Shadow(
                    color: pair.$2.withValues(alpha: 0.3),
                    offset: const Offset(0, 3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Child-friendly rounded pill badge for the tagline
  Widget _buildTaglineBadge() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFFFD54F), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFB300).withValues(alpha: 0.18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, size: 16, color: AppColors.secondaryDark),
            const SizedBox(width: 8),
            Text(
              AppConstants.appTagline,
              style: GoogleFonts.fredoka(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.auto_awesome, size: 16, color: AppColors.secondaryDark),
          ],
        ),
      ),
    );
  }
}

