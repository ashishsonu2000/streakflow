import '../../../habits/data/entities/habit_log_entity.dart';
import 'activity_item.dart';

class DashboardAnalytics {
  // ==========================
  // Streak
  // ==========================
  final int currentStreak;
  final int longestStreak;

  // ==========================
  // Dashboard Metrics
  // ==========================
  final int totalHabits;
  final int completedToday;
  final int pendingToday;

  /// Percentage (0-100)
  final int weeklyCompletion;

  /// Percentage (0-100)
  final int monthlyCompletion;

  /// Percentage (0-100)
  final double completionRate;

  final int perfectDays;

  // ==========================
  // Gamification
  // ==========================
  final int totalXp;
  final int level;
  final int xpTarget;
  final String achievement;

  // ==========================
  // Progress
  // ==========================
  final int completedDays;
  final int targetDays;

  /// Current completion (0.0 - 1.0)
  final double progress;

  // ==========================
  // Dashboard Sections
  // ==========================
  final List<WeeklyAnalytics> weeklyProgress;

  /// GitHub style heatmap
  final Map<DateTime, int> heatmap;

  final List<ActivityItem> recentActivity;

  const DashboardAnalytics({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalHabits,
    required this.completedToday,
    required this.pendingToday,
    required this.weeklyCompletion,
    this.monthlyCompletion = 0,
    this.completionRate = 0,
    required this.perfectDays,
    required this.totalXp,
    required this.level,
    required this.xpTarget,
    required this.achievement,
    required this.completedDays,
    required this.targetDays,
    required this.progress,
    required this.weeklyProgress,
    required this.recentActivity,
    this.heatmap = const {},
  });

  bool get hasHabits => totalHabits > 0;

  bool get completedAllToday =>
      totalHabits > 0 && completedToday == totalHabits;

  int get pendingPercentage {
    if (totalHabits == 0) return 0;

    return ((pendingToday / totalHabits) * 100).round();
  }

  int get completedPercentage {
    if (totalHabits == 0) return 0;

    return ((completedToday / totalHabits) * 100).round();
  }

  double get xpProgress {
    if (xpTarget == 0) return 0;

    return totalXp / xpTarget;
  }
}

class WeeklyAnalytics {
  final DateTime date;

  final bool completed;

  final int completedHabits;

  final int totalHabits;

  const WeeklyAnalytics({
    required this.date,
    required this.completed,
    this.completedHabits = 0,
    this.totalHabits = 0,
  });

  double get progress {
    if (totalHabits == 0) {
      return 0;
    }

    return completedHabits / totalHabits;
  }

  int get completionPercentage {
    if (totalHabits == 0) {
      return 0;
    }

    return ((completedHabits / totalHabits) * 100).round();
  }
}
