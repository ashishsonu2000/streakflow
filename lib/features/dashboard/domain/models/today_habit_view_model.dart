import 'package:flutter/material.dart';

class TodayHabitViewModel {
  const TodayHabitViewModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.completed,
    required this.currentStreak,
    required this.durationMinutes,
    required this.target,
    required this.category,
    required this.difficulty,
  });

  final String id;

  final String title;

  final IconData icon;

  final Color color;

  final bool completed;

  final int currentStreak;

  final int durationMinutes;

  final int target;

  final String category;

  final String difficulty;

  double get progress => completed ? 1 : 0;

  String get progressLabel => completed ? "Completed Today" : "Pending";
}
