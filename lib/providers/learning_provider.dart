import 'package:flutter/material.dart';
import '../core/config/app_flavor.dart';
import '../core/constants/app_constants.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../models/achievement_model.dart';
import '../models/learning_module_model.dart';
import '../models/progress_model.dart';

/// Centralized state management for learning progress, active modules,
/// reward coins, and child learning streaks in JAROOS.
class LearningProvider with ChangeNotifier {
  late int _coins;
  late int _streakDays;
  late int _totalQuizzesAttempted;
  late double _averageQuizScore;
  late int _bonusStars;
  bool _isLoading = false;

  late List<LearningModuleModel> _modules;
  late List<AchievementModel> _achievements;

  LearningProvider() {
    if (AppFlavor.isGlobal) {
      _coins = 0;
      _streakDays = 0;
      _totalQuizzesAttempted = 0;
      _averageQuizScore = 0.0;
      _bonusStars = 0;
    } else {
      // Testing / viva evaluation state (matching the 320 XP, 7-day streak mockup)
      _coins = 320;
      _streakDays = 7;
      _totalQuizzesAttempted = 4;
      _averageQuizScore = 95.0;
      _bonusStars = 12;
    }
    _initModules();
    _initAchievements();
  }

  int get coins => _coins;
  int get streakDays => _streakDays;
  int get totalQuizzesAttempted => _totalQuizzesAttempted;
  double get averageQuizScore => _averageQuizScore;
  bool get isLoading => _isLoading;
  List<LearningModuleModel> get modules => List.unmodifiable(_modules);
  List<AchievementModel> get achievements => List.unmodifiable(_achievements);

  int get unlockedAchievementsCount =>
      _achievements.where((a) => a.isUnlocked).length;

  int get totalLessonsCompleted =>
      _modules.fold<int>(0, (sum, m) => sum + m.completedLessons);

  int get totalStars =>
      (_modules.fold<int>(0, (sum, m) => sum + (m.completedLessons ~/ 2))) +
      _bonusStars;

  /// Calculate holistic learning percentage across all modules
  double get overallProgress {
    if (_modules.isEmpty) return 0.0;
    final total = _modules.fold<int>(0, (sum, m) => sum + m.totalLessons);
    final completed = _modules.fold<int>(0, (sum, m) => sum + m.completedLessons);
    if (total == 0) return 0.0;
    return (completed / total) * 100;
  }

  void _initModules() {
    final isGlobal = AppFlavor.isGlobal;
    _modules = [
      LearningModuleModel(
        id: AppConstants.moduleAlphabet,
        title: 'Alphabet',
        subtitle: 'Learn A to Z with phonics',
        icon: Icons.sort_by_alpha_rounded,
        route: AppRoutes.alphabet,
        primaryColor: AppColors.primary,
        secondaryColor: AppColors.primaryDark,
        totalLessons: 26,
        completedLessons: isGlobal ? 0 : 8,
        order: 1,
      ),
      LearningModuleModel(
        id: AppConstants.moduleNumbers,
        title: 'Numbers',
        subtitle: 'Count 1 to 20 with fun',
        icon: Icons.format_list_numbered_rounded,
        route: AppRoutes.numbers,
        primaryColor: AppColors.secondary,
        secondaryColor: AppColors.secondaryDark,
        totalLessons: 20,
        completedLessons: isGlobal ? 0 : 6,
        order: 2,
      ),
      LearningModuleModel(
        id: AppConstants.moduleColors,
        title: 'Colors',
        subtitle: 'Explore rainbow colors',
        icon: Icons.palette_rounded,
        route: AppRoutes.colors,
        primaryColor: AppColors.candyPink,
        secondaryColor: const Color(0xFFE91E63),
        totalLessons: 10,
        completedLessons: isGlobal ? 0 : 4,
        order: 3,
      ),
      LearningModuleModel(
        id: AppConstants.moduleShapes,
        title: 'Shapes',
        subtitle: 'Circles, squares & stars',
        icon: Icons.category_rounded,
        route: AppRoutes.shapes,
        primaryColor: AppColors.mintGreen,
        secondaryColor: const Color(0xFF388E3C),
        totalLessons: 8,
        completedLessons: isGlobal ? 0 : 3,
        order: 4,
      ),
      LearningModuleModel(
        id: AppConstants.moduleAnimals,
        title: 'Animals',
        subtitle: 'Meet jungle & farm friends',
        icon: Icons.pets_rounded,
        route: AppRoutes.animals,
        primaryColor: AppColors.coral,
        secondaryColor: const Color(0xFFE64A19),
        totalLessons: 12,
        completedLessons: isGlobal ? 0 : 5,
        order: 5,
      ),
      LearningModuleModel(
        id: AppConstants.moduleFruits,
        title: 'Fruits & Veggies',
        subtitle: 'Healthy & delicious food',
        icon: Icons.apple_rounded,
        route: AppRoutes.fruits,
        primaryColor: AppColors.lavender,
        secondaryColor: const Color(0xFF7B1FA2),
        totalLessons: 12,
        completedLessons: isGlobal ? 0 : 4,
        order: 6,
      ),
      LearningModuleModel(
        id: AppConstants.moduleStories,
        title: 'Bedtime Stories',
        subtitle: 'Delightful bedtime tales',
        icon: Icons.menu_book_rounded,
        route: AppRoutes.stories,
        primaryColor: const Color(0xFF26A69A),
        secondaryColor: const Color(0xFF00796B),
        totalLessons: 6,
        completedLessons: isGlobal ? 0 : 2,
        order: 7,
      ),
      LearningModuleModel(
        id: AppConstants.moduleRhymes,
        title: 'Fun Rhymes',
        subtitle: 'Sing along with sweet songs',
        icon: Icons.music_note_rounded,
        route: AppRoutes.rhymes,
        primaryColor: const Color(0xFFEC407A),
        secondaryColor: const Color(0xFFC2185B),
        totalLessons: 8,
        completedLessons: isGlobal ? 0 : 3,
        order: 8,
      ),
      LearningModuleModel(
        id: AppConstants.moduleQuiz,
        title: 'Quiz Arena',
        subtitle: 'Test knowledge & earn stars',
        icon: Icons.psychology_rounded,
        route: AppRoutes.quiz,
        primaryColor: const Color(0xFFFFA726),
        secondaryColor: const Color(0xFFF57C00),
        totalLessons: 15,
        completedLessons: isGlobal ? 0 : 6,
        order: 9,
      ),
      LearningModuleModel(
        id: AppConstants.moduleProgress,
        title: 'My Progress',
        subtitle: 'Badges, streaks & stats',
        icon: Icons.emoji_events_rounded,
        route: AppRoutes.progress,
        primaryColor: const Color(0xFF7E57C2),
        secondaryColor: const Color(0xFF512DA8),
        totalLessons: 10,
        completedLessons: isGlobal ? 0 : 4,
        order: 10,
      ),
    ];
  }

