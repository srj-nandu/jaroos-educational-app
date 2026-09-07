import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/jaroos_logo.dart';

/// Splash Screen for JAROOS.
/// Displays animated mascot, colorful typography, and tagline "Learn • Play • Grow".
/// Automatically transitions to the Login screen after ~2 seconds.
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

    // Setup entrance animations
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

    // Scheduled navigation after exactly 2 seconds as specified in requirements
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
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = ResponsiveUtil.isSmallPhone(context);
    final isTablet = ResponsiveUtil.isTablet(context);
    final mascotSize = isTablet ? 160.0 : (isSmall ? 100.0 : 130.0);
    final fontSize = isTablet ? 56.0 : (isSmall ? 38.0 : 48.0);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Playful decorative background elements (soft clouds & stars)
              _buildBackgroundDecorations(size),

              // Centered Mascot & Branding
              Center(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: JaroosLogo(
                        mascotSize: mascotSize,
                        fontSize: fontSize,
                        showTagline: true,
                        isAnimated: true,
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom subtle indicator / version
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'v${AppConstants.appVersion} • Educational Platform',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Soft decorative clouds and twinkling stars in the background
  Widget _buildBackgroundDecorations(Size size) {
    return Stack(
      children: [
        // Top Left Cloud
        Positioned(
          top: size.height * 0.08,
          left: -20,
          child: _buildCloud(120, 60, Colors.white.withValues(alpha: 0.7)),
        ),

        // Top Right Sun Ray / Cloud
        Positioned(
          top: size.height * 0.05,
          right: -10,
          child: _buildCloud(140, 70, Colors.white.withValues(alpha: 0.6)),
        ),

        // Floating Little Stars
        Positioned(
          top: size.height * 0.20,
          left: 40,
          child: const Icon(Icons.star_rounded, color: Color(0xFFFFD54F), size: 28),
        ),
        Positioned(
          top: size.height * 0.25,
          right: 48,
          child: const Icon(Icons.star_rounded, color: Color(0xFFFF8DA1), size: 22),
        ),
        Positioned(
          bottom: size.height * 0.22,
          left: 36,
          child: const Icon(Icons.star_rounded, color: Color(0xFF81C784), size: 24),
        ),
        Positioned(
          bottom: size.height * 0.18,
          right: 40,
          child: const Icon(Icons.star_rounded, color: Color(0xFF4FC3F7), size: 30),
        ),

        // Bottom Fluffy Cloud
        Positioned(
          bottom: -30,
          left: size.width * 0.2,
          child: _buildCloud(220, 90, Colors.white.withValues(alpha: 0.85)),
        ),
      ],
    );
  }

  Widget _buildCloud(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}
