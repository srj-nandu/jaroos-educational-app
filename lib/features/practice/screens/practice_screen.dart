import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/audio_fx_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/learning_provider.dart';
import '../../common/widgets/frog_assistant_widget.dart';

class PracticeCategory {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final Color themeColor;
  final String route;
  final String tag;

  const PracticeCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.themeColor,
    required this.route,
    required this.tag,
  });
}

/// Dedicated Gamified Practice Hub Screen for JAROOS.
/// Features:
/// - Daily XP Boost hero card (⚡ 2X XP active)
/// - Tactile 3D category practice tiles
/// - Heart lives and streak capsules
/// - Cut-the-Rope Frog Assistant ("Froggo") cheering the child on!
class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  static const List<PracticeCategory> _categories = [
    PracticeCategory(
      id: 'alphabet',
      title: 'Alphabet & Phonics',
      subtitle: 'Letter sounds, phonics & words',
      icon: '🔤',
      themeColor: Color(0xFF58CC02),
      route: AppRoutes.alphabet,
      tag: 'Phonics',
    ),
    PracticeCategory(
      id: 'numbers',
      title: 'Numbers & Counting',
      subtitle: 'Count 1 to 20 with shining stars',
      icon: '🔢',
      themeColor: Color(0xFFFF9600),
      route: AppRoutes.numbers,
      tag: 'Math',
    ),
    PracticeCategory(
      id: 'colors',
      title: 'Colors & Rainbows',
      subtitle: 'Color mixing and visual shades',
      icon: '🎨',
      themeColor: Color(0xFFE11D48),
      route: AppRoutes.colors,
      tag: 'Art',
    ),
    PracticeCategory(
      id: 'shapes',
      title: 'Shapes & Patterns',
      subtitle: 'Geometry, sides & corners',
      icon: '🔷',
      themeColor: Color(0xFF0284C7),
      route: AppRoutes.shapes,
      tag: 'Geometry',
    ),
    PracticeCategory(
      id: 'animals',
      title: 'Wild Animals & Safari',
      subtitle: 'Animal calls, roar & habitats',
      icon: '🦁',
      themeColor: Color(0xFFD97706),
      route: AppRoutes.animals,
      tag: 'Nature',
    ),
    PracticeCategory(
      id: 'fruits',
      title: 'Fruits & Veggies',
      subtitle: 'Nutritious foods & healthy tastes',
      icon: '🍎',
      themeColor: Color(0xFF16A34A),
      route: AppRoutes.fruits,
      tag: 'Health',
    ),
    PracticeCategory(
      id: 'stories',
      title: 'Bedtime Stories & Sound FX',
      subtitle: 'Classic moral stories with audio FX',
      icon: '📖',
      themeColor: Color(0xFF7C3AED),
      route: AppRoutes.stories,
      tag: 'Reading',
    ),
    PracticeCategory(
      id: 'rhymes',
      title: 'Sing-Along Rhymes',
      subtitle: 'Catchy nursery rhymes and lyrics',
      icon: '🎵',
      themeColor: Color(0xFFDB2777),
      route: AppRoutes.rhymes,
      tag: 'Music',
    ),
    PracticeCategory(
      id: 'quiz',
      title: 'Speed Quiz Arena',
      subtitle: 'Earn stars & challenge your timer',
      icon: '🏆',
      themeColor: Color(0xFFCA8A04),
      route: AppRoutes.quiz,
      tag: 'Arena',
    ),
    PracticeCategory(
      id: 'ai_buddy',
      title: 'Sparky AI STEM Buddy',
      subtitle: 'Ask curious questions to Sparky',
      icon: '🤖',
      themeColor: Color(0xFF0D9488),
      route: AppRoutes.aiBuddy,
      tag: 'AI',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final learning = context.watch<LearningProvider>();
    final coins = learning.coins;
    final streak = learning.streakDays;
    final audioFx = AudioFxService();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FCF2),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Top Bar: Title + Capsules
                  Row(
                    children: [
                      Text(
                        'Practice Hub',
                        style: GoogleFonts.fredoka(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF132A13),
                        ),
                      ),
                      const Spacer(),

                      // Streak Capsule
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text(
                              '$streak',
                              style: GoogleFonts.fredoka(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFE65100),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Gems Capsule
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Text('💎', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text(
                              '$coins',
                              style: GoogleFonts.fredoka(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFE65100),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // 2. Daily XP Boost Hero Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.forestGreenDark,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF9600),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '⚡ 2X XP BOOST',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '15 min left',
                                    style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Daily Practice Warm-Up',
                                style: GoogleFonts.fredoka(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Strengthen your memory and earn double reward gems!',
                                style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Start Warmup Tactile Button
                        GestureDetector(
                          onTap: () {
                            audioFx.playClick();
                            Navigator.pushNamed(context, AppRoutes.quiz);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.duolingoLime,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.duolingoLimeDark,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              'Start',
                              style: GoogleFonts.fredoka(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 3. Category Grid Header
                  Text(
                    'Practice Workstations 🎯',
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF132A13),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 4. Practice Cards List
                  for (final item in _categories) ...[
                    _buildPracticeCard(context, item, audioFx),
                    const SizedBox(height: 14),
                  ],

                  const SizedBox(height: 90),
                ],
              ),
            ),

            // Embedded Frog Assistant
            Positioned(
              bottom: 16,
              right: 16,
              child: const FrogAssistantWidget(
                compact: true,
                customTip: "Ribbit! Practice makes champions! 🌟",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeCard(
    BuildContext context,
    PracticeCategory item,
    AudioFxService audioFx,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            audioFx.playClick();
            Navigator.pushNamed(context, item.route);
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon Avatar
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: item.themeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(item.icon, style: const TextStyle(fontSize: 26)),
                  ),
                ),

                const SizedBox(width: 14),

                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: GoogleFonts.fredoka(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1F2937),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: item.themeColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.tag,
                              style: GoogleFonts.nunito(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: item.themeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Tactile 3D Play Circle
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.duolingoLime,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.duolingoLimeDark,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
