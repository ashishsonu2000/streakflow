import '../../../dashboard/domain/models/dashboard_analytics.dart';
import '../../../habits/domain/models/habit.dart';

import '../calculators/statistics_calculator.dart';
import '../models/statistics_summary.dart';

class StatisticsService {
  const StatisticsService();

  StatisticsSummary calculate(
    DashboardAnalytics analytics,
    List<Habit> habits,
  ) {
    return StatisticsCalculator.calculate(
      analytics,
      habits,
    );
  }
}
