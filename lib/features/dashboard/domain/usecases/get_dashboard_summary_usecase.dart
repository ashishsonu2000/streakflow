import '../../../habits/domain/repositories/habit_repository.dart';

import '../models/dashboard_summary.dart';

class GetDashboardSummaryUseCase {
  const GetDashboardSummaryUseCase(this._repository);

  final HabitRepository _repository;

  Future<DashboardSummary> call() async {
    final habits = await _repository.getAll();

    final analytics = HabitAnalyticsBuilder.build(habits);

    return DashboardSummary(
      totalHabits: analytics.totalHabits,
      activeHabits: analytics.activeHabits,
      archivedHabits: analytics.archivedHabits,
      completedToday: analytics.completedToday,
      pendingToday: analytics.pendingToday,
      currentStreak: analytics.currentStreak,
      bestStreak: analytics.bestStreak,
      totalCompletions: analytics.totalCompleted,
      totalXp: analytics.totalXp,
      level: analytics.level.level,
      previousLevelXp: analytics.level.previousLevelXp,
      nextLevelXp: analytics.level.nextLevelXp,
      xpProgress: analytics.level.progress,
      weeklyCompletion: 0,
      monthlyCompletion: 0,
      successRate: 0,
    );
  }
}
