import '../../domain/models/habit.dart';
import '../../domain/models/habit_log.dart';
import '../entities/habit_log_entity.dart';

abstract class HabitLocalDataSource {
  Future<List<Habit>> getAll();

  Future<List<Habit>> getAllForCalendar();

  Future<Habit?> getById(String id);

  /// Active habits scheduled for today (dashboard, today's summary).
  Stream<List<Habit>> watchAll();

  /// Every active habit, whether or not it is due today (Habits page).
  Stream<List<Habit>> watchAllActive();

  /// Every habit, active and archived (backups).
  Future<List<Habit>> getAllIncludingArchived();

  Future<void> save(Habit habit);

  Future<void> delete(String id);

  Future<void> archive(String id);

  Future<void> restore(String id);

  Future<List<HabitLogEntity>> getHabitLogs();

  /// Marks today's habit as completed.
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

  /// Returns true if today's habit has already been completed.
  Future<bool> isCompletedToday(String habitId);



  Future<List<HabitLogEntity>> getHabitLogsBetween(
    DateTime start,
    DateTime end,
  );

  Future<List<HabitLogEntity>> getHabitLogsForHabit(
    String habitId,
  );

  Stream<List<HabitLogEntity>> watchHabitLogs();

  /// Archived habits (archived == true)
  Stream<List<Habit>> watchArchived();

  Future<void> rebuildHabitStatistics();

  /// Brings stored streaks up to date with today (see
  /// HabitStatisticsRebuilder.refreshStreaks).
  Future<int> refreshStreaks();

  Stream<List<HabitLogEntity>> watchHabitLogsForHabit(
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

  /// Puts a just-deleted habit back with its completion history, in one
  /// transaction (undo after delete; deleting removes the logs too).
  Future<void> restoreDeleted({
    required Habit habit,
    required List<HabitLog> logs,
  });

}
