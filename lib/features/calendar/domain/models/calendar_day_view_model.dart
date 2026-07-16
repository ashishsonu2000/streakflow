import '../../../habits/data/entities/mood_type.dart';
import 'day_habit_view_model.dart';

class CalendarDayViewModel {
  const CalendarDayViewModel({
    required this.date,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isSelected,
    required this.completedHabits,
    required this.totalHabits,
    required this.intensity,
    required this.totalXP,
    required this.totalDuration,
    required this.firstCompletion,
    required this.lastCompletion,
    required this.dominantMood,
    required this.habits,
  });

  final DateTime date;

  final bool isCurrentMonth;

  final bool isToday;

  final bool isSelected;

  final int completedHabits;

  final int totalHabits;

  final int intensity;

  final int totalXP;

  final int totalDuration;

  final DateTime? firstCompletion;

  final DateTime? lastCompletion;

  final MoodType? dominantMood;

  final List<DayHabitViewModel> habits;

  bool get hasActivity => completedHabits > 0;

  double get completionRate {
    if (totalHabits == 0) {
      return 0;
    }

    return completedHabits / totalHabits;
  }

  CalendarDayViewModel copyWith({
    DateTime? date,
    bool? isCurrentMonth,
    bool? isToday,
    bool? isSelected,
    int? completedHabits,
    int? totalHabits,
    int? intensity,
    int? totalXP,
    int? totalDuration,
    DateTime? firstCompletion,
    DateTime? lastCompletion,
    MoodType? dominantMood,
    List<DayHabitViewModel>? habits,
  }) {
    return CalendarDayViewModel(
      date: date ?? this.date,
      isCurrentMonth: isCurrentMonth ?? this.isCurrentMonth,
      isToday: isToday ?? this.isToday,
      isSelected: isSelected ?? this.isSelected,
      completedHabits: completedHabits ?? this.completedHabits,
      totalHabits: totalHabits ?? this.totalHabits,
      intensity: intensity ?? this.intensity,
      totalXP: totalXP ?? this.totalXP,
      totalDuration: totalDuration ?? this.totalDuration,
      firstCompletion: firstCompletion ?? this.firstCompletion,
      lastCompletion: lastCompletion ?? this.lastCompletion,
      dominantMood: dominantMood ?? this.dominantMood,
      habits: habits ?? this.habits,
    );
  }
}
