import '../../../habits/domain/enums/habit_frequency.dart';

class SuggestedHabit {
  const SuggestedHabit({
    required this.title,
    required this.description,
    required this.category,
    this.frequency = HabitFrequency.daily,
  });

  final String title;

  final String description;

  final String category;

  final HabitFrequency frequency;
}