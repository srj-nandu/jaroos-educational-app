import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/learning_provider.dart';

/// Holistic Progress & Growth Dashboard for JAROOS.
/// Visualizes overall learning mastery percentage, star milestones, streak counters,
/// and module-by-module advancement.
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Learning Journey 🚀',
          style: GoogleFonts.fredoka(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.achievements),
            tooltip: 'View Badges',
            icon: const Icon(Icons.military_tech_rounded, color: AppColors.secondaryDark, size: 28),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Overall Mastery Hero Card
                _buildMasteryHeroCard(context, overall, isTablet),
                const SizedBox(height: 18),

                // 2. Quick Stats Row (Coins, Stars, Streak, Lessons)
                _buildQuickStatsRow(totalCoins, totalStars, streak, lessons, isTablet),
                const SizedBox(height: 18),

                // 3. Achievements / Badges Teaser Banner
                _buildBadgesTeaserCard(context, badgesCount, totalBadges, isTablet),
                const SizedBox(height: 24),

                // 4. Subject-by-Subject Breakdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Module Breakdown 📚',
                      style: GoogleFonts.fredoka(
                        fontSize: isTablet ? 22 : 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${learning.modules.length} Subjects',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Module Progress Cards List
                ...learning.modules.map((module) => _buildModuleProgressCard(context, module, isTablet)),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Big Circular Mastery Progress Card with Encouraging Mascot Feedback
  Widget _buildMasteryHeroCard(BuildContext context, double percentage, bool isTablet) {
    String motivation = 'Super Explorer! 🌟';
    String subtext = 'You are learning so many amazing things!';
    if (percentage >= 80) {
      motivation = 'Genius Champion! 🏆';
      subtext = 'Almost mastered all early learning modules!';
    } else if (percentage >= 50) {
      motivation = 'Halfway Star! 🚀';
      subtext = 'Great momentum! Keep discovering every day!';
    }

    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: const Color(0xFFE8EEF5), width: 1.5),
      ),
      child: Row(
        children: [
          // Circular Progress Gauge
          SizedBox(
            width: isTablet ? 110 : 90,
            height: isTablet ? 110 : 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: isTablet ? 110 : 90,
                  height: isTablet ? 110 : 90,
                  child: CircularProgressIndicator(
                    value: (percentage / 100).clamp(0.0, 1.0),
                    strokeWidth: isTablet ? 12 : 10,
                    backgroundColor: AppColors.primaryLight.withValues(alpha: 0.5),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryDark),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${percentage.toInt()}%',
                      style: GoogleFonts.fredoka(
                        fontSize: isTablet ? 26 : 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    Text(
                      'Done',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),

          // Encouraging Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Overall Mastery',
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondaryDark,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  motivation,
                  style: GoogleFonts.fredoka(
                    fontSize: isTablet ? 20 : 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtext,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 4 Visual Quick Stats: Coins, Stars, Streak, Lessons
  Widget _buildQuickStatsRow(int coins, int stars, int streak, int lessons, bool isTablet) {
    final stats = [
      {'label': 'Coins', 'value': '$coins', 'icon': '🪙', 'color': const Color(0xFFFFB300)},
      {'label': 'Stars', 'value': '$stars', 'icon': '⭐', 'color': const Color(0xFFFF7043)},
      {'label': 'Streak', 'value': '$streak d', 'icon': '🔥', 'color': const Color(0xFFE53935)},
      {'label': 'Lessons', 'value': '$lessons', 'icon': '📚', 'color': const Color(0xFF4FC3F7)},
    ];

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppColors.softShadow,
              border: Border.all(color: const Color(0xFFF0F4F8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(stat['icon'] as String, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    stat['value'] as String,
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  stat['label'] as String,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Banner directing the child to the Badges & Trophies screen
  Widget _buildBadgesTeaserCard(BuildContext context, int unlocked, int total, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8E53), Color(0xFFFF6584)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6584).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: const Text('🏆', style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Achievements & Badges',
                  style: GoogleFonts.fredoka(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$unlocked of $total Badges Unlocked 🌟',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.achievements),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFFF6584),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              'View All',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Individual Module Progress Item Card
  Widget _buildModuleProgressCard(BuildContext context, dynamic module, bool isTablet) {
    final progress = (module.completedLessons / module.totalLessons).clamp(0.0, 1.0);
    final percentage = (progress * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: const Color(0xFFF0F4F8)),
      ),
      child: Row(
        children: [
          // Module Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (module.primaryColor as Color).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(module.icon as IconData, color: module.primaryColor as Color, size: 24),
          ),
          const SizedBox(width: 14),

          // Title & Progress Bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      module.title as String,
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: module.primaryColor as Color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFECEFF1),
                    valueColor: AlwaysStoppedAnimation<Color>(module.primaryColor as Color),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${module.completedLessons} of ${module.totalLessons} Lessons Done',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Play / Continue Button
          IconButton(
            onPressed: () => Navigator.pushNamed(context, module.route as String),
            tooltip: 'Continue ${module.title}',
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: (module.primaryColor as Color).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.play_arrow_rounded, color: module.primaryColor as Color, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
