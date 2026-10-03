import '../../../habits/domain/models/habit.dart';

import 'habit_summary.dart';

class HabitCardModel {
  const HabitCardModel({
    required this.habit,
    required this.summary,
  });

  final Habit habit;

  final HabitSummary summary;
}
