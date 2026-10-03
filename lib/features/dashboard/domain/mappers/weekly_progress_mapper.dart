import '../../../statistics/domain/models/weekly_statistics.dart';

import '../models/weekly_progress_view_model.dart';

class WeeklyProgressMapper {
  const WeeklyProgressMapper();

  WeeklyProgressViewModel map(
    WeeklyStatistics weekly,
  ) {
    return WeeklyProgressViewModel(
      completionRate: weekly.completionRate,
      completed: weekly.totalCompleted,
      target: weekly.totalTarget,
      totalXP: weekly.totalXP,
      activeDays: weekly.activeDays,
      changePercentage: weekly.weeklyChangePercentage,
      trend: weekly.trend,
    );
  }
}
