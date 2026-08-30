import '../../domain/models/habit.dart';
import '../entities/habit_log_entity.dart';

abstract class HabitLocalDataSource {
  Future<List<Habit>> getAll();

  Future<List<Habit>> getAllForCalendar();

  Future<Habit?> getById(String id);

  Stream<List<Habit>> watchAll();

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

  Stream<List<HabitLogEntity>> watchHabitLogsForHabit(
    String habitId,
  );

  Stream<Habit?> watchById(
      String id,
      );
  Future<void> clearDatabase();

}
