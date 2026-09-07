import 'package:flutter/material.dart';

/// Represents an unlockable reward badge / achievement in JAROOS.
class AchievementModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color badgeColor;
  final int rewardCoins;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int requiredCount;
  final int currentCount;

  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.badgeColor,
    this.rewardCoins = 50,
    this.isUnlocked = false,
    this.unlockedAt,
    this.requiredCount = 1,
    this.currentCount = 0,
  });

  double get progressPercentage =>
      requiredCount > 0 ? (currentCount / requiredCount).clamp(0.0, 1.0) : 0.0;

  AchievementModel copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    Color? badgeColor,
    int? rewardCoins,
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? requiredCount,
    int? currentCount,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      badgeColor: badgeColor ?? this.badgeColor,
      rewardCoins: rewardCoins ?? this.rewardCoins,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      requiredCount: requiredCount ?? this.requiredCount,
      currentCount: currentCount ?? this.currentCount,
    );
  }

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      icon: IconData(json['iconCodePoint'] as int? ?? Icons.star.codePoint, fontFamily: 'MaterialIcons'),
      badgeColor: Color(json['badgeColor'] as int? ?? 0xFFFFD700),
      rewardCoins: (json['rewardCoins'] as num? ?? 50).toInt(),
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.tryParse(json['unlockedAt'] as String)
          : null,
      requiredCount: (json['requiredCount'] as num? ?? 1).toInt(),
      currentCount: (json['currentCount'] as num? ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconCodePoint': icon.codePoint,
      'badgeColor': badgeColor.toARGB32(),
      'rewardCoins': rewardCoins,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'requiredCount': requiredCount,
      'currentCount': currentCount,
    };
  }
}
