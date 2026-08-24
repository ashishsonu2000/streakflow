import '../models/habit.dart';

class HabitScheduleService {
  const HabitScheduleService();

  bool isScheduledForDate(
      Habit habit,
      DateTime date,
      ) {
    final day = _dateOnly(date);
    final start = _dateOnly(habit.startDate);

    if (day.isBefore(start)) {
      return false;
    }

    if (habit.endDate != null &&
        day.isAfter(
          _dateOnly(habit.endDate!),
        )) {
      return false;
    }

    // Phase 1:
    // Every day between start and end.
    return true;
  }

  bool isActive(
      Habit habit,
      DateTime date,
      ) {
    return isScheduledForDate(
      habit,
      date,
    );
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }
}