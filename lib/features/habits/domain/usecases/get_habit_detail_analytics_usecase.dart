import '../builders/habit_detail_analytics_builder.dart';
import '../models/analytics/habit_details_analytics.dart';
import '../models/habit.dart';
import '../repositories/habit_repository.dart';

class GetHabitDetailAnalyticsUseCase {
  const GetHabitDetailAnalyticsUseCase(
      this._repository,
      );

  final HabitRepository _repository;

  Future<HabitDetailAnalytics> call(
      Habit habit,
      ) async {
    final logs =
    await _repository.getLogsForHabit(
      habit.id,
    );

    return HabitDetailAnalyticsBuilder.build(
      habit,
      logs,
    );
  }
}