/// Tracks a young learner's holistic educational progress across JAROOS modules.
class ProgressModel {
  final String userId;
  final double overallPercentage;
  final int currentStreakDays;
  final int totalCoins;
  final int totalLessonsCompleted;
  final int totalQuizzesAttempted;
  final double averageQuizScore;
  final List<String> completedModuleIds;
  final Map<String, double> moduleProgress;
  final DateTime lastActiveDate;

  const ProgressModel({
    required this.userId,
    this.overallPercentage = 0.0,
    this.currentStreakDays = 1,
    this.totalCoins = 100,
    this.totalLessonsCompleted = 0,
    this.totalQuizzesAttempted = 0,
    this.averageQuizScore = 0.0,
    this.completedModuleIds = const [],
    this.moduleProgress = const {},
    required this.lastActiveDate,
  });

  ProgressModel copyWith({
    String? userId,
    double? overallPercentage,
    int? currentStreakDays,
    int? totalCoins,
    int? totalLessonsCompleted,
    int? totalQuizzesAttempted,
    double? averageQuizScore,
    List<String>? completedModuleIds,
    Map<String, double>? moduleProgress,
    DateTime? lastActiveDate,
  }) {
    return ProgressModel(
      userId: userId ?? this.userId,
      overallPercentage: overallPercentage ?? this.overallPercentage,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      totalCoins: totalCoins ?? this.totalCoins,
      totalLessonsCompleted: totalLessonsCompleted ?? this.totalLessonsCompleted,
      totalQuizzesAttempted: totalQuizzesAttempted ?? this.totalQuizzesAttempted,
      averageQuizScore: averageQuizScore ?? this.averageQuizScore,
      completedModuleIds: completedModuleIds ?? this.completedModuleIds,
      moduleProgress: moduleProgress ?? this.moduleProgress,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    final rawModuleProgress = json['moduleProgress'] as Map<String, dynamic>? ?? {};
    final parsedModuleProgress = rawModuleProgress.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );

    return ProgressModel(
      userId: json['userId'] as String? ?? '',
      overallPercentage: (json['overallPercentage'] as num? ?? 0.0).toDouble(),
      currentStreakDays: (json['currentStreakDays'] as num? ?? 1).toInt(),
      totalCoins: (json['totalCoins'] as num? ?? 100).toInt(),
      totalLessonsCompleted: (json['totalLessonsCompleted'] as num? ?? 0).toInt(),
      totalQuizzesAttempted: (json['totalQuizzesAttempted'] as num? ?? 0).toInt(),
      averageQuizScore: (json['averageQuizScore'] as num? ?? 0.0).toDouble(),
      completedModuleIds: List<String>.from(json['completedModuleIds'] as List? ?? []),
      moduleProgress: parsedModuleProgress,
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.tryParse(json['lastActiveDate'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'overallPercentage': overallPercentage,
      'currentStreakDays': currentStreakDays,
      'totalCoins': totalCoins,
      'totalLessonsCompleted': totalLessonsCompleted,
      'totalQuizzesAttempted': totalQuizzesAttempted,
      'averageQuizScore': averageQuizScore,
      'completedModuleIds': completedModuleIds,
      'moduleProgress': moduleProgress,
      'lastActiveDate': lastActiveDate.toIso8601String(),
    };
  }
}
