import '../enums/habit_frequency.dart';
import '../models/habit.dart';

class HabitScheduleService {
  const HabitScheduleService();

  // =========================================================
  // Is Scheduled For Date
  // =========================================================

  bool isScheduledForDate(
      Habit habit,
      DateTime date,
      ) {
    final day = _dateOnly(date);

    // =======================================================
    // Archived habits are not scheduled
    // =======================================================

    if (habit.archived) {
      return false;
    }

    // =======================================================
    // Start Date
    // =======================================================

    final startDate =
    _dateOnly(habit.startDate);

    if (day.isBefore(startDate)) {
      return false;
    }

    // =======================================================
    // End Date
    // =======================================================

    final endDate =
    habit.endDate == null
        ? null
        : _dateOnly(habit.endDate!);

    if (endDate != null &&
        day.isAfter(endDate)) {
      return false;
    }

    // =======================================================
    // Frequency
    // =======================================================

    switch (habit.frequency) {
    // -----------------------------------------------------
    // Daily
    // -----------------------------------------------------

      case HabitFrequency.daily:
        return true;

    // -----------------------------------------------------
    // Weekly
    // -----------------------------------------------------
    //
    // Example:
    // weeklyDays = [1, 3, 5]
    //
    // Monday    = 1
    // Wednesday = 3
    // Friday    = 5
    //
    // The habit is scheduled ONLY on those weekdays.
    // -----------------------------------------------------

      case HabitFrequency.weekly:
        if (habit.weeklyDays.isEmpty) {
          // Backward compatibility:
          //
          // Old weekly habits did not have weeklyDays.
          // Their start-date weekday is therefore used.
          return day.weekday ==
              startDate.weekday;
        }

        return habit.weeklyDays.contains(
          day.weekday,
        );

    // -----------------------------------------------------
    // Monthly
    // -----------------------------------------------------
    //
    // Example:
    // monthlyDay = 15
    //
    // The habit occurs on the 15th of each month.
    // -----------------------------------------------------

      case HabitFrequency.monthly:
        final monthlyDay =
            habit.monthlyDay;

        if (monthlyDay < 1 ||
            monthlyDay > 31) {
          return false;
        }

        // ---------------------------------------------------
        // Months without this day
        //
        // Example:
        // monthlyDay = 31
        //
        // February has no 31st, so there is no occurrence
        // in February.
        // ---------------------------------------------------

        final daysInMonth =
            DateTime(
              day.year,
              day.month + 1,
              0,
            ).day;

        if (monthlyDay >
            daysInMonth) {
          return false;
        }

        return day.day ==
            monthlyDay;

    // -----------------------------------------------------
    // Custom
    // -----------------------------------------------------
    //
    // Currently no custom recurrence rule exists.
    // Keep existing behavior.
    // -----------------------------------------------------

      case HabitFrequency.custom:
        return true;
    }
  }

  // =========================================================
  // Is Active
  // =========================================================

  bool isActive(
      Habit habit,
      DateTime date,
      ) {
    return isScheduledForDate(
      habit,
      date,
    );
  }

  // =========================================================
  // Date Only
  // =========================================================

  DateTime _dateOnly(
      DateTime date,
      ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }
}