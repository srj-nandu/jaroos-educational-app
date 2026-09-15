import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';

/// Interactive Touch Sparkle Particle for kids
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

/// Floating Water Mist Particle for Waterfall Area
class _MistParticle {
  double x; // 0.0 to 1.0 fraction of width
  double y; // 0.0 to 1.0 fraction of height
  double radius;
  double speed;
  double opacity;

  _MistParticle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.opacity,
  });
}

/// Dynamic, Living Jungle Adventure Animated Splash Screen for JAROOS.
/// Features:
/// - Custom 3D Disney/Pixar-style Jungle Lion & Secret Waterfall artwork with "JAROOS - Learn • Play • Grow"
/// - Ambient breathing & gentle parallax camera zoom
/// - Animated crown shimmer & glistening light sparkles
/// - Animated fluttering tropical butterflies traversing the waterfall & flora
/// - Cascading waterfall mist & shimmering water spray bubbles
/// - Dappled sunbeams swaying through the rainforest canopy
/// - Floating fireflies and magical ambient stars
/// - Interactive touch burst particles on kid taps
/// - Wooden jungle adventure loading capsule with live progress
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
  late AnimationController _sunbeamController;
  late AnimationController _butterflyController;
  late AnimationController _mistController;
  late AnimationController _loadingController;

  Timer? _navigationTimer;
  final List<_TouchParticle> _touchParticles = [];
  final List<_MistParticle> _mistParticles = [];
  Timer? _particleTimer;

  @override
  void initState() {
    super.initState();

    // 1. Entrance elastic spring for UI elements
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
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

    // 2. Ambient floating camera / breathing motion
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    // 3. Swaying jungle sunbeams
    _sunbeamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat(reverse: true);

    // 4. Fluttering butterfly flight path
    _butterflyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 9000),
    )..repeat();

    // 5. Cascading waterfall mist loop
    _mistController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    // Initialize mist particles over the waterfall region
    final rand = math.Random();
    for (int i = 0; i < 22; i++) {
      _mistParticles.add(
        _MistParticle(
          x: 0.65 + rand.nextDouble() * 0.32,
          y: 0.40 + rand.nextDouble() * 0.48,
          radius: 3.0 + rand.nextDouble() * 7.0,
          speed: 0.0015 + rand.nextDouble() * 0.003,
          opacity: 0.15 + rand.nextDouble() * 0.35,
        ),
      );
    }

    // 6. Game Loading Progress Bar (0 to 1 over splash duration)
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: AppConstants.splashDurationSeconds),
    )..forward();

    // 7. Particle update loop for touch sparkles & mist
    _particleTimer = Timer.periodic(const Duration(milliseconds: 32), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        // Update touch particles
        if (_touchParticles.isNotEmpty) {
          for (final p in _touchParticles) {
            p.life -= 0.05;
          }
          _touchParticles.removeWhere((p) => p.life <= 0);
        }

        // Update mist particles
        for (final m in _mistParticles) {
          m.y -= m.speed;
          m.x += math.sin(m.y * 10) * 0.001;
          if (m.y < 0.35) {
            m.y = 0.85;
            m.x = 0.65 + rand.nextDouble() * 0.32;
          }
        }
      });
    });

    // 8. Auto navigation after splash duration
    _navigationTimer = Timer(
      const Duration(seconds: AppConstants.splashDurationSeconds),
      _navigateToNextScreen,
    );
  }

  void _spawnTouchSparkles(Offset pos) {
    final random = math.Random();
    const symbols = ['✨', '🌟', '🦁', '🐵', '🐾', '🌺', '💧', '💎'];
    const colors = [
      Color(0xFFFFD54F),
      Color(0xFFFF7043),
      Color(0xFF4FC3F7),
      Color(0xFF81C784),
      Color(0xFFFFB300),
      Color(0xFFE91E63),
    ];

    for (int i = 0; i < 7; i++) {
      final angle = random.nextDouble() * 2 * math.pi;
      final speed = 35.0 + random.nextDouble() * 55.0;
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
    _sunbeamController.dispose();
    _butterflyController.dispose();
    _mistController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1B4332), // Lush deep jungle green
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) => _spawnTouchSparkles(details.localPosition),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ================================================================
            // LAYER 1: Background Jungle Artwork with Subtle Breathing Zoom
            // ================================================================
            AnimatedBuilder(
              animation: _ambientController,
              builder: (context, child) {
                final floatOffset = math.sin(_ambientController.value * 2 * math.pi) * 5.0;
                final floatScale = 1.0 + (_ambientController.value * 0.03);

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

            // ================================================================
            // LAYER 2: Dappled Jungle Sunbeams Filtering from Upper Canopy
            // ================================================================
            AnimatedBuilder(
              animation: _sunbeamController,
              builder: (context, child) {
                final swayAngle = (_sunbeamController.value - 0.5) * 0.08;
                return Transform.rotate(
                  angle: swayAngle,
                  alignment: Alignment.topLeft,
                  child: CustomPaint(
                    size: Size(size.width, size.height * 0.6),
                    painter: _JungleSunbeamPainter(_sunbeamController.value),
                  ),
                );
              },
            ),

            // ================================================================
            // LAYER 3: Waterfall Mist & Rising Spray Bubbles
            // ================================================================
            CustomPaint(
              size: Size(size.width, size.height),
              painter: _WaterfallMistPainter(_mistParticles),
            ),

            // ================================================================
            // LAYER 4: Fluttering Tropical Butterflies Traversing the Jungle
            // ================================================================
            AnimatedBuilder(
              animation: _butterflyController,
              builder: (context, child) {
                final t = _butterflyController.value;
                // Butterfly 1: Flight across waterfall towards flowers
                final b1X = size.width * 0.85 - (t * size.width * 0.75);
                final b1Y = size.height * 0.35 + math.sin(t * 4 * math.pi) * 45;
                final b1Flap = (math.sin(t * 30 * math.pi) * 0.3).abs() + 0.7;

                // Butterfly 2: Playful circle around the lion & monkey
                final b2X = size.width * 0.20 + math.cos(t * 2 * math.pi) * 70;
                final b2Y = size.height * 0.60 + math.sin(t * 2 * math.pi) * 40;

                return Stack(
                  children: [
                    Positioned(
                      left: b1X,
                      top: b1Y,
                      child: Transform.scale(
                        scaleX: b1Flap,
                        child: const Text('🦋', style: TextStyle(fontSize: 24)),
                      ),
                    ),
                    Positioned(
                      left: b2X,
                      top: b2Y,
                      child: const Text('✨', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                );
              },
            ),

            // ================================================================
            // LAYER 5: Animated Golden Crown Shimmer & Sparkles over JAROOS Logo
            // ================================================================
            Positioned(
              top: MediaQuery.of(context).padding.top + 6,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: AnimatedBuilder(
                  animation: _ambientController,
                  builder: (context, child) {
                    final pulse = 0.85 + math.sin(_ambientController.value * 2 * math.pi) * 0.15;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: pulse,
                          child: const Text('✨', style: TextStyle(fontSize: 20)),
                        ),
                        const SizedBox(width: 80),
                        Transform.scale(
                          scale: 1.1 - (pulse * 0.2),
                          child: const Text('🌟', style: TextStyle(fontSize: 22)),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // ================================================================
            // LAYER 6: Floating Glowing Fireflies & Magic Sparkles
            // ================================================================
            AnimatedBuilder(
              animation: _ambientController,
              builder: (context, child) {
                return Stack(
                  children: [
                    _buildFloatingGlow(
                      left: size.width * 0.08,
                      top: size.height * 0.38,
                      icon: '🌟',
                      size: 22,
                      offsetFactor: 0.2,
                    ),
                    _buildFloatingGlow(
                      right: size.width * 0.12,
                      top: size.height * 0.30,
                      icon: '✨',
                      size: 24,
                      offsetFactor: 0.7,
                    ),
                    _buildFloatingGlow(
                      left: size.width * 0.88,
                      top: size.height * 0.65,
                      icon: '💧',
                      size: 20,
                      offsetFactor: 1.1,
                    ),
                    _buildFloatingGlow(
                      left: size.width * 0.06,
                      bottom: size.height * 0.28,
                      icon: '🌺',
                      size: 26,
                      offsetFactor: 0.5,
                    ),
                  ],
                );
              },
            ),

            // ================================================================
            // LAYER 7: Interactive Touch Sparkle Particles
            // ================================================================
            if (_touchParticles.isNotEmpty)
              CustomPaint(
                size: Size.infinite,
                painter: _TouchParticlePainter(_touchParticles),
              ),

            // ================================================================
            // LAYER 8: Bottom Jungle Adventure Loading Capsule & Progress Bar
            // ================================================================
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: SafeArea(
                top: false,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: _buildBottomLoadingCapsule(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom Jungle Adventure Loading Capsule
  Widget _buildBottomLoadingCapsule() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF1B4332),
                Color(0xFF2D6A4F),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFFFFD54F),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                offset: const Offset(0, 8),
                blurRadius: 16,
              ),
              BoxShadow(
                color: const Color(0xFFFFD54F).withValues(alpha: 0.35),
                blurRadius: 14,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Adventure Tip Caption & Tagline
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🌟 ', style: TextStyle(fontSize: 16)),
                    Text(
                      'Learn • Play • Grow',
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFFE082),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const Text(' 🚀', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),

              const SizedBox(height: 9),

              // Animated Striped Loading Bar
              AnimatedBuilder(
                animation: _loadingController,
                builder: (context, child) {
                  final progress = _loadingController.value.clamp(0.05, 1.0);
                  return Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
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
                              Color(0xFF00E676),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00E676).withValues(alpha: 0.6),
                              blurRadius: 8,
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

              // Loading Progress Percentage
              AnimatedBuilder(
                animation: _loadingController,
                builder: (context, child) {
                  final percent = (_loadingController.value * 100).toInt();
                  return Text(
                    percent >= 90 ? 'Ready to Explore! ✨' : 'Discovering the Waterfall... $percent%',
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 0.5,
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 9),

        // Interactive kid tap prompt
        Text(
          'Tap anywhere for magical jungle sparkles! ✨',
          style: GoogleFonts.nunito(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.8),
                offset: const Offset(0, 1.5),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Floating glow icon helper
  Widget _buildFloatingGlow({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required String icon,
    required double size,
    required double offsetFactor,
  }) {
    final floatY = math.sin((_ambientController.value + offsetFactor) * 2 * math.pi) * 8.0;
    return Positioned(
      left: left,
      right: right,
      top: top != null ? top + floatY : null,
      bottom: bottom != null ? bottom - floatY : null,
      child: Text(icon, style: TextStyle(fontSize: size)),
    );
  }
}

/// CustomPainter for dappled jungle sunbeams filtering through tree leaves
class _JungleSunbeamPainter extends CustomPainter {
  final double sway;
  _JungleSunbeamPainter(this.sway);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    // Draw 3 soft diagonal light rays
    final rays = [
      [Offset(size.width * 0.1, 0), Offset(size.width * 0.25, 0), Offset(size.width * 0.6, size.height), Offset(size.width * 0.4, size.height)],
      [Offset(size.width * 0.35, 0), Offset(size.width * 0.5, 0), Offset(size.width * 0.9, size.height), Offset(size.width * 0.7, size.height)],
    ];

    for (final r in rays) {
      final path = Path()
        ..moveTo(r[0].dx, r[0].dy)
        ..lineTo(r[1].dx, r[1].dy)
        ..lineTo(r[2].dx, r[2].dy)
        ..lineTo(r[3].dx, r[3].dy)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _JungleSunbeamPainter oldDelegate) => true;
}

/// CustomPainter for rising waterfall mist and spray bubbles
class _WaterfallMistPainter extends CustomPainter {
  final List<_MistParticle> particles;
  _WaterfallMistPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final mistPaint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final cx = p.x * size.width;
      final cy = p.y * size.height;
      mistPaint.color = Colors.white.withValues(alpha: p.opacity);
      canvas.drawCircle(Offset(cx, cy), p.radius, mistPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaterfallMistPainter oldDelegate) => true;
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
