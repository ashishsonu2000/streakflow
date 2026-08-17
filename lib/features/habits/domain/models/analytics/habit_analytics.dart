import 'package:flutter/foundation.dart';

import '../xp_level.dart';

@immutable
class HabitAnalytics {
  const HabitAnalytics({
    // ==========================================================
    // Dashboard metrics
    // ==========================================================

    required this.totalHabits,
    required this.activeHabits,
    required this.archivedHabits,
    required this.completedToday,
    required this.pendingToday,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalCompleted,
    required this.totalXp,
    required this.level,
    required this.todayPercent,
    required this.todayProgress,

    // ==========================================================
    // Sprint 6 analytics
    // ==========================================================

    this.completionRate = 0,
    this.weeklyCompletion = const {},
    this.monthlyCompletion = const {},
    this.heatmap = const {},
  });

  // ==========================================================
  // Dashboard
  // ==========================================================

  final int totalHabits;

  final int activeHabits;

  final int archivedHabits;

  final int completedToday;

  final int pendingToday;

  final int currentStreak;

  final int bestStreak;

  final int totalCompleted;

  final int totalXp;

  final XPLevel level;

  final double todayProgress;

  final String todayPercent;

  // ==========================================================
  // Analytics
  // ==========================================================

  /// Percentage of successful completions.

  final double completionRate;

  /// Last 7 days.

  final Map<DateTime, int> weeklyCompletion;

  /// Current month.

  final Map<DateTime, int> monthlyCompletion;

  /// GitHub-style activity data.

  final Map<DateTime, int> heatmap;

  // ==========================================================
  // Convenience getters
  // ==========================================================

  bool get hasActivity => totalCompleted > 0;

  int get longestStreak => bestStreak;
}