  void _initAchievements() {
    _achievements = [
      const AchievementModel(
        id: 'badge_alphabet',
        title: 'Alphabet Master',
        description: 'Learn letters and words from A to Z with phonics',
        icon: Icons.sort_by_alpha_rounded,
        badgeColor: Color(0xFF4FC3F7),
        rewardCoins: 50,
        isUnlocked: false,
        requiredCount: 10,
        currentCount: 8,
      ),
      AchievementModel(
        id: 'badge_numbers',
        title: 'Number Wizard',
        description: 'Count up to 10 numbers like a math champ',
        icon: Icons.format_list_numbered_rounded,
        badgeColor: const Color(0xFFFFB300),
        rewardCoins: 50,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 2)),
        requiredCount: 6,
        currentCount: 6,
      ),
      AchievementModel(
        id: 'badge_colors',
        title: 'Rainbow Explorer',
        description: 'Discover beautiful colors and magic mixing secrets',
        icon: Icons.palette_rounded,
        badgeColor: const Color(0xFFFF6584),
        rewardCoins: 40,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 1)),
        requiredCount: 4,
        currentCount: 4,
      ),
      const AchievementModel(
        id: 'badge_shapes',
        title: 'Shape Detective',
        description: 'Find circles, squares, stars, and triangles',
        icon: Icons.category_rounded,
        badgeColor: Color(0xFF66BB6A),
        rewardCoins: 40,
        isUnlocked: false,
        requiredCount: 4,
        currentCount: 3,
      ),
      AchievementModel(
        id: 'badge_animals',
        title: 'Safari Ranger',
        description: 'Hear and identify 5 awesome animal friends',
        icon: Icons.pets_rounded,
        badgeColor: const Color(0xFFFF7043),
        rewardCoins: 50,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(hours: 12)),
        requiredCount: 5,
        currentCount: 5,
      ),
      const AchievementModel(
        id: 'badge_fruits',
        title: 'Healthy Hero',
        description: 'Eat tasty fruits and supercharged veggies',
        icon: Icons.apple_rounded,
        badgeColor: Color(0xFFAB47BC),
        rewardCoins: 40,
        isUnlocked: false,
        requiredCount: 5,
        currentCount: 4,
      ),
      AchievementModel(
        id: 'badge_stories',
        title: 'Story Listener',
        description: 'Listen to bedtime tales and discover moral lessons',
        icon: Icons.menu_book_rounded,
        badgeColor: const Color(0xFF26A69A),
        rewardCoins: 60,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 3)),
        requiredCount: 2,
        currentCount: 2,
      ),
      AchievementModel(
        id: 'badge_quiz',
        title: 'Quiz Superstar',
        description: 'Score 100% in any interactive quiz arena',
        icon: Icons.psychology_rounded,
        badgeColor: const Color(0xFFFFA726),
        rewardCoins: 100,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(hours: 3)),
        requiredCount: 1,
        currentCount: 1,
      ),
      AchievementModel(
        id: 'badge_streak',
        title: 'Streak Champion',
        description: 'Learn every single day for 3 days in a row',
        icon: Icons.local_fire_department_rounded,
        badgeColor: const Color(0xFFE53935),
        rewardCoins: 75,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 1)),
        requiredCount: 3,
        currentCount: 3,
      ),
      const AchievementModel(
        id: 'badge_treasure',
        title: 'Treasure Hunter',
        description: 'Collect over 200 shiny reward coins',
        icon: Icons.monetization_on_rounded,
        badgeColor: Color(0xFFFFD700),
        rewardCoins: 100,
        isUnlocked: false,
        requiredCount: 200,
        currentCount: 150,
      ),
    ];
  }

  /// Award coins when a lesson or quiz is completed
  void addCoins(int amount) {
    if (amount <= 0) return;
    _coins += amount;
    _checkAchievements();
    notifyListeners();
  }

  /// Register completed quiz results
  void addQuizResult({required int score, required int stars, required int earnedCoins}) {
    _totalQuizzesAttempted += 1;
    _averageQuizScore = ((_averageQuizScore * (_totalQuizzesAttempted - 1)) + score) / _totalQuizzesAttempted;
    _bonusStars += stars;
    if (earnedCoins > 0) {
      _coins += earnedCoins;
    }
    _checkAchievements();
    notifyListeners();
  }

  /// Mark a lesson completed for a module and award coins
  void completeLesson(String moduleId, {int coinReward = 10}) {
    final index = _modules.indexWhere((m) => m.id == moduleId);
    if (index != -1) {
      final mod = _modules[index];
      if (mod.completedLessons < mod.totalLessons) {
        _modules[index] = mod.copyWith(
          completedLessons: mod.completedLessons + 1,
        );
        _coins += coinReward;
        _checkAchievements();
        notifyListeners();
      }
    }
  }

  /// Claim an achievement reward if not already claimed
  bool claimAchievementReward(String badgeId) {
    final index = _achievements.indexWhere((a) => a.id == badgeId);
    if (index != -1) {
      final badge = _achievements[index];
      if (badge.isUnlocked) {
        // Can claim coins
        addCoins(badge.rewardCoins);
        return true;
      }
    }
    return false;
  }

  /// Dynamically check unlock criteria for all badges
  void _checkAchievements() {
    final updated = <AchievementModel>[];
    for (final badge in _achievements) {
      int current = badge.currentCount;
      bool unlock = badge.isUnlocked;

      if (badge.id == 'badge_alphabet') {
        final mod = _modules.firstWhere((m) => m.id == AppConstants.moduleAlphabet);
        current = mod.completedLessons;
        if (current >= badge.requiredCount) unlock = true;
      } else if (badge.id == 'badge_numbers') {
        final mod = _modules.firstWhere((m) => m.id == AppConstants.moduleNumbers);
        current = mod.completedLessons;
        if (current >= badge.requiredCount) unlock = true;
      } else if (badge.id == 'badge_treasure') {
        current = _coins;
        if (current >= badge.requiredCount) unlock = true;
      } else if (badge.id == 'badge_streak') {
        current = _streakDays;
        if (current >= badge.requiredCount) unlock = true;
      }

      updated.add(badge.copyWith(
        currentCount: current,
        isUnlocked: unlock,
        unlockedAt: unlock && badge.unlockedAt == null ? DateTime.now() : badge.unlockedAt,
      ));
    }
    _achievements = updated;
  }

  /// Holistic ProgressModel entity representing the learner's overall stats
  ProgressModel get progressData {
    final moduleMap = <String, double>{};
    final completedList = <String>[];
    for (final m in _modules) {
      moduleMap[m.id] = m.progressPercentage;
      if (m.isCompleted) completedList.add(m.id);
    }

    return ProgressModel(
      userId: 'learner_current',
      overallPercentage: overallProgress,
      currentStreakDays: _streakDays,
      totalCoins: _coins,
      totalLessonsCompleted: totalLessonsCompleted,
      totalQuizzesAttempted: _totalQuizzesAttempted,
      averageQuizScore: _averageQuizScore,
      completedModuleIds: completedList,
      moduleProgress: moduleMap,
      lastActiveDate: DateTime.now(),
    );
  }

  /// Reset all learner progress, lessons, and coins (for parental reset)
  void resetProgress() {
    _coins = 100;
    _streakDays = 1;
    _totalQuizzesAttempted = 0;
    _averageQuizScore = 0.0;
    _bonusStars = 0;
    _initModules();
    _modules = _modules.map((m) => m.copyWith(completedLessons: 0)).toList();
    _initAchievements();
    notifyListeners();
  }
}
