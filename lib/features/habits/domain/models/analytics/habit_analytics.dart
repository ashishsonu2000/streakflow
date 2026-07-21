import 'package:flutter/foundation.dart';

import '../xp_level.dart';

@immutable
class HabitAnalytics {
  const HabitAnalytics({
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
  });

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
}
