import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/jaroos_monster_mascot.dart';

/// Redesigned Splash Screen for JAROOS matching the lime-green monster aesthetic.
/// Features the top-peeking mascot face with blinking eyes, bouncy title typography,
/// tagline "Learn • Play • Grow", and an animated loading pill.
/// Automatically transitions to Welcome / Home screen after ~2 seconds.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();

    _navigationTimer = Timer(
      const Duration(seconds: AppConstants.splashDurationSeconds),
      _navigateToNextScreen,
    );
  }

  Future<void> _navigateToNextScreen() async {
    if (!mounted) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isAuthenticated = await authProvider.checkAutoLogin();
    if (!mounted) return;

    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    }
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _navigationTimer = null;
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.monsterGreen,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // 1. Top Mascot Face (peeking down from top edge)
            const JaroosMonsterMascot(
              mode: MascotMode.topFace,
              scale: 1.05,
              animateBlink: true,
            ),

            const Spacer(flex: 1),

            // 2. Centered Animated Branding
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Playful App Name
                    Text(
                      'JAROOS',
                      style: GoogleFonts.fredoka(
                        fontSize: 54,
                        fontWeight: FontWeight.w900,
                        color: AppColors.monsterDarkNavy,
                        letterSpacing: 2.0,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Tagline Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.monsterGreenField.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF6FB800).withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('✨ ', style: TextStyle(fontSize: 16)),
                          Text(
                            'Learn • Play • Grow',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.monsterDarkNavy,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const Text(' 🌟', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Playful Loading Indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.monsterDarkNavy),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            'Getting ready for fun...',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.monsterDarkNavy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(flex: 2),

            // 3. Bottom Subtle Version
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'v${AppConstants.appVersion} • Educational Adventure',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF3B6200),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
