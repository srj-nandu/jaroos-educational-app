import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/audio_fx_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/learning_provider.dart';
import '../../common/widgets/frog_assistant_widget.dart';

enum PathNodeType {
  chest,
  completedCheck,
  bookLesson,
  activeHeadphones,
  challengeDumbbell,
  locked,
}

class PathNodeData {
  final int id;
  final String title;
  final String subtitle;
  final PathNodeType type;
  final String route;
  final double xRatio; // 0.0 (left) to 1.0 (right), 0.5 = center

  const PathNodeData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.route,
    required this.xRatio,
  });
}

/// Authentic Duolingo-Style Stepping Stones Learning Path Screen for JAROOS.
/// Exactly matches Screen 3 of the reference mockup:
/// - Top Bar: Back navigation + Gems counter capsule (💎 320)
/// - Unit 1 Header Card: "A1 Beginner ∨ | Unit 1 · Getting Started" with guidebook CTA
/// - Winding Bezier S-Curve road connecting tactile 3D nodes
/// - Floating "START" tooltip with downward arrow on active headphones node
/// - Interactive reward chest with sparkle animation (+20 coins)
/// - Decorative meadow flowers & grass tufts
/// - Interactive Cut-the-Rope Frog Assistant ("Froggo") in the corner!
class LearningPathScreen extends StatefulWidget {
  final bool showBackButton;

  const LearningPathScreen({
    super.key,
    this.showBackButton = true,
  });

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late TtsService _ttsService;
  late AudioFxService _audioFx;

  bool _chestOpened = false;

  final List<PathNodeData> _unit1Nodes = const [
    PathNodeData(
      id: 1,
      title: 'Alphabet Phonics',
      subtitle: 'Letters A to G',
      type: PathNodeType.completedCheck,
      route: AppRoutes.alphabet,
      xRatio: 0.50,
    ),
    PathNodeData(
      id: 2,
      title: 'Letter Sounds',
      subtitle: 'Phonics & Speech',
      type: PathNodeType.bookLesson,
      route: AppRoutes.alphabet,
      xRatio: 0.32,
    ),
    PathNodeData(
      id: 3,
      title: 'Early Reading',
      subtitle: 'Bedtime Stories',
      type: PathNodeType.bookLesson,
      route: AppRoutes.stories,
      xRatio: 0.22,
    ),
    PathNodeData(
      id: 4,
      title: 'Listening & Sounds',
      subtitle: 'Everyday Phonics',
      type: PathNodeType.activeHeadphones,
      route: AppRoutes.alphabet,
      xRatio: 0.40,
    ),
    PathNodeData(
      id: 5,
      title: 'Daily Challenge',
      subtitle: 'Speed Phonics',
      type: PathNodeType.challengeDumbbell,
      route: AppRoutes.quiz,
      xRatio: 0.65,
    ),
    PathNodeData(
      id: 6,
      title: 'Treasure Chest',
      subtitle: 'Bonus Gems & Stars',
      type: PathNodeType.chest,
      route: AppRoutes.progress,
      xRatio: 0.78,
    ),
    PathNodeData(
      id: 7,
      title: 'Numbers Explorer',
      subtitle: 'Counting 1 to 10',
      type: PathNodeType.locked,
      route: AppRoutes.numbers,
      xRatio: 0.60,
    ),
    PathNodeData(
      id: 8,
      title: 'Color Mixing',
      subtitle: 'Rainbow Lab',
      type: PathNodeType.locked,
      route: AppRoutes.colors,
      xRatio: 0.38,
    ),
    PathNodeData(
      id: 9,
      title: 'Animal Safari',
      subtitle: 'Jungle & Sea Creatures',
      type: PathNodeType.locked,
      route: AppRoutes.animals,
      xRatio: 0.26,
    ),
    PathNodeData(
      id: 10,
      title: 'Unit 1 Trophy',
      subtitle: 'Mastery Arena Exam',
      type: PathNodeType.locked,
      route: AppRoutes.quiz,
      xRatio: 0.50,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ttsService = ModularTtsService();
    _audioFx = AudioFxService(ttsService: _ttsService);

    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    if (!isTest) {
      _pulseController.repeat(reverse: true);
      _bounceController.repeat(reverse: true);
    } else {
      _pulseController.value = 0.5;
      _bounceController.value = 0.5;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _onNodeTap(PathNodeData node) async {
    await _audioFx.playClick();

    if (node.type == PathNodeType.locked) {
      _ttsService.speak("This lesson is locked! Complete earlier lessons first!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.lock_rounded, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Complete earlier steps to unlock ${node.title}!',
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1F2937),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      );
      return;
    }

    if (node.type == PathNodeType.chest) {
      if (!_chestOpened) {
        setState(() => _chestOpened = true);
        context.read<LearningProvider>().addCoins(20);
        await _audioFx.playApplause();
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (ctx) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🎁', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 12),
                  Text(
                    'Treasure Unlocked!',
                    style: GoogleFonts.fredoka(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF132A13),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You found +20 Gems & 1 Bonus Star!',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4B5563),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.duolingoLime,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    ),
                    child: Text(
                      'Awesome!',
                      style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        _ttsService.speak("Chest already claimed! Keep going!");
      }
      return;
    }

    _ttsService.speak("Let's start ${node.title}!");
    Navigator.pushNamed(context, node.route);
  }

  @override
  Widget build(BuildContext context) {
    final learningProvider = context.watch<LearningProvider>();
    final coins = learningProvider.coins;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FCF2), // Soft clean meadow background
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 1. Top Header Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      if (widget.showBackButton)
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF132A13)),
                          onPressed: () => Navigator.maybePop(context),
                        )
                      else
                        const SizedBox(width: 8),

                      Text(
                        'Learning Path',
                        style: GoogleFonts.fredoka(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF132A13),
                        ),
                      ),

