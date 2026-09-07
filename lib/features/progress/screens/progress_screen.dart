import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../models/learning_module_model.dart';
import '../../../providers/learning_provider.dart';
import '../../common/widgets/frog_assistant_widget.dart';

/// Gamified Holistic Progress & Growth Dashboard for JAROOS.
/// Features:
/// - Silver League Promotion Banner (Top 12%)
/// - 7-Day Flame Streak Activity Bar
/// - Overall Mastery Hero Card (84% Mastery)
/// - Quick Stats Row (Coins, Stars, Streak, Lessons)
/// - Achievements & Badges Teaser Card
/// - Subject-by-Subject Module Breakdown
/// - Interactive Cut-the-Rope Frog Assistant ("Froggo")
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final learning = context.watch<LearningProvider>();
    final isTablet = ResponsiveUtil.isTablet(context);
    final horizontalPadding = ResponsiveUtil.getHorizontalPadding(context);

    final overall = learning.overallProgress;
    final totalCoins = learning.coins;
    final totalStars = learning.totalStars;
    final streak = learning.streakDays;
    final lessons = learning.totalLessonsCompleted;
    final badgesCount = learning.unlockedAchievementsCount;
    final totalBadges = learning.achievements.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FCF2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'My Learning Journey 🚀',
          style: GoogleFonts.fredoka(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF132A13),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.achievements),
            tooltip: 'View Badges',
            icon: const Icon(Icons.military_tech_rounded, color: Color(0xFFD97706), size: 28),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Gamified Silver League Banner (Matching Mockup Dashboard)
                  _buildLeagueBanner(isTablet),
                  const SizedBox(height: 14),

                  // 2. 7-Day Flame Streak Weekly Activity
                  _buildWeeklyStreakTracker(streak),
                  const SizedBox(height: 14),

                  // 3. Overall Mastery Hero Card
                  _buildMasteryHeroCard(context, overall, isTablet),
                  const SizedBox(height: 14),

                  // 4. Quick Stats Row (Coins, Stars, Streak, Lessons)
                  _buildQuickStatsRow(totalCoins, totalStars, streak, lessons, isTablet),
                  const SizedBox(height: 14),

                  // 5. Achievements / Badges Teaser Banner
                  _buildBadgesTeaserCard(context, badgesCount, totalBadges, isTablet),
                  const SizedBox(height: 20),

                  // 6. Subject-by-Subject Breakdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Module Breakdown 📚',
                        style: GoogleFonts.fredoka(
                          fontSize: isTablet ? 22 : 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF132A13),
                        ),
                      ),
                      Text(
                        '${learning.modules.length} Subjects',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Module Progress Cards List
                  for (final module in learning.modules) ...[
                    _buildModuleProgressCard(context, module, isTablet),
                    const SizedBox(height: 12),
                  ],

                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),

          // Embedded Frog Assistant
          Positioned(
            bottom: 16,
            right: 16,
            child: const FrogAssistantWidget(
              compact: true,
              customTip: "Ribbit! You're in the top promotion zone! 🛡️",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeagueBanner(bool isTablet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.forestGreenDark,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Shield Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🛡️', style: TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Silver League · Rank #3',
                        style: GoogleFonts.fredoka(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.duolingoLime,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'TOP 12%',
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Promotion Zone! 2 days left to advance to Gold.',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStreakTracker(int streakDays) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(
                    '$streakDays Days Streak',
                    style: GoogleFonts.fredoka(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF132A13),
                    ),
                  ),
                ],
              ),
              Text(
                'Active Week',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE65100),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final isCompleted = i < (streakDays > 7 ? 7 : streakDays);
              return Column(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isCompleted ? const Color(0xFFFF9600) : const Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                      boxShadow: isCompleted
                          ? [
                              BoxShadow(
                                color: const Color(0xFFFF9600).withValues(alpha: 0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Text('🔥', style: TextStyle(fontSize: 16))
                          : Text(
                              days[i],
                              style: GoogleFonts.fredoka(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    days[i],
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isCompleted ? const Color(0xFFE65100) : const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMasteryHeroCard(BuildContext context, double overall, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Percent Ring
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: (overall / 100).clamp(0.0, 1.0),
                  strokeWidth: 8,
                  backgroundColor: const Color(0xFFE5E7EB),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.duolingoLime),
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Text(
                    '${overall.toInt()}%',
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF132A13),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Mastery',
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF132A13),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Outstanding progress! Your child is advancing through phonics and numbers rapidly.',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsRow(int coins, int stars, int streak, int lessons, bool isTablet) {
    return Row(
      children: [
        _buildStatItem('Coins', '$coins', '💎', const Color(0xFFFF9600)),
        const SizedBox(width: 10),
        _buildStatItem('Stars', '$stars', '⭐', const Color(0xFFFFC800)),
        const SizedBox(width: 10),
        _buildStatItem('Streak', '$streak d', '🔥', const Color(0xFFE11D48)),
        const SizedBox(width: 10),
        _buildStatItem('Lessons', '$lessons', '📚', AppColors.duolingoLime),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, String emoji, Color accentColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
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
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.fredoka(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesTeaserCard(BuildContext context, int unlocked, int total, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC800).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(child: Text('🏆', style: TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Achievements & Badges',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF132A13),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$unlocked of $total badges unlocked',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.achievements),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.duolingoLime,
              textStyle: GoogleFonts.fredoka(fontWeight: FontWeight.w700),
            ),
            child: const Text('View All'),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleProgressCard(BuildContext context, LearningModuleModel module, bool isTablet) {
    final percent = (module.progressPercentage * 100).toInt();

    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, module.route),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: module.primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(module.icon, color: module.primaryColor, size: 22),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            module.title,
                            style: GoogleFonts.fredoka(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${module.completedLessons} of ${module.totalLessons} lessons completed',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '$percent%',
                      style: GoogleFonts.fredoka(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: module.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: module.progressPercentage,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFF3F4F6),
                    valueColor: AlwaysStoppedAnimation<Color>(module.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
