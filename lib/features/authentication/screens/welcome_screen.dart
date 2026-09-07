import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/jaroos_monster_mascot.dart';

/// Welcome / Get-Started Screen for JAROOS.
/// Features warm cream aesthetic, playful abstract top shapes, modern bold typography,
/// tactile pill buttons, and the cute green monster mascot peeking from the bottom.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: Stack(
        children: [
          // 1. Playful Abstract Shapes at the Top
          _buildAbstractTopShapes(),

          // 2. Main Content & Peeking Monster
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),

                // Headline & Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Let's learn &\nplay!",
                        style: GoogleFonts.fredoka(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: AppColors.monsterDarkNavy,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Say goodbye to boring lessons.\nWelcome to JAROOS.',
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6B7280),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Call-To-Action Pill Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      // Sign Up Button (Dark Navy)
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.register);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.monsterDarkNavy,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.fredoka(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Log In Button (Cream with Lime Green Border)
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.login);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.warmCream,
                            foregroundColor: AppColors.monsterGreenDark,
                            side: const BorderSide(
                              color: AppColors.monsterGreen,
                              width: 2.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Text(
                            'Log In',
                            style: GoogleFonts.fredoka(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF5E9C00),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 3),

                // 3. Cute Peeking Monster Mascot at Bottom
                SizedBox(
                  height: screenHeight * 0.28,
                  child: const JaroosMonsterMascot(
                    mode: MascotMode.peekingBottom,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Top organic abstract shapes matching the design mockup
  Widget _buildAbstractTopShapes() {
    return Positioned.fill(
      child: Stack(
        children: [
          // Top-Left Lime Green Blob
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 170,
              height: 170,
              decoration: const BoxDecoration(
                color: AppColors.monsterGreen,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(100),
                  bottomLeft: Radius.circular(80),
                  topRight: Radius.circular(60),
                ),
              ),
            ),
          ),

          // Center-Top Dark Navy Circle
          Positioned(
            top: 50,
            left: 170,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.monsterDarkNavy,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Top-Right Periwinkle Blue Crescent / Semi-circle
          Positioned(
            top: 40,
            right: -30,
            child: Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: AppColors.periwinkle,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
