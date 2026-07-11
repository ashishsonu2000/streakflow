import '../../data/entities/habit_log_entity.dart';
import '../models/analytics_summary.dart';
import '../models/habit.dart';
import '../models/habit_statistics.dart';
import '../models/heatmap_day.dart';
import '../models/monthly_progress.dart';
import '../models/weekly_progress.dart';

class HabitAnalyticsService {
  const HabitAnalyticsService();

  /// ------------------------------------------------------------
  /// Main Entry Point
  /// ------------------------------------------------------------
  AnalyticsSummary build(
    Habit habit,
    List<HabitLogEntity> logs,
  ) {
    return AnalyticsSummary(
      habit: habit,
      statistics: _buildStatistics(
        habit,
        logs,
      ),
      weeklyProgress: _buildWeeklyProgress(logs),
      monthlyProgress: _buildMonthlyProgress(
        habit,
        logs,
      ),
      heatmap: _buildHeatmap(logs),
      logs: logs,
    );
  }

  /// ------------------------------------------------------------
  /// Statistics
  /// ------------------------------------------------------------
  HabitStatistics _buildStatistics(
    Habit habit,
    List<HabitLogEntity> logs,
  ) {
    final trackedDays = _trackedDays(habit);
    final completedDays = logs.length;

    final missedDays = (trackedDays - completedDays).clamp(0, trackedDays);

    return HabitStatistics(
      currentStreak: habit.currentStreak,
      bestStreak: habit.bestStreak,
      totalCompleted: completedDays,
      totalMissed: missedDays,
      totalTrackedDays: trackedDays,
      activeDays: _activeDays(logs),
      totalXP: habit.xp,
      completionRate: _completionRate(
        trackedDays,
        completedDays,
      ),
      successRate: _successRate(
        trackedDays,
        completedDays,
      ),
      averagePerWeek: _averagePerWeek(
        trackedDays,
        completedDays,
      ),
      longestGap: _longestGap(logs),
    );
  }

  /// ------------------------------------------------------------
  /// Implemented in Part 2
  /// ------------------------------------------------------------
  WeeklyProgress _buildWeeklyProgress(
    List<HabitLogEntity> logs,
  ) {
    final today = DateTime.now();

    final start = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: 6));

    final items = <WeekDayProgress>[];

    int completed = 0;

    for (int i = 0; i < 7; i++) {
      final date = start.add(Duration(days: i));

      final isCompleted = logs.any(
        (log) =>
            log.date.year == date.year &&
            log.date.month == date.month &&
            log.date.day == date.day,
      );

      if (isCompleted) {
        completed++;
      }

      items.add(
        WeekDayProgress(
          day: _weekday(date),
          date: date,
          completed: isCompleted,
          isToday: _sameDay(date, today),
        ),
      );
    }

    return WeeklyProgress(
      days: items,
      completedCount: completed,
    );
  }

  MonthlyProgress _buildMonthlyProgress(
    Habit habit,
    List<HabitLogEntity> logs,
  ) {
    final now = DateTime.now();

    final completed = logs
        .where(
          (log) => log.date.year == now.year && log.date.month == now.month,
        )
        .length;

    final elapsedDays = now.day;

    final totalDays = DateTime(
      now.year,
      now.month + 1,
      0,
    ).day;

    final missed = (elapsedDays - completed).clamp(0, elapsedDays);

    return MonthlyProgress(
      month: now.month,
      year: now.year,
      completedDays: completed,
      missedDays: missed,
      targetDays: totalDays,
      completionRate: elapsedDays == 0 ? 0 : completed / elapsedDays,
    );
  }

  List<HeatmapDay> _buildHeatmap(
    List<HabitLogEntity> logs,
  ) {
    return logs.map((log) {
      return HeatmapDay(
        date: DateTime(
          log.date.year,
          log.date.month,
          log.date.day,
        ),
        completed: true,
        intensity: _calculateIntensity(
          log.xpEarned,
        ),
        xp: log.xpEarned,
      );
    }).toList();
  }

  /// ------------------------------------------------------------
  /// Helper Methods
  /// ------------------------------------------------------------

  int _trackedDays(Habit habit) {
    final days = DateTime.now().difference(habit.createdAt).inDays + 1;

    return days < 1 ? 1 : days;
  }

  int _activeDays(
    List<HabitLogEntity> logs,
  ) {
    return logs
        .map(
          (e) => DateTime(
            e.date.year,
            e.date.month,
            e.date.day,
          ),
        )
        .toSet()
        .length;
  }

  double _completionRate(
    int trackedDays,
    int completedDays,
  ) {
    if (trackedDays == 0) return 0;

    return completedDays / trackedDays;
  }

  double _successRate(
    int trackedDays,
    int completedDays,
  ) {
    if (trackedDays == 0) return 0;

    return (completedDays / trackedDays) * 100;
  }

  double _averagePerWeek(
    int trackedDays,
    int completedDays,
  ) {
    if (trackedDays == 0) return 0;

    final weeks = trackedDays / 7;

    return weeks == 0 ? 0 : completedDays / weeks;
  }

  int _longestGap(
    List<HabitLogEntity> logs,
  ) {
    if (logs.length < 2) return 0;

    final sorted = [...logs]..sort(
        (a, b) => a.date.compareTo(b.date),
      );

    int longest = 0;

    for (int i = 1; i < sorted.length; i++) {
      final gap = sorted[i].date.difference(sorted[i - 1].date).inDays - 1;

      if (gap > longest) {
        longest = gap;
      }
    }

    return longest;
  }

  bool _sameDay(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _weekday(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return "M";
      case DateTime.tuesday:
        return "T";
      case DateTime.wednesday:
        return "W";
      case DateTime.thursday:
        return "T";
      case DateTime.friday:
        return "F";
      case DateTime.saturday:
        return "S";
      case DateTime.sunday:
        return "S";
    }
    return "";
  }

  int _calculateIntensity(int xp) {
    if (xp >= 40) return 4;
    if (xp >= 30) return 3;
    if (xp >= 20) return 2;
    if (xp >= 10) return 1;
    return 0;
  }
}
