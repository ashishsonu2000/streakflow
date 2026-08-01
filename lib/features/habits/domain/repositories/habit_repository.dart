import '../../data/entities/habit_log_entity.dart';

import '../models/habit.dart';

abstract class HabitRepository {
  /// --------------------------------------------------------------------------
  /// Habit CRUD
  /// --------------------------------------------------------------------------

  Future<List<Habit>> getAll();

  Stream<List<Habit>> watchAll();

  Future<Habit?> getById(String id);

  Future<void> save(Habit habit);

  Future<void> update(Habit habit);

  Future<void> delete(String id);

  Future<void> archive(String id);

  Future<void> restore(String id);

  Stream<List<Habit>> watchArchived();

  //Future<AnalyticsSummary> getAnalytics(String habitId);

  /// --------------------------------------------------------------------------
  /// Habit Completion
  /// --------------------------------------------------------------------------

  Future<void> completeHabit(
    String habitId, {
    int durationMinutes = 0,
    String notes = "",
  });

  Future<void> uncompleteHabit(String habitId);

  Future<bool> isCompletedToday(String habitId);

  /// --------------------------------------------------------------------------
  /// Analytics APIs
  /// --------------------------------------------------------------------------

  /// Returns every completion log.
  Future<List<HabitLogEntity>> getHabitLogs();

  /// Returns all logs for a single habit.
  Future<List<HabitLogEntity>> getHabitLogsForHabit(
    String habitId,
  );

  /// Returns logs between two dates.
  Future<List<HabitLogEntity>> getHabitLogsBetween(
    DateTime start,
    DateTime end,
  );

  /// Live stream of all logs.
  Stream<List<HabitLogEntity>> watchHabitLogs();

  Future<void> rebuildHabitStatistics();
}
