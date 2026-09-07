import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/learning_provider.dart';
import '../widgets/daily_streak_banner.dart';
import '../widgets/home_header.dart';
import '../widgets/module_card.dart';

/// Main Learning Dashboard for JAROOS.
/// Displays personalized greeting, coin counter, daily learning streak banner,
/// AI buddy & bedtime story shortcuts, and a dynamic GridView of all learning modules.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final learningProvider = context.watch<LearningProvider>();

    final childName = authProvider.user?.childName ?? 'Young Learner';
    final coins = learningProvider.coins;
    final streakDays = learningProvider.streakDays;
    final modules = learningProvider.modules;

    final horizontalPadding = ResponsiveUtil.getHorizontalPadding(context);
    final gridColumns = ResponsiveUtil.getModuleGridColumns(context);
    final isTablet = ResponsiveUtil.isTablet(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Navigation & Child Profile Header
                HomeHeader(
                  childName: childName,
                  coins: coins,
                  avatar: authProvider.user?.avatar ?? 'star_hero',
                ),

                const SizedBox(height: 18),

                // Daily Learning Streak Banner
                DailyStreakBanner(
                  streakDays: streakDays,
                ),

                const SizedBox(height: 16),

                // AI Companions & Generative Magic Section
                Row(
                  children: [
                    Expanded(
                      child: _buildAiCard(
                        context: context,
                        emoji: '🌟',
                        title: 'Sparky AI',
                        subtitle: 'Ask Any Question',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        route: AppRoutes.aiBuddy,
                        badgeText: 'VOICE AI',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildAiCard(
                        context: context,
                        emoji: '🪄',
                        title: 'Story Magic',
                        subtitle: 'Bedtime Tales',
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF7043), Color(0xFFE64A19)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        route: AppRoutes.aiStoryGenerator,
                        badgeText: 'GEN AI',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // Section Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Learning Adventures 🚀',
                        style: GoogleFonts.fredoka(
                          fontSize: isTablet ? 26 : 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        '${modules.length} Modules',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap any card to start learning and playing!',
                  style: GoogleFonts.nunito(
                    fontSize: isTablet ? 15 : 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 16),

                // Dynamic Learning Grid (GridView.builder as specified in requirements)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: modules.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridColumns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isTablet ? 0.95 : 0.86,
                  ),
                  itemBuilder: (context, index) {
                    final module = modules[index];
                    return ModuleCard(
                      module: module,
                      onTap: () {
                        Navigator.pushNamed(context, module.route);
                      },
                    );
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAiCard({
    required BuildContext context,
    required String emoji,
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required String route,
    required String badgeText,
  }) {
    return Container(
      height: 106,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.last.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => Navigator.pushNamed(context, route),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 26)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badgeText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fredoka(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
