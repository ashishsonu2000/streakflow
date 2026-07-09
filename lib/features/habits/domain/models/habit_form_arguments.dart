import '../../domain/models/habit.dart';

class HabitFormArguments {
  const HabitFormArguments({
    this.habit,
    this.duplicate = false,
  });

  final Habit? habit;

  final bool duplicate;
}
