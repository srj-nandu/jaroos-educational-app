/// Represents an individual lesson unit within any learning module
/// (e.g. Letter 'A' in Alphabet, Number '5' in Numbers, 'Circle' in Shapes).
class LessonModel {
  final String id;
  final String moduleId;
  final String title;
  final String symbol;
  final String pronunciationWord;
  final String description;
  final String funFact;
  final String imageAsset;
  final int order;
  final bool isCompleted;

  const LessonModel({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.symbol,
    required this.pronunciationWord,
    this.description = '',
    this.funFact = '',
    this.imageAsset = '',
    required this.order,
    this.isCompleted = false,
  });

  LessonModel copyWith({
    String? id,
    String? moduleId,
    String? title,
    String? symbol,
    String? pronunciationWord,
    String? description,
    String? funFact,
    String? imageAsset,
    int? order,
    bool? isCompleted,
  }) {
    return LessonModel(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      symbol: symbol ?? this.symbol,
      pronunciationWord: pronunciationWord ?? this.pronunciationWord,
      description: description ?? this.description,
      funFact: funFact ?? this.funFact,
      imageAsset: imageAsset ?? this.imageAsset,
      order: order ?? this.order,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String,
      moduleId: json['moduleId'] as String,
      title: json['title'] as String,
      symbol: json['symbol'] as String? ?? '',
      pronunciationWord: json['pronunciationWord'] as String? ?? '',
      description: json['description'] as String? ?? '',
      funFact: json['funFact'] as String? ?? '',
      imageAsset: json['imageAsset'] as String? ?? '',
      order: (json['order'] as num? ?? 0).toInt(),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moduleId': moduleId,
      'title': title,
      'symbol': symbol,
      'pronunciationWord': pronunciationWord,
      'description': description,
      'funFact': funFact,
      'imageAsset': imageAsset,
      'order': order,
      'isCompleted': isCompleted,
    };
  }
}
