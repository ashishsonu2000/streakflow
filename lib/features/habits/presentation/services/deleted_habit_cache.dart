import '../../domain/models/habit.dart';

class DeletedHabitCache {
  DeletedHabitCache._();

  static Habit? _deletedHabit;

  static Habit? get habit => _deletedHabit;

  static bool get hasHabit => _deletedHabit != null;

  static void save(Habit habit) {
    _deletedHabit = habit;
  }

  static Habit? take() {
    final habit = _deletedHabit;
    _deletedHabit = null;
    return habit;
  }

  static void clear() {
    _deletedHabit = null;
  }
}
