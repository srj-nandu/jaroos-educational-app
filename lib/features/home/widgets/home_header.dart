import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/language_provider.dart';
import '../../parent/widgets/parent_gate_dialog.dart';

/// Top header banner on the Home Dashboard.
/// Displays personalized greeting, child avatar, live reward coin counter,
/// and quick navigation buttons for Profile and Parent Dashboard.
class HomeHeader extends StatelessWidget {
  final String childName;
  final int coins;
  final String avatar;

  const HomeHeader({
    super.key,
    required this.childName,
    required this.coins,
    this.avatar = 'star_hero',
  });

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: const Color(0xFFF2ECE0), width: 1.5),
      ),
      child: Row(
        children: [
          // Cute Child Mascot Avatar (Tap to open Profile)
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
            child: _buildAvatar(),
          ),
          const SizedBox(width: 12),

          // Child Greeting & Motivational Tagline
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${lang.tr('greeting_hello')}, $childName! 👋',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontSize: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  lang.tr('home_subtitle'),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Reward Coins Pill Badge
          _buildCoinBadge(coins),
          const SizedBox(width: 8),

          // Parent Dashboard Button (Protected by Parent Gate)
          IconButton(
            onPressed: () {
              ParentGateDialog.show(
                context,
                onSuccess: () => Navigator.pushNamed(context, AppRoutes.parentDashboard),
              );
            },
            tooltip: 'Parent Dashboard',
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.family_restroom_rounded,
                color: AppColors.primaryDark,
                size: 20,
              ),
            ),
          ),

          // Profile Button
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
            tooltip: 'My Profile',
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppColors.secondaryDark,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getAvatarEmoji(String avatarId) {
    switch (avatarId) {
      case 'lion_brave': return '🦁';
      case 'bear_cuddly': return '🐻';
      case 'fox_clever': return '🦊';
      case 'bunny_playful': return '🐰';
      case 'panda_gentle': return '🐼';
      case 'owl_wise': return '🦉';
      case 'monkey_cheerful': return '🐵';
      default: return '🌟';
    }
  }

  /// Mascot circle avatar with soft gradient and smiling mascot emoji
  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryDark.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          _getAvatarEmoji(avatar),
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  /// Shiny coin counter pill
  Widget _buildCoinBadge(int coinCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD54F), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB300).withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🪙', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            '$coinCount',
            style: GoogleFonts.fredoka(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFB78103),
            ),
          ),
        ],
      ),
    );
  }
}
