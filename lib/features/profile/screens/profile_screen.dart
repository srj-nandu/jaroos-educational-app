import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/learning_provider.dart';
import '../../parent/widgets/parent_gate_dialog.dart';

/// Adorable Mascot Avatar Option
class AvatarOption {
  final String id;
  final String name;
  final String emoji;
  final Color backgroundColor;

  const AvatarOption({
    required this.id,
    required this.name,
    required this.emoji,
    required this.backgroundColor,
  });
}

/// Child & Parent Profile Screen for JAROOS.
/// Allows young learners to customize their avatar, view their learning badges,
/// update their nickname and age, and safely navigate to the Parent Dashboard.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const List<AvatarOption> _avatarOptions = [
    AvatarOption(id: 'star_hero', name: 'Sparky', emoji: '🌟', backgroundColor: Color(0xFFFFD54F)),
    AvatarOption(id: 'lion_brave', name: 'Leo', emoji: '🦁', backgroundColor: Color(0xFFFFB74D)),
    AvatarOption(id: 'bear_cuddly', name: 'Barnaby', emoji: '🐻', backgroundColor: Color(0xFFA1887F)),
    AvatarOption(id: 'fox_clever', name: 'Felix', emoji: '🦊', backgroundColor: Color(0xFFFF8A65)),
    AvatarOption(id: 'bunny_playful', name: 'Bella', emoji: '🐰', backgroundColor: Color(0xFFF48FB1)),
    AvatarOption(id: 'panda_gentle', name: 'Pip', emoji: '🐼', backgroundColor: Color(0xFFB0BEC5)),
    AvatarOption(id: 'owl_wise', name: 'Oliver', emoji: '🦉', backgroundColor: Color(0xFF81D4FA)),
    AvatarOption(id: 'monkey_cheerful', name: 'Milo', emoji: '🐵', backgroundColor: Color(0xFFAED581)),
  ];

  static const List<String> _favoriteSubjectOptions = [
    'Animals & Nature 🦁',
    'Alphabet & Phonics 🔤',
    'Numbers & Counting 🔢',
    'Colors & Rainbows 🎨',
    'Bedtime Stories 📖',
    'Fun Rhymes 🎵',
  ];

  void _showEditProfileDialog(BuildContext context, String currentName, int currentAge) {
    final nameCtrl = TextEditingController(text: currentName);
    int selectedAge = currentAge;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Learner Profile ✏️',
                      style: GoogleFonts.fredoka(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Child Name Field
                    Text(
                      "Child's Nickname",
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        hintText: 'Enter name',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Child Age Selector
                    Text(
                      'Age (${selectedAge} Years Old)',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [3, 4, 5, 6, 7, 8].map((age) {
                          final isSelected = age == selectedAge;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text('$age yrs'),
                              selected: isSelected,
                              onSelected: (_) => setDialogState(() => selectedAge = age),
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final newName = nameCtrl.text.trim();
                            if (newName.isNotEmpty) {
                              context.read<AuthProvider>().updateChildProfile(
                                childName: newName,
                                childAge: selectedAge,
                              );
                            }
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('Save Changes'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Log Out? 👋',
          style: GoogleFonts.fredoka(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to sign out from JAROOS? Your progress is saved safely.',
          style: GoogleFonts.nunito(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Stay Here'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final learning = context.watch<LearningProvider>();
    final isTablet = ResponsiveUtil.isTablet(context);
    final horizontalPadding = ResponsiveUtil.getHorizontalPadding(context);

    final user = auth.user;
    final childName = user?.childName ?? 'Aarav';
    final childAge = user?.childAge ?? 5;
    final parentEmail = user?.email ?? 'learner@jaroos.com';
    final currentAvatarId = user?.avatar ?? 'star_hero';
    final favoriteSubject = user?.favoriteSubject ?? 'Alphabet & Phonics 🔤';

    final activeAvatar = _avatarOptions.firstWhere(
      (a) => a.id == currentAvatarId,
      orElse: () => _avatarOptions.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Profile 👤',
          style: GoogleFonts.fredoka(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showEditProfileDialog(context, childName, childAge),
            tooltip: 'Edit Profile',
            icon: const Icon(Icons.edit_rounded, color: AppColors.primaryDark),
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
                // 1. Child Profile Hero Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: AppColors.softShadow,
                    border: Border.all(color: const Color(0xFFF0F4F8)),
                  ),
                  child: Column(
                    children: [
                      // Active Mascot Avatar Disc
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: activeAvatar.backgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: activeAvatar.backgroundColor.withValues(alpha: 0.4),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: Center(
                          child: Text(
                            activeAvatar.emoji,
                            style: const TextStyle(fontSize: 44),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Child Name & Age Badge
                      Text(
                        childName,
                        style: GoogleFonts.fredoka(
                          fontSize: isTablet ? 26 : 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              '$childAge Years Old',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryLight,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              'Little Explorer',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.secondaryDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Parent Account: $parentEmail',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Avatar Picker Carousel
                Text(
                  'Choose Your Mascot Avatar 🎨',
                  style: GoogleFonts.fredoka(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: _avatarOptions.map((avatar) {
                      final isSelected = avatar.id == currentAvatarId;
                      return GestureDetector(
                        onTap: () {
                          context.read<AuthProvider>().updateChildProfile(avatar: avatar.id);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                              width: isSelected ? 2.5 : 1.0,
                            ),
                            boxShadow: isSelected ? AppColors.softShadow : [],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: avatar.backgroundColor.withValues(alpha: 0.3),
                                ),
                                child: Center(
                                  child: Text(avatar.emoji, style: const TextStyle(fontSize: 26)),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                avatar.name,
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                  color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 22),

                // 3. Learning Milestones Highlights Grid
                Text(
                  'Learning Milestones 🏆',
                  style: GoogleFonts.fredoka(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildMilestoneCard('Total Stars', '${learning.totalStars}', '⭐', const Color(0xFFFFB300)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMilestoneCard('Golden Coins', '${learning.coins}', '🪙', const Color(0xFFFF7043)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildMilestoneCard('Lessons Done', '${learning.totalLessonsCompleted}', '📚', const Color(0xFF4FC3F7)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMilestoneCard('Trophies', '${learning.unlockedAchievementsCount}', '🎖️', const Color(0xFF66BB6A)),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                // 4. Favorite Subject Selector Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppColors.softShadow,
                    border: Border.all(color: const Color(0xFFF0F4F8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Favorite Learning Area ❤️',
                            style: GoogleFonts.fredoka(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Text('🌟', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _favoriteSubjectOptions.map((subject) {
                          final isFav = subject == favoriteSubject;
                          return ChoiceChip(
                            label: Text(subject),
                            selected: isFav,
                            onSelected: (_) {
                              context.read<AuthProvider>().updateChildProfile(favoriteSubject: subject);
                            },
                            selectedColor: AppColors.primaryLight,
                            labelStyle: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: isFav ? FontWeight.w800 : FontWeight.w600,
                              color: isFav ? AppColors.primaryDark : AppColors.textPrimary,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 5. Parent Dashboard & Log Out Buttons
                OutlinedButton.icon(
                  onPressed: () {
                    ParentGateDialog.show(
                      context,
                      onSuccess: () => Navigator.pushNamed(context, AppRoutes.parentDashboard),
                    );
                  },
                  icon: const Icon(Icons.family_restroom_rounded),
                  label: const Text('Open Parent Dashboard 👨‍👩‍👧'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                  label: Text(
                    'Log Out Learner Account',
                    style: GoogleFonts.nunito(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMilestoneCard(String label, String value, String emoji, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow,
        border: Border.all(color: const Color(0xFFF0F4F8)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
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
}
