import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

enum MascotMode {
  /// Peeking up from the bottom of the screen (Welcome screen style)
  peekingBottom,

  /// Face looking down from the top (Auth screens style)
  topFace,
}

/// Interactive vector-rendered Lime-Green Monster Mascot for JAROOS.
/// Features big expressive eyes with twin-sparkle highlights, curved eyebrows,
/// cute nostril dots, and a gentle idle blinking animation.
class JaroosMonsterMascot extends StatefulWidget {
  final MascotMode mode;
  final double scale;
  final bool animateBlink;

  const JaroosMonsterMascot({
    super.key,
    this.mode = MascotMode.peekingBottom,
    this.scale = 1.0,
    this.animateBlink = true,
  });

  @override
  State<JaroosMonsterMascot> createState() => _JaroosMonsterMascotState();
}

class _JaroosMonsterMascotState extends State<JaroosMonsterMascot>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _eyeScaleY;
  Timer? _blinkTimer;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _eyeScaleY = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.1), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.1, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    ));

    if (widget.animateBlink) {
      _scheduleNextBlink();
    }
  }

  void _scheduleNextBlink() {
    if (!mounted || !widget.animateBlink) return;
    final delaySeconds = 3 + math.Random().nextInt(4); // 3 to 6 seconds
    _blinkTimer = Timer(Duration(seconds: delaySeconds), () async {
      if (!mounted || !widget.animateBlink) return;
      try {
        await _blinkController.forward();
        if (mounted) {
          await _blinkController.reverse();
        }
      } catch (_) {}
      if (mounted) {
        _scheduleNextBlink();
      }
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _blinkTimer = null;
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPeeking = widget.mode == MascotMode.peekingBottom;

    return AnimatedBuilder(
      animation: _eyeScaleY,
      builder: (context, child) {
        return CustomPaint(
          size: isPeeking ? const Size(360, 200) : const Size(360, 170),
          painter: _MonsterMascotPainter(
            mode: widget.mode,
            eyeScaleY: _eyeScaleY.value,
          ),
        );
      },
    );
  }
}

class _MonsterMascotPainter extends CustomPainter {
  final MascotMode mode;
  final double eyeScaleY;

  _MonsterMascotPainter({
    required this.mode,
    required this.eyeScaleY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final isPeeking = mode == MascotMode.peekingBottom;
    final centerX = size.width / 2;

    final greenPaint = Paint()
      ..color = AppColors.monsterGreen
      ..style = PaintingStyle.fill;

    if (isPeeking) {
      // 1. Draw peeking dome body rising from the bottom
      final bodyPath = Path()
        ..moveTo(0, size.height)
        ..lineTo(0, size.height * 0.55)
        ..cubicTo(
          size.width * 0.15, size.height * 0.05,
          size.width * 0.85, size.height * 0.05,
          size.width, size.height * 0.55,
        )
        ..lineTo(size.width, size.height)
        ..close();

      canvas.drawPath(bodyPath, greenPaint);

      // 2. Draw cute hair tuft at the top
      _drawHairTuft(canvas, Offset(centerX, size.height * 0.15));

      // 3. Draw face elements
      final faceCenterY = size.height * 0.62;
      _drawFace(canvas, centerX, faceCenterY);
    } else {
      // Top face mode (screen header)
      // Draw top hair tuft
      _drawHairTuft(canvas, Offset(centerX, 24));

      // Draw face elements
      const faceCenterY = 96.0;
      _drawFace(canvas, centerX, faceCenterY);
    }
  }

  void _drawHairTuft(Canvas canvas, Offset center) {
    final tuftPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    // A playful double-petal / heart-like crest
    final tuftPath = Path();
    tuftPath.moveTo(center.dx, center.dy);
    tuftPath.cubicTo(
      center.dx - 14, center.dy - 16,
      center.dx - 4, center.dy - 26,
      center.dx, center.dy - 12,
    );
    tuftPath.cubicTo(
      center.dx + 4, center.dy - 26,
      center.dx + 14, center.dy - 16,
      center.dx, center.dy,
    );
    tuftPath.close();

    canvas.drawPath(tuftPath, tuftPaint);
  }

  void _drawFace(Canvas canvas, double centerX, double centerY) {
    const eyeRadiusX = 40.0;
    const eyeRadiusY = 46.0;
    const eyeSpacing = 48.0;

    final leftEyeCenter = Offset(centerX - eyeSpacing, centerY);
    final rightEyeCenter = Offset(centerX + eyeSpacing, centerY);

    // 1. Eyebrows
    final eyebrowPaint = Paint()
      ..color = AppColors.monsterDarkNavy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    // Left eyebrow (curved arc)
    final leftBrowPath = Path();
    leftBrowPath.moveTo(leftEyeCenter.dx - 22, centerY - eyeRadiusY - 14);
    leftBrowPath.quadraticBezierTo(
      leftEyeCenter.dx, centerY - eyeRadiusY - 24,
      leftEyeCenter.dx + 20, centerY - eyeRadiusY - 12,
    );
    canvas.drawPath(leftBrowPath, eyebrowPaint);

    // Right eyebrow (curved arc)
    final rightBrowPath = Path();
    rightBrowPath.moveTo(rightEyeCenter.dx - 20, centerY - eyeRadiusY - 12);
    rightBrowPath.quadraticBezierTo(
      rightEyeCenter.dx, centerY - eyeRadiusY - 24,
      rightEyeCenter.dx + 22, centerY - eyeRadiusY - 14,
    );
    canvas.drawPath(rightBrowPath, eyebrowPaint);

    // 2. Eyes (Big white ovals with blink scale)
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(leftEyeCenter.dx, leftEyeCenter.dy);
    canvas.scale(1.0, eyeScaleY);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: eyeRadiusX * 2, height: eyeRadiusY * 2),
      whitePaint,
    );
    _drawPupil(canvas, Offset.zero);
    canvas.restore();

    canvas.save();
    canvas.translate(rightEyeCenter.dx, rightEyeCenter.dy);
    canvas.scale(1.0, eyeScaleY);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: eyeRadiusX * 2, height: eyeRadiusY * 2),
      whitePaint,
    );
    _drawPupil(canvas, Offset.zero);
    canvas.restore();

    // 3. Nostrils (Two cute vertical dark dots between eyes)
    if (eyeScaleY > 0.4) {
      final nostrilPaint = Paint()
        ..color = AppColors.monsterDarkNavy
        ..style = PaintingStyle.fill;

      canvas.drawOval(
        Rect.fromCenter(center: Offset(centerX - 6, centerY + 28), width: 5.5, height: 8),
        nostrilPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(centerX + 6, centerY + 28), width: 5.5, height: 8),
        nostrilPaint,
      );
    }
  }

  void _drawPupil(Canvas canvas, Offset eyeCenter) {
    // Large deep black pupil
    final pupilPaint = Paint()
      ..color = AppColors.monsterDarkNavy
      ..style = PaintingStyle.fill;

    const pupilRadius = 22.0;
    // Slight inward focus for cute toddler expression
    final pupilCenter = Offset(eyeCenter.dx, eyeCenter.dy + 4);

    canvas.drawCircle(pupilCenter, pupilRadius, pupilPaint);

    // Sparkle 1: Big white circular highlight at top-right
    final sparklePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(pupilCenter.dx + 7, pupilCenter.dy - 7),
      7.5,
      sparklePaint,
    );

    // Sparkle 2: Small white circular highlight at bottom-left
    canvas.drawCircle(
      Offset(pupilCenter.dx - 8, pupilCenter.dy + 8),
      3.5,
      sparklePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MonsterMascotPainter oldDelegate) {
    return oldDelegate.mode != mode || oldDelegate.eyeScaleY != eyeScaleY;
  }
}
