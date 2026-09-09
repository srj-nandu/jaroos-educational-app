import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/screens/home_screen.dart';
import '../../learning_path/screens/learning_path_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../progress/screens/progress_screen.dart';
import '../../quiz/screens/quiz_screen.dart';

/// Main Navigation Shell hosting the persistent 5-tab bottom navigation bar.
/// Tabs:
/// 1. 🏠 Home: Modern dashboard with streak, XP, League, and "Continue Learning"
/// 2. 📖 Courses: Stepping stones learning path (Duolingo style)
/// 3. 🤹 Practice: Quiz Arena, AI Sparky Buddy, Bedtime Stories
/// 4. 📊 Progress: Telemetry, achievements, and parent portal
/// 5. 👤 Profile: Child profile, avatar, coins, sound settings
class MainNavigationShell extends StatefulWidget {
  final int initialTab;

  const MainNavigationShell({
    super.key,
    this.initialTab = 0,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    LearningPathScreen(showBackButton: false),
    QuizScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  void _onTabTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: Color(0xFFE5E7EB), width: 1.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Home'),
                _buildNavItem(1, Icons.menu_book_rounded, 'Courses'),
                _buildNavItem(2, Icons.psychology_rounded, 'Practice'),
                _buildNavItem(3, Icons.bar_chart_rounded, 'Progress'),
                _buildNavItem(4, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? const Color(0xFF132A13) : const Color(0xFF9CA3AF);

    return InkWell(
      onTap: () => _onTabTapped(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: color,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
