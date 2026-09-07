import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/learning_provider.dart';
import '../../parent/widgets/parent_gate_dialog.dart';

/// Redesigned Modern Learning Dashboard matching Screen 2 of the reference mockup.
/// Features:
/// - Top Bar: Category grid, Streak capsule (🔥 7), Gems capsule (💎 320), Notification bell
/// - Greeting: "Hey, Aria!", "Let's keep your streak going!", circular mascot avatar with sprout badge
/// - 3 Stat Cards: Streak (7 days), XP (320 Total XP), League (Silver Top 12%)
/// - "Continue Learning" Hero Card: Dark forest green container, lesson progress bar, "Continue" button, character companions
/// - "Today's Goal": "Learn for 20 minutes" (12/20 min) with gift box reward
/// - "Quick Practice": Interactive tiles for Alphabet, Numbers, Colors, Animals, and Stories
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TtsService _ttsService;

  @override
  void initState() {
    super.initState();
    _ttsService = ModularTtsService();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final learningProvider = context.watch<LearningProvider>();

    final childName = authProvider.user?.childName ?? 'Aria';
    final coins = learningProvider.coins;
    final streakDays = learningProvider.streakDays;

    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF0), // Gentle light green canvas
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar: Grid, Streak Capsule, Gems Capsule, Bell
              Row(
                children: [
                  // Category Grid Icon
                  _buildCircleIconButton(
                    icon: Icons.grid_view_rounded,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.learningPath),
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 15)),
                        const SizedBox(width: 4),
                        Text(
                          '$streakDays',
                          style: GoogleFonts.fredoka(
                            fontSize: 15,
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('💎', style: TextStyle(fontSize: 15)),
                        const SizedBox(width: 4),
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

                  const SizedBox(width: 8),

                  // Notification / Parent Zone Bell (Protected by Parent Gate)
                  _buildCircleIconButton(
                    icon: Icons.notifications_none_rounded,
                    onTap: () {
                      ParentGateDialog.show(
                        context,
                        onSuccess: () => Navigator.pushNamed(context, AppRoutes.parentDashboard),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 2. Greeting Section: "Hey, Aria!" + Circular Avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hey, $childName! 👋',
                        style: GoogleFonts.fredoka(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF132A13),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Let's keep your streak going!",
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),

                  // Mascot Avatar with Sprout Badge
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: AppColors.duolingoLime,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text('🌟', style: TextStyle(fontSize: 24)),
                          ),
                        ),
                        // Little Sprout Badge
                        Positioned(
                          top: -6,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Color(0xFF76FF03),
                              shape: BoxShape.circle,
                            ),
                            child: const Text('🌱', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // 3. Three Stat Cards Row (Streak, XP, League)
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      emoji: '🔥',
                      value: '$streakDays',
                      label: 'days',
                      sublabel: 'Streak',
                      iconColor: const Color(0xFFFF9600),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      emoji: '⬡',
                      value: '$coins',
                      label: 'Total XP',
                      sublabel: 'XP',
                      iconColor: const Color(0xFFFFB300),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      emoji: '🏆',
                      value: 'Silver',
                      label: 'Top 12%',
                      sublabel: 'League',
                      iconColor: const Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 4. "Continue Learning" Hero Card (Dark Forest Green)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF132A13),
                      Color(0xFF1B3D1B),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF132A13).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONTINUE LEARNING',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF86EFAC),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Everyday Alphabet',
                                style: GoogleFonts.fredoka(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Lesson 4 . Greeting Words',
                                style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  color: const Color(0xFFA5CFA6),
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Progress Bar & Percentage
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.duolingoLime,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '60%',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: const LinearProgressIndicator(
                                        value: 0.6,
                                        minHeight: 8,
                                        backgroundColor: Color(0xFF2C562D),
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.duolingoLime),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // "Continue" Button
                              ElevatedButton(
                                onPressed: () {
                                  _ttsService.speak("Continuing your Everyday Alphabet adventure!");
                                  Navigator.pushNamed(context, AppRoutes.alphabet);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2A592C),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  'Continue',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Characters & Speech Bubble Illustration on the right
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('💬 ...', style: TextStyle(fontSize: 13)),
                            ),
                            const SizedBox(height: 8),
                            const Row(
                              children: [
                                Text('👧', style: TextStyle(fontSize: 34)),
                                SizedBox(width: 4),
                                Text('👦', style: TextStyle(fontSize: 34)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 5. "Today's Goal" Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
                child: Row(
                  children: [
                    // Clock Icon
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.access_time_rounded, color: Color(0xFF4B5563), size: 22),
                    ),

                    const SizedBox(width: 14),

                    // Goal Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Learn for 20 minutes',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1F2937),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Edit',
                                style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.duolingoLime,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '12 / 20 min completed',
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Chest Reward Pill
                    Column(
                      children: [
                        const Text('🎁', style: TextStyle(fontSize: 24)),
                        Text(
                          '+20 XP',
                          style: GoogleFonts.fredoka(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE65100),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // 6. "Quick Practice" Carousel / Modules
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quick Practice',
                    style: GoogleFonts.fredoka(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF132A13),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.learningPath),
                    child: Text(
                      'See all',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.duolingoLime,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Quick Practice Tiles
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildQuickPracticeTile(
                      emoji: '🔤',
                      title: 'Alphabet',
                      color: const Color(0xFF3B82F6),
                      route: AppRoutes.alphabet,
                    ),
                    const SizedBox(width: 12),
                    _buildQuickPracticeTile(
                      emoji: '🔢',
                      title: 'Numbers',
                      color: const Color(0xFF10B981),
                      route: AppRoutes.numbers,
                    ),
                    const SizedBox(width: 12),
                    _buildQuickPracticeTile(
                      emoji: '🎨',
                      title: 'Colors',
                      color: const Color(0xFFEC4899),
                      route: AppRoutes.colors,
                    ),
                    const SizedBox(width: 12),
                    _buildQuickPracticeTile(
                      emoji: '🦁',
                      title: 'Animals',
                      color: const Color(0xFFF59E0B),
                      route: AppRoutes.animals,
                    ),
                    const SizedBox(width: 12),
                    _buildQuickPracticeTile(
                      emoji: '🧠',
                      title: 'Quiz Arena',
                      color: const Color(0xFF8B5CF6),
                      route: AppRoutes.quiz,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF374151), size: 20),
      ),
    );
  }

  Widget _buildStatCard({
    required String emoji,
    required String value,
    required String label,
    required String sublabel,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.fredoka(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPracticeTile({
    required String emoji,
    required String title,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () {
        _ttsService.speak("Opening $title practice!");
        Navigator.pushNamed(context, route);
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.fredoka(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
