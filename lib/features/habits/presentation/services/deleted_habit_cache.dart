import '../../domain/models/habit.dart';
import '../../domain/models/habit_log.dart';

/// The habit deleted last, with its completion history, kept while the
/// "deleted" snackbar offers UNDO. Deleting removes the logs too, so
/// undo must put them back.
class DeletedHabitCache {
  DeletedHabitCache._();

  static Habit? _deletedHabit;
  static List<HabitLog> _deletedLogs = const [];

  static Habit? get habit => _deletedHabit;

  static bool get hasHabit => _deletedHabit != null;

  static void save(
    Habit habit, {
    List<HabitLog> logs = const [],
  }) {
    _deletedHabit = habit;
    _deletedLogs = List.unmodifiable(logs);
  }

  /// The cached habit and its logs, emptying the cache.
  static ({Habit habit, List<HabitLog> logs})? take() {
    final habit = _deletedHabit;
    final logs = _deletedLogs;
    clear();

    return habit == null ? null : (habit: habit, logs: logs);
  }

  static void clear() {
    _deletedHabit = null;
    _deletedLogs = const [];
  }
}
