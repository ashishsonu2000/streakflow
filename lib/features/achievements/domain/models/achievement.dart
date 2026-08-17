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
}