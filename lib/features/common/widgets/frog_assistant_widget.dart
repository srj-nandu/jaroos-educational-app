import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/audio_fx_service.dart';

/// Cut-the-Rope Style Animated Frog Assistant ("Froggo").
/// Features:
/// - Custom vector Om-Nom style round green body with big glossy cartoon eyes
/// - Animated mouth opening/closing with tongue and teeth
/// - Candy feeding interaction with "Chomp! Nom Nom Nom!" animation & sound FX
/// - Cheerful study hints & streak encouragement speech bubble
/// - Can be tapped to poke, tickle, or fed treats
class FrogAssistantWidget extends StatefulWidget {
  final bool compact;
  final String? customTip;

  const FrogAssistantWidget({
    super.key,
    this.compact = false,
    this.customTip,
  });

  @override
  State<FrogAssistantWidget> createState() => _FrogAssistantWidgetState();
}

class _FrogAssistantWidgetState extends State<FrogAssistantWidget>
    with TickerProviderStateMixin {
  late AnimationController _idleController;
  late AnimationController _blinkController;
  late AnimationController _mouthController;
  late AnimationController _feedController;

  late AudioFxService _audioFx;
  bool _isSpeechBubbleVisible = false;
  String _currentMessage = "Ribbit! Tap me or feed me candy! 🍬";
  bool _isEating = false;

  final List<String> _tips = [
    "Ribbit! Let's keep that 🔥 7-day streak alive!",
    "Nom nom! Complete a lesson to win shiny gems! 💎",
    "Did you know? Reading stories makes your brain grow! 📖",
    "Boing! You're super smart, little learner! 🌟",
    "Ribbit! Tap the headphones on the path to start! 🎧",
  ];
  int _tipIndex = 0;

  @override
  void initState() {
    super.initState();
    _audioFx = AudioFxService();

    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');

    // 1. Idle breathing & subtle wobble
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    if (!isTest) {
      _idleController.repeat(reverse: true);
    } else {
      _idleController.value = 0.5;
    }

    // 2. Eye blinking
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    // 3. Mouth open / close
    _mouthController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    // 4. Candy falling into mouth
    _feedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    if (widget.customTip != null) {
      _currentMessage = widget.customTip!;
      _isSpeechBubbleVisible = true;
    }
  }

  @override
  void dispose() {
    _idleController.dispose();
    _blinkController.dispose();
    _mouthController.dispose();
    _feedController.dispose();
    super.dispose();
  }

  void _onFrogTapped() async {
    // Quick blink and mouth open
    _blinkController.forward().then((_) => _blinkController.reverse());
    await _mouthController.forward();
    await _audioFx.playFrogRibbit();
    await Future.delayed(const Duration(milliseconds: 400));
    await _mouthController.reverse();

    setState(() {
      _isSpeechBubbleVisible = true;
      _tipIndex = (_tipIndex + 1) % _tips.length;
      _currentMessage = _tips[_tipIndex];
    });
  }

  void _feedCandy() async {
    if (_isEating) return;
    setState(() {
      _isEating = true;
      _isSpeechBubbleVisible = true;
      _currentMessage = "Mmm! Yummy candy! 🍬 Chomp chomp!";
    });

    // Open mouth wide
    _mouthController.forward();
    _feedController.forward(from: 0.0);

    await Future.delayed(const Duration(milliseconds: 500));
    // Snap mouth shut
    _mouthController.reverse();
    await _audioFx.playFrogChomp();

    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _isEating = false;
        _currentMessage = "Ribbit! That gave me lots of brain energy! ⚡";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.compact ? 80.0 : 110.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Speech Bubble
        if (_isSpeechBubbleVisible) ...[
          GestureDetector(
            onTap: () => setState(() => _isSpeechBubbleVisible = false),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8, right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              constraints: const BoxConstraints(maxWidth: 220),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF58CC02), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      _currentMessage,
                      style: GoogleFonts.fredoka(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF132A13),
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.close_rounded, size: 14, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],

        // Frog + Feed Button Row
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Feed Candy Pill Button
            GestureDetector(
              onTap: _feedCandy,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12, right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF8F00).withValues(alpha: 0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🍬', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      'Feed',
                      style: GoogleFonts.fredoka(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Animated Frog Body
            GestureDetector(
              onTap: _onFrogTapped,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _idleController,
                  _blinkController,
                  _mouthController,
                  _feedController,
                ]),
                builder: (context, child) {
                  final breatheScale = 1.0 + (_idleController.value * 0.05);
                  final breatheDy = math.sin(_idleController.value * math.pi) * 3.0;

                  return Transform.translate(
                    offset: Offset(0, breatheDy),
                    child: Transform.scale(
                      scale: breatheScale,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Falling Candy Animation during feed
                          if (_isEating && _feedController.value < 0.85)
                            Positioned(
                              top: -20 + (_feedController.value * 45),
                              child: Opacity(
                                opacity: (1.0 - _feedController.value).clamp(0.0, 1.0),
                                child: const Text('🍬', style: TextStyle(fontSize: 22)),
                              ),
                            ),

                          // Vector Om-Nom Style Frog
                          CustomPaint(
                            size: Size(size, size * 0.95),
                            painter: _FrogPainter(
                              blinkProgress: _blinkController.value,
                              mouthOpenProgress: _mouthController.value,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Custom Canvas Painter rendering an adorable Om-Nom style green frog
class _FrogPainter extends CustomPainter {
  final double blinkProgress; // 0.0 (open) to 1.0 (closed)
  final double mouthOpenProgress; // 0.0 (closed) to 1.0 (wide open)

  _FrogPainter({
    required this.blinkProgress,
    required this.mouthOpenProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Soft Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.92), width: w * 0.78, height: h * 0.2),
      shadowPaint,
    );

    // 2. Cute Little Feet
    final footPaint = Paint()..color = const Color(0xFF4CAE02);
    // Left Foot
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.28, h * 0.88), width: w * 0.22, height: h * 0.14),
      footPaint,
    );
    // Right Foot
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.72, h * 0.88), width: w * 0.22, height: h * 0.14),
      footPaint,
    );

    // 3. Plump Round Green Body
    final bodyRect = Rect.fromCenter(center: Offset(w * 0.5, h * 0.55), width: w * 0.82, height: h * 0.65);
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF7DE619), Color(0xFF55B308)],
      ).createShader(bodyRect);
    canvas.drawOval(bodyRect, bodyPaint);

    // Darker bottom rim for 3D depth
    final rimPaint = Paint()
      ..color = const Color(0xFF3B8502)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawOval(bodyRect, rimPaint);

    // 4. Light Green Tummy Patch
    final tummyRect = Rect.fromCenter(center: Offset(w * 0.5, h * 0.66), width: w * 0.52, height: h * 0.38);
    final tummyPaint = Paint()..color = const Color(0xFFA6FA4E).withValues(alpha: 0.6);
    canvas.drawOval(tummyRect, tummyPaint);

    // 5. Big Expressive Cartoon Eyes (on top of head like Om Nom)
    final eyeRadius = w * 0.19;
    final eyeY = h * 0.28;

    // Eye sockets (green arches)
    final socketPaint = Paint()..color = const Color(0xFF6ED412);
    canvas.drawCircle(Offset(w * 0.35, eyeY), eyeRadius + 2.5, socketPaint);
    canvas.drawCircle(Offset(w * 0.65, eyeY), eyeRadius + 2.5, socketPaint);

    // Sclera (White)
    final eyeWhitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * 0.35, eyeY), eyeRadius, eyeWhitePaint);
    canvas.drawCircle(Offset(w * 0.65, eyeY), eyeRadius, eyeWhitePaint);

    // Eye outline
    final eyeOutlinePaint = Paint()
      ..color = const Color(0xFF2E6B01)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(w * 0.35, eyeY), eyeRadius, eyeOutlinePaint);
    canvas.drawCircle(Offset(w * 0.65, eyeY), eyeRadius, eyeOutlinePaint);

    // Pupils (Glossy Black with Highlights)
    if (blinkProgress > 0.6) {
      // Closed / Blinking Eyes (Happy arcs)
      final blinkLinePaint = Paint()
        ..color = const Color(0xFF1E3A0B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCenter(center: Offset(w * 0.35, eyeY), width: eyeRadius * 1.4, height: eyeRadius * 0.8),
        0.2,
        math.pi - 0.4,
        false,
        blinkLinePaint,
      );
      canvas.drawArc(
        Rect.fromCenter(center: Offset(w * 0.65, eyeY), width: eyeRadius * 1.4, height: eyeRadius * 0.8),
        0.2,
        math.pi - 0.4,
        false,
        blinkLinePaint,
      );
    } else {
      final pupilPaint = Paint()..color = const Color(0xFF111827);
      final pupilRadius = eyeRadius * 0.52;
      // Looking slightly down/forward
      canvas.drawCircle(Offset(w * 0.36, eyeY + 1), pupilRadius, pupilPaint);
      canvas.drawCircle(Offset(w * 0.64, eyeY + 1), pupilRadius, pupilPaint);

      // White Sparkle Highlights
      final highlightPaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(w * 0.33, eyeY - 2), pupilRadius * 0.38, highlightPaint);
      canvas.drawCircle(Offset(w * 0.61, eyeY - 2), pupilRadius * 0.38, highlightPaint);
      canvas.drawCircle(Offset(w * 0.39, eyeY + 3), pupilRadius * 0.18, highlightPaint);
      canvas.drawCircle(Offset(w * 0.67, eyeY + 3), pupilRadius * 0.18, highlightPaint);
    }

    // 6. Expressive Mouth (Om-Nom style open/closed)
    final mouthY = h * 0.54;

    if (mouthOpenProgress > 0.1) {
      // Wide open smiling mouth cavity
      final mouthWidth = w * 0.58;
      final mouthHeight = (h * 0.30) * mouthOpenProgress;

      final cavityRect = Rect.fromCenter(
        center: Offset(w * 0.5, mouthY + (mouthHeight * 0.3)),
        width: mouthWidth,
        height: mouthHeight,
      );

      // Dark red/pink mouth inside
      final cavityPaint = Paint()..color = const Color(0xFF6A0D18);
      canvas.drawRRect(RRect.fromRectAndRadius(cavityRect, const Radius.circular(20)), cavityPaint);

      // Pink Tongue
      final tonguePaint = Paint()..color = const Color(0xFFFF5277);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(w * 0.5, cavityRect.bottom - (mouthHeight * 0.2)),
          width: mouthWidth * 0.6,
          height: mouthHeight * 0.45,
        ),
        tonguePaint,
      );

      // Tiny Cute Top Teeth (Om Nom style 2 tiny rounded teeth)
      final toothPaint = Paint()..color = Colors.white;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.42, cavityRect.top, w * 0.07, mouthHeight * 0.25),
          const Radius.circular(3),
        ),
        toothPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.51, cavityRect.top, w * 0.07, mouthHeight * 0.25),
          const Radius.circular(3),
        ),
        toothPaint,
      );

      // Mouth outline
      final mouthOutline = Paint()
        ..color = const Color(0xFF2E6B01)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawRRect(RRect.fromRectAndRadius(cavityRect, const Radius.circular(20)), mouthOutline);
    } else {
      // Cute Closed Smile
      final smilePaint = Paint()
        ..color = const Color(0xFF1E3A0B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;

      final smilePath = Path()
        ..moveTo(w * 0.32, mouthY)
        ..quadraticBezierTo(w * 0.5, mouthY + 12, w * 0.68, mouthY);
      canvas.drawPath(smilePath, smilePaint);

      // Cheerful cheek dimples
      final dimplePaint = Paint()
        ..color = const Color(0xFFFF8FA3).withValues(alpha: 0.65);
      canvas.drawCircle(Offset(w * 0.26, mouthY - 2), w * 0.06, dimplePaint);
      canvas.drawCircle(Offset(w * 0.74, mouthY - 2), w * 0.06, dimplePaint);
    }

    // 7. Little Resting Hands
    final handPaint = Paint()..color = const Color(0xFF6ED412);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.24, h * 0.64), width: w * 0.12, height: h * 0.10),
      handPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.76, h * 0.64), width: w * 0.12, height: h * 0.10),
      handPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _FrogPainter oldDelegate) {
    return oldDelegate.blinkProgress != blinkProgress ||
        oldDelegate.mouthOpenProgress != mouthOpenProgress;
  }
}
