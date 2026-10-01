import '../../data/entities/habit_log_entity.dart';

import '../models/habit.dart';
import '../models/habit_log.dart';

abstract class HabitRepository {
  /// --------------------------------------------------------------------------
  /// Habit CRUD
  /// --------------------------------------------------------------------------

  /// Active habits scheduled for today.
  Future<List<Habit>> getAll();

  /// Every active (non-archived) habit.
  Future<List<Habit>> getAllForCalendar();

  /// Every habit, active and archived (backups).
  Future<List<Habit>> getAllIncludingArchived();

  /// Active habits scheduled for today, with completedToday.
  Stream<List<Habit>> watchAll();

  /// Every active habit, with completedToday (Habits page).
  Stream<List<Habit>> watchAllActive();

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
        DateTime? date,
        int durationMinutes = 0,
        String notes = '',
      });

  Future<void> uncompleteHabit(
      String habitId, {
        DateTime? date,
      });

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

  Future<List<HabitLog>> getLogs();

  Future<List<HabitLog>> getLogsForHabit(
    String habitId,
  );

  Future<List<HabitLog>> getLogsBetween(
    DateTime start,
    DateTime end,
  );

  Stream<List<HabitLog>> watchLogs();

  Future<List<HabitLogEntity>> getHabitLogsForDate(
    DateTime date,
  );

  Stream<List<HabitLog>> watchLogsForHabit(
      String habitId,
      );

  Stream<Habit?> watchById(
      String id,
      );

  Future<void> clearDatabase();

  /// Replaces every habit and log with [habits] and [logs] in one
  /// transaction (backup restore): if anything fails, nothing changes.
  Future<void> replaceAllData({
    required List<Habit> habits,
    required List<HabitLog> logs,
  });
}
