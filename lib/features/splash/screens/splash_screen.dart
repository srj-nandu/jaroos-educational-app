import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';

/// Interactive Touch Sparkle Particle
class _TouchParticle {
  final Offset origin;
  final double angle;
  final double speed;
  final Color color;
  final String symbol;
  double life; // 1.0 down to 0.0

  _TouchParticle({
    required this.origin,
    required this.angle,
    required this.speed,
    required this.color,
    required this.symbol,
    this.life = 1.0,
  });
}

/// Dynamic Cartoon Game-Style Animated Splash Screen for JAROOS.
/// Features:
/// - Custom game artwork with "JAROOS" bubbly 3D typography and "Learn • Play • Grow" ribbon
/// - Parallax floating camera and subtle breathing motion
/// - Rotating translucent sunburst rays behind characters
/// - Drifting fluffy cartoon clouds across the blue sky
/// - Floating twinkling stars and magical gem particles
/// - Interactive touch sparkles for kids on tap
/// - Tactile candy-striped loading capsule with real progress
/// - Clean navigation transition to Welcome / Home screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  late AnimationController _ambientController;
  late AnimationController _sunburstController;
  late AnimationController _cloudController;
  late AnimationController _loadingController;

  Timer? _navigationTimer;
  final List<_TouchParticle> _touchParticles = [];
  Timer? _particleTimer;

  @override
  void initState() {
    super.initState();

    // 1. Entrance elastic spring
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeIn,
    );
    _entranceController.forward();

    // 2. Ambient floating camera / breathing
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    // 3. Rotating radiant sunbeams (360 degrees)
    _sunburstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16000),
    )..repeat();

    // 4. Drifting clouds across the sky
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 14000),
    )..repeat();

    // 5. Game Loading Progress Bar (0 to 1 over splash duration)
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: AppConstants.splashDurationSeconds),
    )..forward();

    // 6. Particle update loop for touch sparkles
    _particleTimer = Timer.periodic(const Duration(milliseconds: 32), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_touchParticles.isNotEmpty) {
        setState(() {
          for (final p in _touchParticles) {
            p.life -= 0.05;
          }
          _touchParticles.removeWhere((p) => p.life <= 0);
        });
      }
    });

    // 7. Auto navigation
    _navigationTimer = Timer(
      const Duration(seconds: AppConstants.splashDurationSeconds),
      _navigateToNextScreen,
    );
  }

  void _spawnTouchSparkles(Offset pos) {
    final random = math.Random();
    const symbols = ['✨', '🌟', '⭐️', '💖', '🍎', '💎'];
    const colors = [
      Color(0xFFFFD54F),
      Color(0xFFFF7043),
      Color(0xFF4FC3F7),
      Color(0xFF81C784),
      Color(0xFFBA68C8),
    ];

    for (int i = 0; i < 6; i++) {
      final angle = random.nextDouble() * 2 * math.pi;
      final speed = 30.0 + random.nextDouble() * 50.0;
      _touchParticles.add(
        _TouchParticle(
          origin: pos,
          angle: angle,
          speed: speed,
          color: colors[random.nextInt(colors.length)],
          symbol: symbols[random.nextInt(symbols.length)],
        ),
      );
    }
    setState(() {});
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
    _particleTimer?.cancel();
    _particleTimer = null;
    _entranceController.dispose();
    _ambientController.dispose();
    _sunburstController.dispose();
    _cloudController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF28A8F7), // Sky blue matching background top
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) => _spawnTouchSparkles(details.localPosition),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Layer 1: Background Game Artwork with Parallax Breathing
            AnimatedBuilder(
              animation: _ambientController,
              builder: (context, child) {
                final floatOffset = math.sin(_ambientController.value * 2 * math.pi) * 6.0;
                final floatScale = 1.0 + (_ambientController.value * 0.035);

                return Transform.translate(
                  offset: Offset(0, floatOffset),
                  child: Transform.scale(
                    scale: floatScale,
                    child: Image.asset(
                      'assets/images/splash_game_bg.jpg',
                      fit: BoxFit.cover,
                      width: size.width,
                      height: size.height,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: AppColors.splashGradient,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),

            // 2. Layer 2: Rotating Radiant Sunburst Light Beams
            Positioned(
              top: size.height * 0.22,
              left: (size.width - size.width * 1.5) / 2,
              child: AnimatedBuilder(
                animation: _sunburstController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _sunburstController.value * 2 * math.pi,
                    child: CustomPaint(
                      size: Size(size.width * 1.5, size.width * 1.5),
                      painter: _SunburstPainter(),
                    ),
                  );
                },
              ),
            ),

            // 3. Layer 3: Drifting Fluffy Cartoon Clouds
            AnimatedBuilder(
              animation: _cloudController,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Cloud 1
                    Positioned(
                      top: size.height * 0.06,
                      left: ((_cloudController.value * size.width * 1.4) % (size.width + 160)) - 140,
                      child: _buildPuffyCloud(130, 48, 0.45),
                    ),
                    // Cloud 2 (moving opposite / slower)
                    Positioned(
                      top: size.height * 0.12,
                      right: (((1 - _cloudController.value) * size.width * 1.3) % (size.width + 180)) - 140,
                      child: _buildPuffyCloud(150, 56, 0.38),
                    ),
                    // Cloud 3
                    Positioned(
                      top: size.height * 0.18,
                      left: (((_cloudController.value + 0.5) * size.width * 1.2) % (size.width + 140)) - 120,
                      child: _buildPuffyCloud(100, 40, 0.30),
                    ),
                  ],
                );
              },
            ),

            // 4. Layer 4: Floating Magical Stars & Gem Particles
            AnimatedBuilder(
              animation: _ambientController,
              builder: (context, child) {
                return Stack(
                  children: [
                    _buildFloatingIcon(
                      left: size.width * 0.12,
                      top: size.height * 0.24,
                      offsetFactor: 1.0,
                      child: const Text('✨', style: TextStyle(fontSize: 24)),
                    ),
                    _buildFloatingIcon(
                      right: size.width * 0.10,
                      top: size.height * 0.22,
                      offsetFactor: 1.4,
                      child: const Text('🌟', style: TextStyle(fontSize: 26)),
                    ),
                    _buildFloatingIcon(
                      left: size.width * 0.08,
                      top: size.height * 0.48,
                      offsetFactor: 0.8,
                      child: const Text('💎', style: TextStyle(fontSize: 22)),
                    ),
                    _buildFloatingIcon(
                      right: size.width * 0.09,
                      top: size.height * 0.46,
                      offsetFactor: 1.2,
                      child: const Text('🍎', style: TextStyle(fontSize: 24)),
                    ),
                    _buildFloatingIcon(
                      left: size.width * 0.22,
                      bottom: size.height * 0.26,
                      offsetFactor: 0.9,
                      child: const Text('⭐️', style: TextStyle(fontSize: 20)),
                    ),
                  ],
                );
              },
            ),

            // 5. Layer 5: Interactive Touch Particles
            if (_touchParticles.isNotEmpty)
              CustomPaint(
                size: Size.infinite,
                painter: _TouchParticlePainter(_touchParticles),
              ),

            // 6. Layer 6: Bottom Game Progress Capsule & Interactive Hint
            Positioned(
              left: 24,
              right: 24,
              bottom: 30,
              child: SafeArea(
                top: false,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Game Capsule Container
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF0F264A),
                                Color(0xFF1E4078),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color(0xFFFFD54F),
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.45),
                                offset: const Offset(0, 8),
                                blurRadius: 16,
                              ),
                              BoxShadow(
                                color: const Color(0xFFFFD54F).withValues(alpha: 0.3),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Title & Tagline Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('🌟 ', style: TextStyle(fontSize: 18)),
                                  Text(
                                    'Learn • Play • Grow',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFFFE082),
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const Text(' 🚀', style: TextStyle(fontSize: 18)),
                                ],
                              ),

                              const SizedBox(height: 10),

                              // Animated Striped Loading Bar
                              AnimatedBuilder(
                                animation: _loadingController,
                                builder: (context, child) {
                                  final progress = _loadingController.value.clamp(0.05, 1.0);
                                  return Container(
                                    height: 14,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: progress,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFFF9100),
                                              Color(0xFFFFEA00),
                                              Color(0xFF76FF03),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFFFFEA00).withValues(alpha: 0.6),
                                              blurRadius: 6,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 6),

                              // Loading Status Caption
                              AnimatedBuilder(
                                animation: _loadingController,
                                builder: (context, child) {
                                  final percent = (_loadingController.value * 100).toInt();
                                  return Text(
                                    percent >= 90 ? 'Ready for Adventure! ✨' : 'Loading Adventures... $percent%',
                                    style: GoogleFonts.nunito(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white.withValues(alpha: 0.85),
                                      letterSpacing: 0.5,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Interactive tap prompt for kids
                        Text(
                          'Tap anywhere for magic sparkles! ✨',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withValues(alpha: 0.9),
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.7),
                                offset: const Offset(0, 1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper to create a floating icon with sine oscillation
  Widget _buildFloatingIcon({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required double offsetFactor,
    required Widget child,
  }) {
    final floatY = math.sin((_ambientController.value + offsetFactor) * 2 * math.pi) * 10.0;
    return Positioned(
      left: left,
      right: right,
      top: top != null ? top + floatY : null,
      bottom: bottom != null ? bottom - floatY : null,
      child: child,
    );
  }

  /// Soft cartoon cloud widget
  Widget _buildPuffyCloud(double width, double height, double opacity) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: opacity * 0.6),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

/// CustomPainter for rotating radiant sunburst rays behind the main hero
class _SunburstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const rayCount = 14;
    final angleStep = (2 * math.pi) / rayCount;

    final rayPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < rayCount; i += 2) {
      final startAngle = i * angleStep;
      final endAngle = (i + 1) * angleStep;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(
          center.dx + radius * math.cos(startAngle),
          center.dy + radius * math.sin(startAngle),
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          endAngle - startAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, rayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// CustomPainter for interactive touch sparkle bursts
class _TouchParticlePainter extends CustomPainter {
  final List<_TouchParticle> particles;

  _TouchParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final distance = (1.0 - p.life) * p.speed;
      final x = p.origin.dx + distance * math.cos(p.angle);
      final y = p.origin.dy + distance * math.sin(p.angle);

      final textSpan = TextSpan(
        text: p.symbol,
        style: TextStyle(
          fontSize: 16 * p.life + 8,
          color: p.color.withValues(alpha: p.life),
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TouchParticlePainter oldDelegate) => true;
}
