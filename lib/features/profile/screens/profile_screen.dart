import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/learning_provider.dart';
import '../../common/widgets/frog_assistant_widget.dart';
import '../../parent/widgets/parent_gate_dialog.dart';

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

/// Gamified Child & Parent Profile Screen for JAROOS.
/// Features:
/// - Forest green hero profile banner with level sprout badge
/// - 4 Gamified Stat Capsules (Streak, Gems, League, Badges)
/// - Daily Learning Goal card (20 min goal)
/// - Mascot Avatar Picker
/// - Protected Parent Gate access
/// - Cut-the-Rope Frog Assistant ("Froggo")
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
                        color: const Color(0xFF132A13),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Child Name Field
                    Text(
                      "Child's Nickname",
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4B5563),
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

                    // Child Age Field
                    Text(
                      "Child's Age",
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [3, 4, 5, 6, 7, 8].map((age) {
                        final isSelected = selectedAge == age;
                        return ChoiceChip(
                          label: Text('$age yrs'),
                          selected: isSelected,
                          selectedColor: AppColors.duolingoLime,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w700,
                          ),
                          onSelected: (val) {
                            setDialogState(() => selectedAge = age);
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            final auth = context.read<AuthProvider>();
                            await auth.updateChildProfile(
                              childName: nameCtrl.text.trim().isEmpty ? currentName : nameCtrl.text.trim(),
                              childAge: selectedAge,
                              avatar: auth.user?.avatar ?? 'star_hero',
                              favoriteSubject: auth.user?.favoriteSubject ?? 'Alphabet & Phonics 🔤',
                            );
                            if (ctx.mounted) Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.duolingoLime,
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

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final learning = context.watch<LearningProvider>();
    final isTablet = ResponsiveUtil.isTablet(context);

    final user = auth.user;
    final childName = user?.childName ?? 'Aria';
    final childAge = user?.childAge ?? 5;
    final activeAvatarId = user?.avatar ?? 'star_hero';
    final activeAvatar = _avatarOptions.firstWhere(
      (a) => a.id == activeAvatarId,
      orElse: () => _avatarOptions[0],
    );

    final streak = learning.streakDays;
    final coins = learning.coins;
    final badges = learning.unlockedAchievementsCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FCF2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'My Profile 👤',
          style: GoogleFonts.fredoka(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF132A13),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ParentGateDialog.show(
                context,
                onSuccess: () => Navigator.pushNamed(context, AppRoutes.parentDashboard),
              );
            },
            tooltip: 'Parent Dashboard',
            icon: const Icon(Icons.family_restroom_rounded, color: Color(0xFF132A13), size: 26),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Hero Profile Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.forestGreenDark,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                color: activeAvatar.backgroundColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(activeAvatar.emoji, style: const TextStyle(fontSize: 44)),
                              ),
                            ),
                            // Sprout Level Badge
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: AppColors.duolingoLime,
                                shape: BoxShape.circle,
                              ),
                              child: const Text('🌱', style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              childName,
                              style: GoogleFonts.fredoka(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _showEditProfileDialog(context, childName, childAge),
                              icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                              tooltip: 'Edit Profile',
                            ),
                          ],
                        ),
                        Text(
                          '$childAge Years Old',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.duolingoLime,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Level 3 Explorer 🌱',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 2. 4 Stat Capsules Row (Streak, Gems, League, Badges)
                  Row(
                    children: [
                      _buildStatCapsule('Streak', '$streak d', '🔥', const Color(0xFFFF9600)),
                      const SizedBox(width: 8),
                      _buildStatCapsule('Gems', '$coins', '💎', const Color(0xFFFFB300)),
                      const SizedBox(width: 8),
                      _buildStatCapsule('League', 'Silver', '🛡️', const Color(0xFF9E9E9E)),
                      const SizedBox(width: 8),
                      _buildStatCapsule('Badges', '$badges', '🌟', AppColors.duolingoLime),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 3. Daily Learning Goal Card (Matching Dashboard Card)
                  Container(
                    padding: const EdgeInsets.all(18),
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
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.access_time_rounded, color: Color(0xFF4B5563), size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Daily Goal: 20 min',
                                style: GoogleFonts.fredoka(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '12 of 20 min completed today',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text('🎁', style: TextStyle(fontSize: 22)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // 4. Mascot Avatar Picker Carousel
                  Text(
                    'Choose Your Mascot Avatar 🎨',
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF132A13),
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _avatarOptions.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        final avatar = _avatarOptions[i];
                        final isSelected = avatar.id == activeAvatarId;

                        return GestureDetector(
                          onTap: () async {
                            await auth.updateChildProfile(
                              childName: childName,
                              childAge: childAge,
                              avatar: avatar.id,
                              favoriteSubject: user?.favoriteSubject ?? 'Alphabet & Phonics 🔤',
                            );
                          },
                          child: Container(
                            width: 80,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected ? AppColors.duolingoLime : const Color(0xFFE5E7EB),
                                width: isSelected ? 2.5 : 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(avatar.emoji, style: const TextStyle(fontSize: 28)),
                                const SizedBox(height: 4),
                                Text(
                                  avatar.name,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? AppColors.duolingoLime : const Color(0xFF4B5563),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 22),

                  // 5. Parent Zone Button
                  Container(
                    width: double.infinity,
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
                          ParentGateDialog.show(
                            context,
                            onSuccess: () => Navigator.pushNamed(context, AppRoutes.parentDashboard),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDE9FE),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.security_rounded, color: Color(0xFF7C3AED), size: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Parent Dashboard & Controls 🔒',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1F2937),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Screen time, learning analytics & PIN settings',
                                      style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF9CA3AF), size: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

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
              customTip: "Ribbit! You look super cool in that avatar! 🌟",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCapsule(String label, String value, String emoji, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 3),
            Text(
              value,
              style: GoogleFonts.fredoka(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
