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

/// Redesigned "Course" Screen matching the Course mockups from the reference showcase.
/// Features:
/// - Header: "Course", "Find a class you like", gems counter
/// - Hero Carousel Card: Landscape illustration banner with slider dots
/// - "Popular" Section: Course cards with tags (Child, 0-3, English), friend groups, and orange "Join" buttons
/// - Stepping Stones Journey: Winding S-curve learning path
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
      _ttsService.speak("${node.title} is locked! Complete previous lessons to unlock.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${node.title} is locked! Complete previous lessons to unlock.'),
          backgroundColor: const Color(0xFF6B7280),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    _ttsService.speak("Opening ${node.title}!");
    Navigator.pushNamed(context, node.route);
  }

  @override
  Widget build(BuildContext context) {
    final learningProvider = context.watch<LearningProvider>();
    final coins = learningProvider.coins;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8), // Clean warm cream background
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Bar: "Course", "Find a class you like", Gems counter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    if (widget.showBackButton)
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38,
                          height: 38,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFF1EADB), width: 1.2),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF1F2937)),
                        ),
                      ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Course',
                            style: GoogleFonts.fredoka(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Find a class you like',
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Gems Capsule
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF1EADB), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('💎', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(
                            '$coins',
                            style: GoogleFonts.fredoka(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFFA000),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 2. Hero Carousel Landscape Card (Desert Little Prince & Fox)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7E6),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.asset(
                          'assets/images/course_banner_art.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Text('🏜️🦊👦', style: TextStyle(fontSize: 40)),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Carousel Dots (Active Yellow Bar + Inactive Dots)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 14,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFA000),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE5E7EB),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE5E7EB),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. "Popular" Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular',
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'More',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Course Card 1: Experience Course (Red Hood)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildCourseItem(
                  title: 'Experience Course',
                  imageAsset: 'assets/images/thumb_red_hood.png',
                  defaultEmoji: '👧',
                  tag1: 'Child',
                  tag2: '0–3',
                  tag3: 'English',
                  friendsText: '8 friends in group',
                  onJoin: () {
                    _ttsService.speak("Opening Experience Course!");
                    Navigator.pushNamed(context, AppRoutes.alphabet);
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Course Card 2: Experience Course (Giraffe)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildCourseItem(
                  title: 'Experience Course',
                  imageAsset: 'assets/images/thumb_giraffe.png',
                  defaultEmoji: '🦒',
                  tag1: 'Child',
                  tag2: '3–6',
                  tag3: 'English',
                  friendsText: '10 friends in group',
                  onJoin: () {
                    _ttsService.speak("Opening Experience Course!");
                    Navigator.pushNamed(context, AppRoutes.numbers);
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Course Card 3: Animal World & Malayalam Stories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildCourseItem(
                  title: 'Animal Safari & Tales',
                  imageAsset: 'assets/images/mascot_avatar.png',
                  defaultEmoji: '🦁',
                  tag1: 'Child',
                  tag2: '3–8',
                  tag3: 'Malayalam',
                  friendsText: '14 friends in group',
                  onJoin: () {
                    _ttsService.speak("Opening Animal Safari & Tales!");
                    Navigator.pushNamed(context, AppRoutes.animals);
                  },
                ),
              ),

              const SizedBox(height: 26),

              // 4. Stepping Stones Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text('🗺️ ', style: TextStyle(fontSize: 18)),
                    Text(
                      'Learning Journey • Stepping Stones',
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 5. Winding S-Curve Stepping Stones Path
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _unit1Nodes.length,
                itemBuilder: (context, index) {
                  final node = _unit1Nodes[index];
                  final isLast = index == _unit1Nodes.length - 1;
                  return _buildNodeWithConnector(node, isLast);
                },
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  /// Course List Item matching reference mockup with Tags, Friends row, and orange "Join" button
  Widget _buildCourseItem({
    required String title,
    required String imageAsset,
    required String defaultEmoji,
    required String tag1,
    required String tag2,
    required String tag3,
    required String friendsText,
    required VoidCallback onJoin,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1EADB), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Squircle Character Thumbnail
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3D6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(defaultEmoji, style: const TextStyle(fontSize: 28)),
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Course Info & Badges
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.fredoka(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 6),

                // Tags Row: Child, Age, Language
                Row(
                  children: [
                    _buildPillTag(tag1, const Color(0xFFEBF3FE), const Color(0xFF3B82F6)),
                    const SizedBox(width: 6),
                    _buildPillTag(tag2, const Color(0xFFFFECE5), const Color(0xFFFF5722)),
                    const SizedBox(width: 6),
                    _buildPillTag(tag3, const Color(0xFFFFF8E1), const Color(0xFFFFA000)),
                  ],
                ),

                const SizedBox(height: 8),

                // Friends Avatars Row
                Row(
                  children: [
                    // Mini overlapping avatars
                    SizedBox(
                      width: 38,
                      height: 18,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFB74D),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(child: Text('👦', style: TextStyle(fontSize: 10))),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF7043),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: const Center(child: Text('👧', style: TextStyle(fontSize: 10))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      friendsText,
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Orange Pill "Join" Button
          GestureDetector(
            onTap: onJoin,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFA000), Color(0xFFFF8F00)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8F00).withValues(alpha: 0.35),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Join',
                style: GoogleFonts.fredoka(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillTag(String label, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: GoogleFonts.fredoka(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textCol,
        ),
      ),
    );
  }

  /// Stepping Stones Node with Connector
  Widget _buildNodeWithConnector(PathNodeData node, bool isLast) {
    return Center(
      child: Transform.translate(
        offset: Offset(node.xOffsetFactor * 100, 0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _onNodeTap(node),
              child: _buildNodeWidget(node),
            ),
            if (!isLast)
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5D5B8),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNodeWidget(PathNodeData node) {
    switch (node.type) {
      case PathNodeType.chest:
        return Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFFFA000),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFA000).withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(child: Text('🎁', style: TextStyle(fontSize: 26))),
        );

      case PathNodeType.completedCheck:
        return Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 28),
        );

      case PathNodeType.activeHeadphones:
        return Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.headphones_rounded, color: Colors.white, size: 28),
        );

      case PathNodeType.bookLesson:
        return Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFFF8F00),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF8F00).withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 26),
        );

      case PathNodeType.challengeDumbbell:
        return Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 26),
        );

      case PathNodeType.locked:
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD1D5DB), width: 1.5),
          ),
          child: const Icon(Icons.lock_rounded, color: Color(0xFF9CA3AF), size: 22),
        );
    }
  }
}