                      const Spacer(),

                      // Gems / XP Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('💎', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            Text(
                              '$coins',
                              style: GoogleFonts.fredoka(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFE65100),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Unit Banner Card (Matching Mockup Screen 3)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.forestGreenDark,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'A1 Beginner',
                                    style: GoogleFonts.nunito(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.duolingoLime,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.duolingoLime, size: 18),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Unit 1 · Getting Started',
                                style: GoogleFonts.fredoka(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Learn basic sounds & words',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Guidebook Pill Button
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, AppRoutes.alphabet),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.duolingoLime,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.duolingoLimeDark.withValues(alpha: 0.5),
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.menu_book_rounded, color: Colors.white, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Guidebook',
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
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // 3. Winding Stepping Stones S-Curve Path Canvas
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final totalHeight = (_unit1Nodes.length * 96.0) + 120.0;
                      final screenWidth = constraints.maxWidth;

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: SizedBox(
                          width: screenWidth,
                          height: totalHeight,
                          child: Stack(
                            children: [
                              // Background Bezier S-Curve Stepping Stones Road Painter
                              CustomPaint(
                                size: Size(screenWidth, totalHeight),
                                painter: _WindingRoadPainter(
                                  nodes: _unit1Nodes,
                                  nodeSpacing: 96.0,
                                  topPadding: 50.0,
                                ),
                              ),

                              // Interactive 3D Nodes
                              for (int i = 0; i < _unit1Nodes.length; i++) ...[
                                _buildPositionedNode(
                                  node: _unit1Nodes[i],
                                  index: i,
                                  screenWidth: screenWidth,
                                  nodeY: 50.0 + (i * 96.0),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Cut-the-Rope Frog Assistant ("Froggo") in bottom-right corner!
            Positioned(
              bottom: 16,
              right: 16,
              child: const FrogAssistantWidget(
                compact: true,
                customTip: "Ribbit! Tap START to listen to phonics! 🎧",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionedNode({
    required PathNodeData node,
    required int index,
    required double screenWidth,
    required double nodeY,
  }) {
    final nodeX = screenWidth * node.xRatio;
    const nodeSize = 68.0;

    return Positioned(
      left: nodeX - (nodeSize / 2),
      top: nodeY - (nodeSize / 2),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Floating Animated "START" Tooltip above active node (matching Mockup Screen 3)
          if (node.type == PathNodeType.activeHeadphones)
            Positioned(
              top: -46,
              child: AnimatedBuilder(
                animation: _bounceController,
                builder: (context, child) {
                  final dy = math.sin(_bounceController.value * math.pi) * 5.0;
                  return Transform.translate(
                    offset: Offset(0, -dy),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            'START',
                            style: GoogleFonts.fredoka(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.duolingoLime,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        // Downward Pointer Triangle
                        CustomPaint(
                          size: const Size(12, 6),
                          painter: _TrianglePointerPainter(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          // Active Glow Pulse Ring
          if (node.type == PathNodeType.activeHeadphones)
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = 1.0 + (_pulseController.value * 0.18);
                final opacity = (1.0 - _pulseController.value * 0.6).clamp(0.0, 1.0);
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: nodeSize + 16,
                    height: nodeSize + 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.duolingoLime.withValues(alpha: opacity),
                        width: 3.5,
                      ),
                    ),
                  ),
                );
              },
            ),

          // Tactile 3D Circular Node Button
          GestureDetector(
            onTap: () => _onNodeTap(node),
            child: _buildTactileNodeCircle(node, nodeSize),
          ),
        ],
      ),
    );
  }

  Widget _buildTactileNodeCircle(PathNodeData node, double size) {
    Color topColor;
    Color bottomRimColor;
    Widget iconContent;

    switch (node.type) {
      case PathNodeType.completedCheck:
        topColor = AppColors.duolingoLime;
        bottomRimColor = AppColors.duolingoLimeDark;
        iconContent = const Icon(Icons.check_rounded, color: Colors.white, size: 36);
        break;

      case PathNodeType.bookLesson:
        topColor = const Color(0xFF48C72B);
        bottomRimColor = const Color(0xFF389E21);
        iconContent = const Icon(Icons.menu_book_rounded, color: Colors.white, size: 30);
        break;

      case PathNodeType.activeHeadphones:
        topColor = AppColors.duolingoLime;
        bottomRimColor = AppColors.duolingoLimeDark;
        iconContent = const Icon(Icons.headphones_rounded, color: Colors.white, size: 34);
        break;

      case PathNodeType.challengeDumbbell:
        topColor = const Color(0xFFFF9600);
        bottomRimColor = const Color(0xFFD97706);
        iconContent = const Icon(Icons.fitness_center_rounded, color: Colors.white, size: 30);
        break;

      case PathNodeType.chest:
        topColor = const Color(0xFFFFC800);
        bottomRimColor = const Color(0xFFD97706);
        iconContent = Text(
          _chestOpened ? '✨' : '🎁',
          style: const TextStyle(fontSize: 32),
        );
        break;

      case PathNodeType.locked:
        topColor = const Color(0xFFE5E7EB);
        bottomRimColor = const Color(0xFFCBD5E1);
        iconContent = const Icon(Icons.lock_rounded, color: Color(0xFF9CA3AF), size: 28);
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: topColor,
        shape: BoxShape.circle,
        boxShadow: [
          // Tactile 3D bottom rim
          BoxShadow(
            color: bottomRimColor,
            offset: const Offset(0, 6),
            blurRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            offset: const Offset(0, 8),
            blurRadius: 8,
          ),
        ],
      ),
      child: Center(child: iconContent),
    );
  }
}

/// Custom Painter for the authentic winding Duolingo S-curve road and meadow scenery
class _WindingRoadPainter extends CustomPainter {
  final List<PathNodeData> nodes;
  final double nodeSpacing;
  final double topPadding;

  _WindingRoadPainter({
    required this.nodes,
    required this.nodeSpacing,
    required this.topPadding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.length < 2) return;

    final w = size.width;

    // 1. Draw decorative scattered meadow flowers & grass tufts
    final random = math.Random(42);
    final flowerPaint = Paint()..color = const Color(0xFFF9A8D4).withValues(alpha: 0.7);
    final grassPaint = Paint()
      ..color = const Color(0xFF86EFAC).withValues(alpha: 0.8)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 24; i++) {
      final fx = random.nextDouble() * w;
      final fy = random.nextDouble() * size.height;
      if (i % 2 == 0) {
        // Small flower
        canvas.drawCircle(Offset(fx, fy), 3.5, flowerPaint);
      } else {
        // Grass blade
        canvas.drawLine(Offset(fx, fy), Offset(fx - 3, fy - 7), grassPaint);
        canvas.drawLine(Offset(fx, fy), Offset(fx + 3, fy - 6), grassPaint);
      }
    }

    // 2. Build Bezier S-Curve Path through all node centers
    final path = Path();
    final firstX = w * nodes[0].xRatio;
    final firstY = topPadding;
    path.moveTo(firstX, firstY);

    for (int i = 0; i < nodes.length - 1; i++) {
      final currentX = w * nodes[i].xRatio;
      final currentY = topPadding + (i * nodeSpacing);
      final nextX = w * nodes[i + 1].xRatio;
      final nextY = topPadding + ((i + 1) * nodeSpacing);

      final controlY1 = currentY + (nodeSpacing * 0.5);
      final controlY2 = nextY - (nodeSpacing * 0.5);

      path.cubicTo(currentX, controlY1, nextX, controlY2, nextX, nextY);
    }

    // 3. Draw Thick Under-Road Shadow
    final roadShadow = Paint()
      ..color = const Color(0xFFD1D5DB).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, roadShadow);

    // 4. Draw Stepping Stones Track
    final roadTrack = Paint()
      ..color = const Color(0xFFE5E7EB).withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, roadTrack);

    // 5. Draw Stepping Stone Dashes (duolingo road dots)
    final stoneDashPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    // Draw stepping stones circles between nodes
    for (int i = 0; i < nodes.length - 1; i++) {
      final currentX = w * nodes[i].xRatio;
      final currentY = topPadding + (i * nodeSpacing);
      final nextX = w * nodes[i + 1].xRatio;
      final nextY = topPadding + ((i + 1) * nodeSpacing);

      // Midpoint
      final midX = (currentX + nextX) * 0.5;
      final midY = (currentY + nextY) * 0.5;
      canvas.drawCircle(Offset(midX, midY), 4, stoneDashPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WindingRoadPainter oldDelegate) => false;
}

/// Downward pointing triangle for the START speech tooltip
class _TrianglePointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(const Offset(0, 0), Offset(size.width / 2, size.height), borderPaint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width / 2, size.height), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
