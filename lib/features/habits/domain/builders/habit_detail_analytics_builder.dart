import '../../../../core/models/completion_trend.dart';
import '../models/analytics/habit_details_analytics.dart';
import '../models/analytics/heatmap_day.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';

class HabitDetailAnalyticsBuilder {
  const HabitDetailAnalyticsBuilder._();

  static HabitDetailAnalytics build(
      Habit habit,
      List<HabitLog> logs,
      ) {
    return HabitDetailAnalytics(
      completionRate: _completionRate(
        habit,
        logs,
      ),
      currentStreak: habit.currentStreak,
      bestStreak: habit.bestStreak,
      totalCompleted: habit.totalCompleted,
      totalXp: habit.xp,
      weeklyData: _weekly(logs),
      monthlyData: _monthly(logs),
      heatmap: _heatmap(logs),
    );
  }

  static double _completionRate(
      Habit habit,
      List<HabitLog> logs,
      ) {
    if (logs.isEmpty) {
      return 0;
    }

    final firstLog = logs
        .map(
          (log) => log.date,
    )
        .reduce(
          (a, b) => a.isBefore(b)
          ? a
          : b,
    );

    final trackedDays =
        DateTime.now()
            .difference(firstLog)
            .inDays +
            1;

    if (trackedDays <= 0) {
      return 0;
    }

    return (habit.totalCompleted / trackedDays)
        .clamp(
      0.0,
      1.0,
    );
  }

  static List<CompletionTrend> _weekly(
      List<HabitLog> logs,
      ) {
    final now = DateTime.now();

    return List.generate(
      7,
          (index) {
        final day = now.subtract(
          Duration(
            days: 6 - index,
          ),
        );

        final completed = logs.any(
              (log) => _sameDay(
            log.date,
            day,
          ),
        );

        return CompletionTrend(
          date: day,
          completionRate:
          completed ? 1.0 : 0.0,
        );
      },
    );
  }

  static List<CompletionTrend> _monthly(
      List<HabitLog> logs,
      ) {
    final now = DateTime.now();

    return List.generate(
      30,
          (index) {
        final day = now.subtract(
          Duration(
            days: 29 - index,
          ),
        );

        final completed = logs.any(
              (log) => _sameDay(
            log.date,
            day,
          ),
        );

        return CompletionTrend(
          date: day,
          completionRate:
          completed ? 1.0 : 0.0,
        );
      },
    );
  }

  static List<HeatmapDay> _heatmap(
      List<HabitLog> logs,
      ) {
    final now = DateTime.now();

    return List.generate(
      365,
          (index) {
        final day = now.subtract(
          Duration(
            days: 364 - index,
          ),
        );

        final count = logs.where(
              (log) {
            return _sameDay(
              log.date,
              day,
            );
          },
        ).length;

        return HeatmapDay(
          date: day,
          count: count,
        );
      },
    );
  }

  static bool _sameDay(
      DateTime a,
      DateTime b,
      ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}