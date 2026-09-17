import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/learning_provider.dart';
import '../../parent/widgets/parent_gate_dialog.dart';

/// Redesigned Modern Learning Dashboard matching the "Giraffe / Enlightenment" Screen
/// from the user's reference mockup.
/// Features:
/// - Header: "JAROOS", "Welcome to JAROOS education.", "Hey, $childName! 👋", squircle mascot avatar
/// - Status Capsules: Streak (🔥 7) and Coins (💎 320)
/// - "Children's Enlightenment" Hero Card: Warm golden amber banner with mascot reading books and "See more" button
/// - Category Quick Action Cards: Story (Coral), Video (Sky Blue), Music (Purple), Quiz (Mint)
/// - "Recommend" Section: Experience Course cards with friend counts and orange "Join" buttons
/// - "Quick Practice" Carousel: Interactive tiles for Alphabet, Numbers, Colors, Animals, Fruits, and Stories
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

    final childName = authProvider.user?.childName ?? 'Aarav';
    final coins = learningProvider.coins;
    final streakDays = learningProvider.streakDays;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8), // Warm soft cream canvas
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar: Streak, Coins, Bell, Grid
              Row(
                children: [
                  // Streak Capsule
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
                        const Text('🔥', style: TextStyle(fontSize: 15)),
                        const SizedBox(width: 4),
                        Text(
                          '$streakDays',
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

                  // Coins/Gems Capsule
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
                        const Text('💎', style: TextStyle(fontSize: 15)),
                        const SizedBox(width: 4),
                        Text(
                          '$coins',
                          style: GoogleFonts.fredoka(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFFA000),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Parent Gate Bell
                  _buildCircleIconButton(
                    icon: Icons.notifications_none_rounded,
                    onTap: () {
                      ParentGateDialog.show(
                        context,
                        onSuccess: () => Navigator.pushNamed(context, AppRoutes.parentDashboard),
                      );
                    },
                  ),

                  const SizedBox(width: 8),

                  // Category Grid
                  _buildCircleIconButton(
                    icon: Icons.grid_view_rounded,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.learningPath),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // 2. Greeting Header: "JAROOS", "Welcome to JAROOS education.", "Hey, $childName! 👋" + Mascot Squircle Avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'JAROOS',
                              style: GoogleFonts.bubblegumSans(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1F2937),
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Exact test expectation: "Hey, Aarav! 👋"
                            Flexible(
                              child: Text(
                                'Hey, $childName! 👋',
                                style: GoogleFonts.fredoka(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFE65100),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Welcome to JAROOS education.',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Squircle Mascot Avatar from reference mockup
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFA726),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFA726).withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/mascot_avatar.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Text('🦒', style: TextStyle(fontSize: 26)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // 3. "Children's Enlightenment" Hero Card (Warm Orange Amber Banner)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFA000), // Vibrant Golden Orange
                      Color(0xFFFF8F00),
                      Color(0xFFFF6F00),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF8F00).withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: Stack(
                    children: [
                      // Background Illustration on Right
                      Positioned(
                        right: 0,
                        bottom: 0,
                        top: 0,
                        width: 150,
                        child: Image.asset(
                          'assets/images/enlightenment_mascot_books.png',
                          fit: BoxFit.contain,
                          alignment: Alignment.bottomRight,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Text('📚🦒', style: TextStyle(fontSize: 48)),
                          ),
                        ),
                      ),

                      // Banner Content on Left
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Double Quote Icon
                            Text(
                              '“',
                              style: GoogleFonts.fredoka(
                                fontSize: 30,
                                height: 0.8,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Heading
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Text(
                                "Children's\nEnlightenment",
                                style: GoogleFonts.fredoka(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Pill Button "See more"
                            GestureDetector(
                              onTap: () {
                                _ttsService.speak("Let's explore your learning courses!");
                                Navigator.pushNamed(context, AppRoutes.learningPath);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'See more',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFF8F00),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // 4. Pastel Squircle Category Action Cards (Story, Video, Music, Quiz)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryCard(
                    title: 'Story',
                    iconEmoji: '📖',
                    iconColor: const Color(0xFFFF5722),
                    bgColor: const Color(0xFFFFECE5),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.stories),
                  ),
                  _buildCategoryCard(
                    title: 'Video',
                    iconEmoji: '🎬',
                    iconColor: const Color(0xFF3B82F6),
                    bgColor: const Color(0xFFEBF3FE),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.learningPath),
                  ),
                  _buildCategoryCard(
                    title: 'Music',
                    iconEmoji: '🎵',
                    iconColor: const Color(0xFF9333EA),
                    bgColor: const Color(0xFFF5EBFD),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.rhymes),
                  ),
                  _buildCategoryCard(
                    title: 'Quiz',
                    iconEmoji: '🧠',
                    iconColor: const Color(0xFF10B981),
                    bgColor: const Color(0xFFECFDF5),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.quiz),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 5. "Recommend" Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommend',
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.learningPath),
                    child: Text(
                      'More',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Recommend Card 1: Experience Course (Red Hood)
              _buildRecommendCard(
                title: 'Experience Course',
                subtitle: '80 people have participated',
                imageAsset: 'assets/images/thumb_red_hood.png',
                defaultEmoji: '👧',
                onJoin: () {
                  _ttsService.speak("Opening Experience Course!");
                  Navigator.pushNamed(context, AppRoutes.alphabet);
                },
              ),

              const SizedBox(height: 12),

              // Recommend Card 2: Alphabet & Phonics (Giraffe)
              _buildRecommendCard(
                title: 'Alphabet & Phonics',
                subtitle: '120 learners exploring today',
                imageAsset: 'assets/images/thumb_giraffe.png',
                defaultEmoji: '🦒',
                onJoin: () {
                  _ttsService.speak("Opening Alphabet & Phonics!");
                  Navigator.pushNamed(context, AppRoutes.alphabet);
                },
              ),

              const SizedBox(height: 24),

              // 6. "Quick Practice" Horizontal Carousel (Alphabet, Numbers, Colors, Animals, Fruits)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quick Practice',
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.learningPath),
                    child: Text(
                      'See all',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFFA000),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 110,
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
                      emoji: '🍎',
                      title: 'Fruits',
                      color: const Color(0xFFEF4444),
                      route: AppRoutes.fruits,
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

  /// Circular Icon Button for top bar
  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFF1EADB), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF4B5563), size: 19),
      ),
    );
  }

  /// Pastel Squircle Category Button matching reference mockup
  Widget _buildCategoryCard({
    required String title,
    required String iconEmoji,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: iconColor.withValues(alpha: 0.15), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    iconEmoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  /// "Recommend" Course Card with Character Thumbnail and "Join" Button
  Widget _buildRecommendCard({
    required String title,
    required String subtitle,
    required String imageAsset,
    required String defaultEmoji,
    required VoidCallback onJoin,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
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
        children: [
          // Squircle Yellow Thumbnail
          Container(
            width: 52,
            height: 52,
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
                  child: Text(defaultEmoji, style: const TextStyle(fontSize: 26)),
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Course Info
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
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9CA3AF),
                  ),
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

  /// Quick Practice Horizontal Tile
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
        width: 95,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1EADB), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(height: 6),
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
