import '../../../habits/data/entities/habit_log_entity.dart';
import '../../../habits/domain/models/habit.dart';

class DashboardMetricsResult {
  final int totalHabits;

  final int completedToday;

  final int pendingToday;

  final int weeklyCompletion;

  final int monthlyCompletion;

  final double completionRate;

  final double progress;

  const DashboardMetricsResult({
    required this.totalHabits,
    required this.completedToday,
    required this.pendingToday,
    required this.weeklyCompletion,
    required this.monthlyCompletion,
    required this.completionRate,
    required this.progress,
  });
}

class MetricsCalculator {
  const MetricsCalculator._();

  static DashboardMetricsResult calculate(
    List<Habit> habits,
    List<HabitLogEntity> logs,
  ) {
    final totalHabits = habits.length;

    final today = DateTime.now();

    final todayOnly = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final weekStart = todayOnly.subtract(
      Duration(days: todayOnly.weekday - 1),
    );

    final monthStart = DateTime(
      today.year,
      today.month,
      1,
    );

    final completedToday =
        logs.where((log) => _sameDay(log.date, todayOnly)).length;

    final pendingToday = totalHabits - completedToday;

    final weeklyLogs = logs.where(
      (log) => !log.date.isBefore(weekStart),
    );

    final monthlyLogs = logs.where(
      (log) => !log.date.isBefore(monthStart),
    );

    final weeklyTarget = totalHabits * 7;
    final monthlyTarget = totalHabits * today.day;

    final weeklyCompletion = weeklyTarget == 0
        ? 0
        : ((weeklyLogs.length / weeklyTarget) * 100).round();

    final monthlyCompletion = monthlyTarget == 0
        ? 0
        : ((monthlyLogs.length / monthlyTarget) * 100).round();

    final double completionRate =
        totalHabits == 0 ? 0.0 : completedToday / totalHabits;

    final double progress = completionRate;

    return DashboardMetricsResult(
      totalHabits: totalHabits,
      completedToday: completedToday,
      pendingToday: pendingToday < 0 ? 0 : pendingToday,
      weeklyCompletion: weeklyCompletion,
      monthlyCompletion: monthlyCompletion,
      completionRate: completionRate,
      progress: progress,
    );
  }

  static bool _sameDay(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
