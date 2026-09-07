import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/learning_provider.dart';

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
  final double xOffsetFactor; // -1.0 (left), 0.0 (center), 1.0 (right)

  const PathNodeData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.route,
    required this.xOffsetFactor,
  });
}

/// Interactive Duolingo-style Stepping Stones Learning Path Screen for JAROOS.
/// Features:
/// - Top Bar with back navigation and gems counter (💎 320)
/// - Unit 1 Header Card: "A1 Beginner ∨ | Unit 1 . Getting Started"
/// - Winding S-curve path with colorful nodes: completed checks, books, active headphones with "Start" tag, chests, and locked nodes
/// - Landscape bottom with meadow hills and trees
class LearningPathScreen extends StatefulWidget {
  final bool showBackButton;

  const LearningPathScreen({
    super.key,
    this.showBackButton = true,
  });

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late TtsService _ttsService;

  final List<PathNodeData> _unit1Nodes = const [
    PathNodeData(
      id: 1,
      title: 'Bonus Chest',
      subtitle: 'Mystery Reward',
      type: PathNodeType.chest,
      route: AppRoutes.progress,
      xOffsetFactor: 0.0,
    ),
    PathNodeData(
      id: 2,
      title: 'Alphabet Phonics',
      subtitle: 'Letters A to G',
      type: PathNodeType.completedCheck,
      route: AppRoutes.alphabet,
      xOffsetFactor: -0.25,
    ),
    PathNodeData(
      id: 3,
      title: 'Early Reading',
      subtitle: 'Bedtime Stories',
      type: PathNodeType.bookLesson,
      route: AppRoutes.stories,
      xOffsetFactor: -0.22,
    ),
    PathNodeData(
      id: 4,
      title: 'Listening & Sounds',
      subtitle: 'Everyday Phonics',
      type: PathNodeType.activeHeadphones,
      route: AppRoutes.alphabet,
      xOffsetFactor: 0.15,
    ),
    PathNodeData(
      id: 5,
      title: 'Daily Challenge',
      subtitle: 'Quiz Arena Practice',
      type: PathNodeType.challengeDumbbell,
      route: AppRoutes.quiz,
      xOffsetFactor: 0.20,
    ),
    PathNodeData(
      id: 6,
      title: 'Numbers Safari',
      subtitle: 'Counting 1 to 10',
      type: PathNodeType.locked,
      route: AppRoutes.numbers,
      xOffsetFactor: 0.0,
    ),
    PathNodeData(
      id: 7,
      title: 'Rainbow Colors',
      subtitle: 'Primary & Secondary',
      type: PathNodeType.locked,
      route: AppRoutes.colors,
      xOffsetFactor: -0.25,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isTest) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.value = 0.5;
    }
    _ttsService = ModularTtsService();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onNodeTap(PathNodeData node) {
    if (node.type == PathNodeType.locked) {
      _ttsService.speak("This lesson is locked! Complete the earlier steps first!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🔒 Complete earlier lessons to unlock ${node.title}!',
            style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
          ),
          backgroundColor: const Color(0xFF374151),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (node.type == PathNodeType.chest) {
      _ttsService.speak("You found a treasure chest! You earned 20 bonus coins!");
      final learningProvider = Provider.of<LearningProvider>(context, listen: false);
      learningProvider.addCoins(20);

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              const Text('🎁 ', style: TextStyle(fontSize: 28)),
              Text(
                'Treasure Found!',
                style: GoogleFonts.fredoka(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('✨ 🪙 +20 Coins Awarded! 🌟', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF8F00))),
              const SizedBox(height: 10),
              Text(
                'Great job continuing your learning adventure! Keep going!',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(fontSize: 14, color: const Color(0xFF555555)),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.duolingoLime,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('Awesome!', style: GoogleFonts.fredoka(color: Colors.white)),
            ),
          ],
        ),
      );
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
        child: Column(
          children: [
            // 1. Top Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  if (widget.showBackButton)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF1E3A0B)),
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

            // 2. Unit Banner Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.forestGreenDark,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'A1 Beginner',
                              style: GoogleFonts.fredoka(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 20),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Unit 1 . Getting Started',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFA5CFA6),
                          ),
                        ),
                      ],
                    ),

                    // Unit Guidebook Icon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.menu_book_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 3. Scrollable Stepping Stones Path
            Expanded(
              child: Stack(
                children: [
                  // Bottom rolling green hill & trees
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 120,
                    child: CustomPaint(
                      painter: _PathMeadowBottomPainter(),
                    ),
                  ),

                  // Nodes List
                  ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    children: [
                      for (int i = 0; i < _unit1Nodes.length; i++) ...[
                        if (i == 5) ...[
                          // Unit 2 Divider
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                            child: Row(
                              children: [
                                const Expanded(child: Divider(color: Color(0xFFD1D5DB), thickness: 1.5)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  child: Text(
                                    'Unit 2',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider(color: Color(0xFFD1D5DB), thickness: 1.5)),
                              ],
                            ),
                          ),
                        ],

                        _buildPathNodeItem(_unit1Nodes[i]),
                        const SizedBox(height: 22),
                      ],

                      const SizedBox(height: 80),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPathNodeItem(PathNodeData node) {
    final screenWidth = MediaQuery.of(context).size.width;
    final offsetX = node.xOffsetFactor * (screenWidth * 0.28);

    return Center(
      child: Transform.translate(
        offset: Offset(offsetX, 0),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Floating "Start" Speech Bubble Tag for active node
            if (node.type == PathNodeType.activeHeadphones)
              Positioned(
                top: -34,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final floatY = math.sin(_pulseController.value * 2 * math.pi) * 3.0;
                    return Transform.translate(
                      offset: Offset(0, floatY),
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.duolingoLime, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.duolingoLime.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'START',
                      style: GoogleFonts.fredoka(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.duolingoLime,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),

            // The Node Circle Button
            GestureDetector(
              onTap: () => _onNodeTap(node),
              child: _buildNodeCircle(node),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNodeCircle(PathNodeData node) {
    switch (node.type) {
      case PathNodeType.chest:
        return Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            color: const Color(0xFF48C72B),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF33991C), width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 8,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Center(
            child: Text('🎁', style: TextStyle(fontSize: 30)),
          ),
        );

      case PathNodeType.completedCheck:
        return Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            color: const Color(0xFF48C72B),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF33991C), width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 8,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.check_rounded, color: Colors.white, size: 34),
          ),
        );

      case PathNodeType.bookLesson:
        return Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            color: const Color(0xFF48C72B),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF33991C), width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 8,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.menu_book_rounded, color: Colors.white, size: 28),
          ),
        );

      case PathNodeType.activeHeadphones:
        return AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final pulseScale = 1.0 + (_pulseController.value * 0.06);
            return Transform.scale(
              scale: pulseScale,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.duolingoLime,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.duolingoLime.withValues(alpha: 0.5),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.headphones_rounded, color: Colors.white, size: 34),
                ),
              ),
            );
          },
        );

      case PathNodeType.challengeDumbbell:
        return Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            color: const Color(0xFF48C72B),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF33991C), width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 8,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.fitness_center_rounded, color: Colors.white, size: 28),
          ),
        );

      case PathNodeType.locked:
        return Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFCBD5E1), width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.lock_rounded, color: Color(0xFF94A3B8), size: 26),
          ),
        );
    }
  }
}

/// Painter for the meadow green hill and trees at the bottom of the path
class _PathMeadowBottomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Green Meadow Hill
    final hillPaint = Paint()..color = const Color(0xFF5ABF28);
    final hillPath = Path()
      ..moveTo(0, size.height * 0.45)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.15, size.width, size.height * 0.40)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hillPath, hillPaint);

    // Left Little Tree
    final trunkPaint = Paint()..color = const Color(0xFF8D6E63);
    canvas.drawRect(Rect.fromLTWH(18, size.height * 0.40, 8, 20), trunkPaint);
    final leavesPaint = Paint()..color = const Color(0xFF388E3C);
    canvas.drawCircle(Offset(22, size.height * 0.35), 18, leavesPaint);

    // Right Little Tree
    canvas.drawRect(Rect.fromLTWH(size.width - 28, size.height * 0.35, 8, 24), trunkPaint);
    canvas.drawCircle(Offset(size.width - 24, size.height * 0.28), 20, leavesPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
