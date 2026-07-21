import 'package:flutter/foundation.dart';

@immutable
class DashboardSummary {
  const DashboardSummary({
    required this.totalHabits,
    required this.activeHabits,
    required this.archivedHabits,
    required this.completedToday,
    required this.pendingToday,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalCompletions,
    required this.totalXp,
    required this.level,
    required this.previousLevelXp,
    required this.nextLevelXp,
    required this.xpProgress,
    required this.weeklyCompletion,
    required this.monthlyCompletion,
    required this.successRate,
  });

  /// Habits
  final int totalHabits;
  final int activeHabits;
  final int archivedHabits;

  /// Today
  final int completedToday;
  final int pendingToday;

  /// Streaks
  final int currentStreak;
  final int bestStreak;

  /// Overall Progress
  final int totalCompletions;
  final int totalXp;

  /// Level System
  final int level;
  final int previousLevelXp;
  final int nextLevelXp;

  /// Value between 0.0 and 1.0
  final double xpProgress;

  /// Percentage (0–100)
  final double weeklyCompletion;
  final double monthlyCompletion;
  final double successRate;

  // ---------------------------------------------------------------------------
  // Derived Properties
  // ---------------------------------------------------------------------------

  double get todayCompletionPercentage {
    if (totalHabits == 0) return 0;
    return (completedToday / totalHabits) * 100;
  }

  bool get allCompletedToday =>
      totalHabits > 0 && completedToday == totalHabits;

  int get remainingHabits => totalHabits - completedToday;

  int get remainingXp => (nextLevelXp - totalXp).clamp(0, nextLevelXp);

  // ---------------------------------------------------------------------------
  // Empty
  // ---------------------------------------------------------------------------

  factory DashboardSummary.empty() {
    return const DashboardSummary(
      totalHabits: 0,
      activeHabits: 0,
      archivedHabits: 0,
      completedToday: 0,
      pendingToday: 0,
      currentStreak: 0,
      bestStreak: 0,
      totalCompletions: 0,
      totalXp: 0,
      level: 1,
      previousLevelXp: 0,
      nextLevelXp: 100,
      xpProgress: 0,
      weeklyCompletion: 0,
      monthlyCompletion: 0,
      successRate: 0,
    );
  }

  // ---------------------------------------------------------------------------
  // CopyWith
  // ---------------------------------------------------------------------------

  DashboardSummary copyWith({
    int? totalHabits,
    int? activeHabits,
    int? archivedHabits,
    int? completedToday,
    int? pendingToday,
    int? currentStreak,
    int? bestStreak,
    int? totalCompletions,
    int? totalXp,
    int? level,
    int? previousLevelXp,
    int? nextLevelXp,
    double? xpProgress,
    double? weeklyCompletion,
    double? monthlyCompletion,
    double? successRate,
  }) {
    return DashboardSummary(
      totalHabits: totalHabits ?? this.totalHabits,
      activeHabits: activeHabits ?? this.activeHabits,
      archivedHabits: archivedHabits ?? this.archivedHabits,
      completedToday: completedToday ?? this.completedToday,
      pendingToday: pendingToday ?? this.pendingToday,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      totalCompletions: totalCompletions ?? this.totalCompletions,
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      previousLevelXp: previousLevelXp ?? this.previousLevelXp,
      nextLevelXp: nextLevelXp ?? this.nextLevelXp,
      xpProgress: xpProgress ?? this.xpProgress,
      weeklyCompletion: weeklyCompletion ?? this.weeklyCompletion,
      monthlyCompletion: monthlyCompletion ?? this.monthlyCompletion,
      successRate: successRate ?? this.successRate,
    );
  }

  @override
  String toString() {
    return 'DashboardSummary('
        'totalHabits: $totalHabits, '
        'activeHabits: $activeHabits, '
        'archivedHabits: $archivedHabits, '
        'completedToday: $completedToday, '
        'pendingToday: $pendingToday, '
        'currentStreak: $currentStreak, '
        'bestStreak: $bestStreak, '
        'totalCompletions: $totalCompletions, '
        'totalXp: $totalXp, '
        'level: $level'
        ')';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardSummary &&
          runtimeType == other.runtimeType &&
          totalHabits == other.totalHabits &&
          activeHabits == other.activeHabits &&
          archivedHabits == other.archivedHabits &&
          completedToday == other.completedToday &&
          pendingToday == other.pendingToday &&
          currentStreak == other.currentStreak &&
          bestStreak == other.bestStreak &&
          totalCompletions == other.totalCompletions &&
          totalXp == other.totalXp &&
          level == other.level &&
          previousLevelXp == other.previousLevelXp &&
          nextLevelXp == other.nextLevelXp &&
          xpProgress == other.xpProgress &&
          weeklyCompletion == other.weeklyCompletion &&
          monthlyCompletion == other.monthlyCompletion &&
          successRate == other.successRate;

  @override
  int get hashCode => Object.hash(
        totalHabits,
        activeHabits,
        archivedHabits,
        completedToday,
        pendingToday,
        currentStreak,
        bestStreak,
        totalCompletions,
        totalXp,
        level,
        previousLevelXp,
        nextLevelXp,
        xpProgress,
        weeklyCompletion,
        monthlyCompletion,
        successRate,
      );
}
