/// Represents a message in the child-friendly AI conversation stream.
class AiChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? emotionEmoji;

  const AiChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.emotionEmoji,
  });
}

/// Represents an AI-generated personalized bedtime or moral story for kids.
class GeneratedStory {
  final String id;
  final String title;
  final String hero;
  final String theme;
  final String setting;
  final List<String> paragraphs;
  final String moral;
  final String heroEmoji;
  final DateTime createdAt;

  const GeneratedStory({
    required this.id,
    required this.title,
    required this.hero,
    required this.theme,
    required this.setting,
    required this.paragraphs,
    required this.moral,
    required this.heroEmoji,
    required this.createdAt,
  });

  String get fullStoryText => paragraphs.join('\n\n');
}

/// Represents child speech / phonics pronunciation feedback.
class PronunciationFeedback {
  final String targetWord;
  final String spokenWord;
  final int accuracyScore; // 0 to 100
  final String feedbackMessage;
  final bool isSuperStar;

  const PronunciationFeedback({
    required this.targetWord,
    required this.spokenWord,
    required this.accuracyScore,
    required this.feedbackMessage,
    required this.isSuperStar,
  });
}
