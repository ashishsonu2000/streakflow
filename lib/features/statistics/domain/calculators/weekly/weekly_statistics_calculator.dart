import '../../../../../core/utils/date_utils.dart';
import '../../../../habits/domain/models/habit_log.dart';
import '../../engine/calculator.dart';
import '../../engine/statistics_context.dart';
import '../../models/weekday_statistics.dart';
import '../../models/weekly_statistics.dart';
import '../../models/weekly_trend.dart';

class WeeklyStatisticsCalculator
    implements Calculator<StatisticsContext, WeeklyStatistics> {
  const WeeklyStatisticsCalculator();

  @override
  WeeklyStatistics calculate(
    StatisticsContext context,
  ) {
    final weekStart = AppDateUtils.startOfWeek();

    final days = _buildWeek(
      context,
      weekStart,
    );

    final previousWeek = _buildWeek(
      context,
      weekStart.subtract(const Duration(days: 7)),
    );

    final totalCompleted =
        days.fold<int>(0, (sum, day) => sum + day.completedHabits);

    final totalTarget = days.fold<int>(0, (sum, day) => sum + day.targetHabits);

    final totalXP = days.fold<int>(0, (sum, day) => sum + day.totalXP);

    final totalDuration =
        days.fold<int>(0, (sum, day) => sum + day.totalDurationMinutes);

    final activeDays = days.where((day) => day.hasActivity).length;

    final completionRate = _round4(
      totalTarget == 0 ? 0.0 : totalCompleted / totalTarget,
    );

    final previousCompleted = previousWeek.fold<int>(
      0,
      (sum, day) => sum + day.completedHabits,
    );

    final previousTarget = previousWeek.fold<int>(
      0,
      (sum, day) => sum + day.targetHabits,
    );

    final previousCompletionRate = _round4(
      previousTarget == 0 ? 0.0 : previousCompleted / previousTarget,
    );

    final change = (completionRate - previousCompletionRate) * 100;

    return WeeklyStatistics(
      days: days,
      completionRate: completionRate,
      previousWeekCompletionRate: previousCompletionRate,
      weeklyChangePercentage: change,
      trend: _trend(change),
      totalCompleted: totalCompleted,
      totalTarget: totalTarget,
      totalXP: totalXP,
      totalDurationMinutes: totalDuration,
      activeDays: activeDays,
      bestDay: _bestDay(days),
      worstDay: _worstDay(days),
    );
  }

  List<WeekdayStatistics> _buildWeek(
    StatisticsContext context,
    DateTime weekStart,
  ) {
    return List.generate(
      7,
      (index) => _buildDay(
        context,
        weekStart.add(
          Duration(days: index),
        ),
      ),
      growable: false,
    );
  }

  WeekdayStatistics _buildDay(
    StatisticsContext context,
    DateTime day,
  ) {
    final normalizedDay = AppDateUtils.dateOnly(day);

    final logs =
        context.completedLogsByDate[normalizedDay] ?? const <HabitLog>[];

    final completedHabitIds = <String>{};

    var xp = 0;
    var duration = 0;

    for (final log in logs) {
      completedHabitIds.add(log.habitId);
      xp += log.xpEarned;
      duration += log.durationMinutes;
    }

    final completed = completedHabitIds.length;

    final target = context.expectedHabitsForDate(day);

    final completionRate = target == 0 ? 0.0 : completed / target;

    return WeekdayStatistics(
      date: day,
      completedHabits: completed,
      targetHabits: target,
      completionRate: completionRate,
      totalXP: xp,
      totalDurationMinutes: duration,
      isPerfectDay: target > 0 && completed >= target,
    );
  }

  WeekdayStatistics _bestDay(
    List<WeekdayStatistics> days,
  ) {
    return days.reduce(
      (a, b) {
        if (b.completionRate > a.completionRate) {
          return b;
        }

        if (b.completionRate == a.completionRate && b.totalXP > a.totalXP) {
          return b;
        }

        return a;
      },
    );
  }

  WeekdayStatistics _worstDay(
    List<WeekdayStatistics> days,
  ) {
    return days.reduce(
      (a, b) {
        if (b.completionRate < a.completionRate) {
          return b;
        }

        if (b.completionRate == a.completionRate && b.totalXP < a.totalXP) {
          return b;
        }

        return a;
      },
    );
  }

  static const _trendThreshold = 2.0;
  WeeklyTrend _trend(
    double change,
  ) {
    if (change > _trendThreshold) {
      return WeeklyTrend.improving;
    }

    if (change < -_trendThreshold) {
      return WeeklyTrend.declining;
    }

    return WeeklyTrend.stable;
  }

  double _round4(double value) {
    return double.parse(value.toStringAsFixed(4));
  }
}
