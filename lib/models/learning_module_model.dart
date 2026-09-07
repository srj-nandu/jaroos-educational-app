import 'package:flutter/material.dart';

/// Represents an educational module on the JAROOS dashboard (e.g., Alphabet, Numbers, Colors, Shapes).
class LearningModuleModel {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color primaryColor;
  final Color secondaryColor;
  final int totalLessons;
  final int completedLessons;
  final int order;

  const LearningModuleModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.primaryColor,
    required this.secondaryColor,
    this.totalLessons = 0,
    this.completedLessons = 0,
    required this.order,
  });

  double get progressPercentage =>
      totalLessons > 0 ? (completedLessons / totalLessons).clamp(0.0, 1.0) : 0.0;

  bool get isCompleted => totalLessons > 0 && completedLessons >= totalLessons;

  LearningModuleModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    IconData? icon,
    String? route,
    Color? primaryColor,
    Color? secondaryColor,
    int? totalLessons,
    int? completedLessons,
    int? order,
  }) {
    return LearningModuleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      totalLessons: totalLessons ?? this.totalLessons,
      completedLessons: completedLessons ?? this.completedLessons,
      order: order ?? this.order,
    );
  }

  factory LearningModuleModel.fromJson(Map<String, dynamic> json) {
    return LearningModuleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      icon: IconData(json['iconCodePoint'] as int? ?? Icons.school.codePoint, fontFamily: 'MaterialIcons'),
      route: json['route'] as String,
      primaryColor: Color(json['primaryColor'] as int? ?? 0xFF4FC3F7),
      secondaryColor: Color(json['secondaryColor'] as int? ?? 0xFF29B6F6),
      totalLessons: (json['totalLessons'] as num? ?? 0).toInt(),
      completedLessons: (json['completedLessons'] as num? ?? 0).toInt(),
      order: (json['order'] as num? ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'iconCodePoint': icon.codePoint,
      'route': route,
      'primaryColor': primaryColor.toARGB32(),
      'secondaryColor': secondaryColor.toARGB32(),
      'totalLessons': totalLessons,
      'completedLessons': completedLessons,
      'order': order,
    };
  }
}
