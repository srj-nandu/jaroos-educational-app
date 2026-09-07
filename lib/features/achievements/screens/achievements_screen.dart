import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../models/achievement_model.dart';
import '../../../providers/learning_provider.dart';

/// Interactive Trophy & Badges Showcase for JAROOS.
/// Visualizes unlocked achievements with sparkling gold effects and locked achievements
/// with clear educational unlock criteria.
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final learning = context.watch<LearningProvider>();
    final isTablet = ResponsiveUtil.isTablet(context);
    final horizontalPadding = ResponsiveUtil.getHorizontalPadding(context);
    final columns = isTablet ? 3 : 2;

    final achievements = learning.achievements;
    final unlockedCount = learning.unlockedAchievementsCount;
    final totalCount = achievements.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Trophy Room 🏆',
          style: GoogleFonts.fredoka(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.secondaryDark.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🪙', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(
                  '${learning.coins}',
                  style: GoogleFonts.fredoka(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondaryDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Trophy Room Header Banner
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppColors.softShadow,
                    border: Border.all(color: const Color(0xFFF0F4F8)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.secondaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Text('🌟', style: TextStyle(fontSize: 26)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$unlockedCount of $totalCount Badges Unlocked!',
                              style: GoogleFonts.fredoka(
                                fontSize: isTablet ? 18 : 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Keep playing lessons to collect all shiny trophies!',
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
                ),
              ),

              // Badges Grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 8,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: achievements.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: isTablet ? 0.95 : 0.82,
                  ),
                  itemBuilder: (context, index) {
                    final badge = achievements[index];
                    return _buildBadgeCard(context, badge, isTablet);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Individual Badge Card (Unlocked vs Locked visuals)
  Widget _buildBadgeCard(BuildContext context, AchievementModel badge, bool isTablet) {
    final isUnlocked = badge.isUnlocked;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showBadgeDetailDialog(context, badge),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isUnlocked ? Colors.white : const Color(0xFFF9FAFC),
            borderRadius: BorderRadius.circular(24),
            boxShadow: isUnlocked ? AppColors.softShadow : [],
            border: Border.all(
              color: isUnlocked
                  ? badge.badgeColor.withValues(alpha: 0.5)
                  : const Color(0xFFE2E8F0),
              width: isUnlocked ? 2.0 : 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Badge Icon with Glowing Disc or Lock
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: isTablet ? 72 : 62,
                    height: isTablet ? 72 : 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isUnlocked
                          ? badge.badgeColor.withValues(alpha: 0.18)
                          : const Color(0xFFE0E0E0),
                      boxShadow: isUnlocked
                          ? [
                              BoxShadow(
                                color: badge.badgeColor.withValues(alpha: 0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      badge.icon,
                      color: isUnlocked ? badge.badgeColor : const Color(0xFF9E9E9E),
                      size: isTablet ? 34 : 30,
                    ),
                  ),

                  // Top Right Lock or Star Badge
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isUnlocked ? const Color(0xFFFFB300) : const Color(0xFF757575),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isUnlocked ? Icons.star_rounded : Icons.lock_rounded,
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Badge Title
              Text(
                badge.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.fredoka(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w700,
                  color: isUnlocked ? AppColors.textPrimary : const Color(0xFF757575),
                ),
              ),
              const SizedBox(height: 4),

              // Description / Progress
              Text(
                isUnlocked ? badge.description : '${badge.currentCount}/${badge.requiredCount} completed',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isUnlocked ? AppColors.textSecondary : const Color(0xFF9E9E9E),
                ),
              ),
              const Spacer(),

              // Status Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isUnlocked ? '✨ +${badge.rewardCoins} 🪙' : '🔒 +${badge.rewardCoins} 🪙',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: isUnlocked ? const Color(0xFF2E7D32) : const Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Interactive Modal with Details & Pronunciation
  void _showBadgeDetailDialog(BuildContext context, AchievementModel badge) {
    final tts = Provider.of<TtsService>(context, listen: false);
    final isUnlocked = badge.isUnlocked;

    // Speak audio celebration or guidance
    final speechText = isUnlocked
        ? 'Congratulations! You unlocked the ${badge.title} badge! ${badge.description}.'
        : 'The ${badge.title} badge is locked! ${badge.description}. Complete ${badge.requiredCount} lessons to earn ${badge.rewardCoins} coins!';
    tts.speak(speechText);

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Big Badge Icon
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isUnlocked
                        ? badge.badgeColor.withValues(alpha: 0.2)
                        : const Color(0xFFEEEEEE),
                    border: Border.all(
                      color: isUnlocked ? badge.badgeColor : const Color(0xFFBDBDBD),
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    badge.icon,
                    size: 46,
                    color: isUnlocked ? badge.badgeColor : const Color(0xFF757575),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  badge.title,
                  style: GoogleFonts.fredoka(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  badge.description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),

                // Progress Indicator (if locked)
                if (!isUnlocked) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: badge.progressPercentage,
                      minHeight: 10,
                      backgroundColor: const Color(0xFFE0E0E0),
                      valueColor: AlwaysStoppedAnimation<Color>(badge.badgeColor),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${badge.currentCount} of ${badge.requiredCount} Completed',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Reward Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFD54F)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🪙', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(
                        'Reward: +${badge.rewardCoins} Golden Coins',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFF57F17),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Close Button
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: badge.badgeColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: Text(
                    isUnlocked ? 'Awesome! 🌟' : 'I Can Do It! 🚀',
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
