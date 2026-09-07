import 'package:flutter_test/flutter_test.dart';
import 'package:jaroos/core/config/app_flavor.dart';
import 'package:jaroos/core/constants/app_constants.dart';
import 'package:jaroos/providers/learning_provider.dart';

void main() {
  group('LearningProvider State Management Tests', () {
    late LearningProvider learningProvider;

    setUp(() {
      learningProvider = LearningProvider();
    });

    test('Initializes with all 10 learning modules', () {
      expect(learningProvider.modules.length, 10);

      final moduleIds = learningProvider.modules.map((m) => m.id).toList();
      expect(moduleIds, contains(AppConstants.moduleAlphabet));
      expect(moduleIds, contains(AppConstants.moduleNumbers));
      expect(moduleIds, contains(AppConstants.moduleColors));
      expect(moduleIds, contains(AppConstants.moduleShapes));
      expect(moduleIds, contains(AppConstants.moduleAnimals));
      expect(moduleIds, contains(AppConstants.moduleFruits));
      expect(moduleIds, contains(AppConstants.moduleStories));
      expect(moduleIds, contains(AppConstants.moduleRhymes));
      expect(moduleIds, contains(AppConstants.moduleQuiz));
      expect(moduleIds, contains(AppConstants.moduleProgress));
    });

    test('Initializes with default coins and streak days', () {
      final expectedCoins = AppFlavor.isGlobal ? 0 : 320;
      final expectedStreak = AppFlavor.isGlobal ? 0 : 7;
      expect(learningProvider.coins, expectedCoins);
      expect(learningProvider.streakDays, expectedStreak);
    });

    test('Overall progress is calculated accurately', () {
      final progress = learningProvider.overallProgress;
      expect(progress, greaterThan(0));
      expect(progress, lessThanOrEqualTo(100));
    });

    test('addCoins increases coins balance', () {
      final initialCoins = learningProvider.coins;
      learningProvider.addCoins(50);
      expect(learningProvider.coins, initialCoins + 50);

      // Negative or zero coins should have no effect
      learningProvider.addCoins(0);
      expect(learningProvider.coins, initialCoins + 50);
      learningProvider.addCoins(-10);
      expect(learningProvider.coins, initialCoins + 50);
    });

    test('completeLesson increases completed count and awards coins', () {
      final initialAlphabet = learningProvider.modules.firstWhere(
        (m) => m.id == AppConstants.moduleAlphabet,
      );
      final initialCompleted = initialAlphabet.completedLessons;
      final initialCoins = learningProvider.coins;

      learningProvider.completeLesson(AppConstants.moduleAlphabet, coinReward: 20);

      final updatedAlphabet = learningProvider.modules.firstWhere(
        (m) => m.id == AppConstants.moduleAlphabet,
      );
      expect(updatedAlphabet.completedLessons, initialCompleted + 1);
      expect(learningProvider.coins, initialCoins + 20);
    });
  });
}
