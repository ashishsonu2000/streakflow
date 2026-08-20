import 'package:flutter/material.dart';

import '../enums/achievement_type.dart';

@immutable
class Achievement {
  const Achievement({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
    required this.progress,
    required this.category,
    required this.currentValue,
    required this.targetValue,
  });

  final AchievementType type;

  final String title;

  final String description;

  final IconData icon;

  final bool unlocked;

  final double progress;

  final String category;

  final int currentValue;

  final int targetValue;

  Achievement copyWith({
    AchievementType? type,
    String? title,
    String? description,
    IconData? icon,
    bool? unlocked,
    double? progress,
    String? category,
    int? currentValue,
    int? targetValue,
  }) {
    return Achievement(
      type: type ?? this.type,
      title: title ?? this.title,
      description:
      description ?? this.description,
      icon: icon ?? this.icon,
      unlocked: unlocked ?? this.unlocked,
      progress: progress ?? this.progress,
      category: category ?? this.category,
      currentValue:
      currentValue ?? this.currentValue,
      targetValue:
      targetValue ?? this.targetValue,
    );
  }
}