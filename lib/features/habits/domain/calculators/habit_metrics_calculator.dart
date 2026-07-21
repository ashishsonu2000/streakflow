import '../../../../core/utils/date_utils.dart';
import '../../data/entities/habit_log_entity.dart';
import '../enums/completion_status.dart';
import '../models/habit_metrics.dart';

class HabitMetricsCalculator {
  const HabitMetricsCalculator._();

  static HabitMetrics calculate(
    List<HabitLogEntity> logs,
  ) {
    final completedLogs = logs
        .where(
          (e) => e.status == CompletionStatus.completed,
        )
        .toList();

    final weekStart = AppDateUtils.startOfWeek();
    final weekEnd = AppDateUtils.endOfWeek();

    final monthStart = AppDateUtils.startOfMonth();
    final monthEnd = AppDateUtils.endOfMonth();

    final completedThisWeek = completedLogs.where((log) {
      return !log.date.isBefore(weekStart) && !log.date.isAfter(weekEnd);
    }).length;

    final completedThisMonth = completedLogs.where((log) {
      return !log.date.isBefore(monthStart) && !log.date.isAfter(monthEnd);
    }).length;

    final weeklyRate = (completedThisWeek / 7 * 100).clamp(0, 100).toDouble();

    final monthlyRate = (completedThisMonth / DateTime.now().day * 100)
        .clamp(0, 100)
        .toDouble();

    return HabitMetrics(
      completedThisWeek: completedThisWeek,
      completedThisMonth: completedThisMonth,
      weeklyCompletionRate: weeklyRate,
      monthlyCompletionRate: monthlyRate,
    );
  }
}
