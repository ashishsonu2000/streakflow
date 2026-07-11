import '../../../habits/data/entities/habit_log_entity.dart';
import '../models/calendar_day_state.dart';

class CalendarBuilder {
  const CalendarBuilder();

  List<CalendarDayState> build({
    required List<DateTime> dates,
    required List<HabitLogEntity> logs,
    required int totalHabits,
    required DateTime selectedDate,
  }) {
    final today = DateTime.now();

    return dates.map((date) {
      final completed = logs
          .where(
            (log) =>
                log.date.year == date.year &&
                log.date.month == date.month &&
                log.date.day == date.day,
          )
          .length;

      return CalendarDayState(
        date: date,
        completedHabits: completed,
        totalHabits: totalHabits,
        intensity: _intensity(
          completed,
          totalHabits,
        ),
        isToday: _sameDay(
          date,
          today,
        ),
        isSelected: _sameDay(
          date,
          selectedDate,
        ),
        isCurrentMonth: date.month == selectedDate.month,
      );
    }).toList();
  }

  bool _sameDay(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int _intensity(
    int completed,
    int total,
  ) {
    if (total == 0) {
      return 0;
    }

    final ratio = completed / total;

    if (ratio >= .9) return 4;
    if (ratio >= .7) return 3;
    if (ratio >= .4) return 2;
    if (ratio > 0) return 1;

    return 0;
  }
}
