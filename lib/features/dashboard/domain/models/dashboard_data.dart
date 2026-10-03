import '../../../calendar/domain/models/calendar_view_model.dart';
import '../../../habits/domain/models/habit.dart';
import '../../../statistics/domain/models/statistics_summary.dart';

class DashboardData {
  const DashboardData({
    required this.statistics,
    required this.calendar,
    required this.habits,
  });

  final StatisticsSummary statistics;

  final CalendarViewModel calendar;

  final List<Habit> habits;
}
