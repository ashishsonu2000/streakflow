import '../../../habits/data/entities/habit_log_entity.dart';

class CalendarDayViewModel {
  const CalendarDayViewModel({
    required this.date,
    required this.isCurrentMonth,
    required this.isSelected,
    required this.isToday,
    required this.completedHabits,
    required this.totalHabits,
    required this.intensity,
    required this.logs,
  });

  final DateTime date;

  final bool isCurrentMonth;

  final bool isSelected;

  final bool isToday;

  final int completedHabits;

  final int totalHabits;

  /// 0..4
  final int intensity;

  final List<HabitLogEntity> logs;

  double get completionRate {
    if (totalHabits == 0) {
      return 0;
    }

    return completedHabits / totalHabits;
  }

  bool get hasActivity => completedHabits > 0;
}
