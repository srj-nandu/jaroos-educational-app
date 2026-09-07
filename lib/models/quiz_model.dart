/// Represents a single interactive multiple choice question for young learners.
class QuizQuestion {
  final String id;
  final String moduleId;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String hint;
  final String? imageAsset;

  const QuizQuestion({
    required this.id,
    required this.moduleId,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.explanation = '',
    this.hint = '',
    this.imageAsset,
  });

  bool isCorrect(int selectedIndex) => selectedIndex == correctOptionIndex;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      moduleId: json['moduleId'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List? ?? []),
      correctOptionIndex: (json['correctOptionIndex'] as num? ?? 0).toInt(),
      explanation: json['explanation'] as String? ?? '',
      hint: json['hint'] as String? ?? '',
      imageAsset: json['imageAsset'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moduleId': moduleId,
      'question': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
      'hint': hint,
      'imageAsset': imageAsset,
    };
  }
}

/// Represents the completed evaluation outcome of a quiz attempt.
class QuizResult {
  final String id;
  final String moduleId;
  final String userId;
  final int totalQuestions;
  final int correctAnswers;
  final double scorePercentage;
  final int starsEarned;
  final int coinsEarned;
  final DateTime completedAt;

  const QuizResult({
    required this.id,
    required this.moduleId,
    required this.userId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.scorePercentage,
    required this.starsEarned,
    required this.coinsEarned,
    required this.completedAt,
  });

  /// Calculate stars and score using the academic project scoring formula:
  /// score = (correct_answers / total_questions) * 100
  factory QuizResult.calculate({
    required String id,
    required String moduleId,
    required String userId,
    required int totalQuestions,
    required int correctAnswers,
  }) {
    final double score = totalQuestions > 0
        ? ((correctAnswers / totalQuestions) * 100)
        : 0.0;

    int stars;
    if (score >= 90) {
      stars = 3;
    } else if (score >= 60) {
      stars = 2;
    } else if (score >= 30) {
      stars = 1;
    } else {
      stars = 0;
    }

    final coins = correctAnswers * 10;

    return QuizResult(
      id: id,
      moduleId: moduleId,
      userId: userId,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      scorePercentage: score,
      starsEarned: stars,
      coinsEarned: coins,
      completedAt: DateTime.now(),
    );
  }

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['id'] as String,
      moduleId: json['moduleId'] as String,
      userId: json['userId'] as String? ?? '',
      totalQuestions: (json['totalQuestions'] as num? ?? 0).toInt(),
      correctAnswers: (json['correctAnswers'] as num? ?? 0).toInt(),
      scorePercentage: (json['scorePercentage'] as num? ?? 0.0).toDouble(),
      starsEarned: (json['starsEarned'] as num? ?? 0).toInt(),
      coinsEarned: (json['coinsEarned'] as num? ?? 0).toInt(),
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moduleId': moduleId,
      'userId': userId,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'scorePercentage': scorePercentage,
      'starsEarned': starsEarned,
      'coinsEarned': coinsEarned,
      'completedAt': completedAt.toIso8601String(),
    };
  }
}
