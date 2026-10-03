import '../enums/habit_frequency.dart';
import '../models/habit_form_state.dart';

/// Validates a habit form before it is saved.
///
/// Returns the first problem as a user-facing message, or `null` when
/// the form can be saved.
class HabitFormValidator {
  const HabitFormValidator();

  String? validate(
      HabitFormState form,
      ) {
    final title =
    form.title.trim();

    final description =
    form.description.trim();

    // ---------------------------------------------------------
    // Description
    // ---------------------------------------------------------

    if (description.length > 500) {
      return 'Description cannot exceed 500 characters.';
    }

    // ---------------------------------------------------------
    // Title
    // ---------------------------------------------------------

    if (title.isEmpty) {
      return 'Habit title is required.';
    }

    if (title.length < 2) {
      return 'Title is too short.';
    }

    if (title.length > 60) {
      return 'Maximum 60 characters allowed.';
    }

    // ---------------------------------------------------------
    // Dates
    // ---------------------------------------------------------

    if (form.isEndDateBeforeStart) {
      return 'End date cannot be before start date.';
    }

    // ---------------------------------------------------------
    // Weekly
    // ---------------------------------------------------------

    if (form.frequency ==
        HabitFrequency.weekly &&
        form.weeklyDays.isEmpty) {
      return 'Please select at least one day for the weekly habit.';
    }

    if (form.frequency ==
        HabitFrequency.weekly) {
      final invalid =
      form.weeklyDays.any(
            (day) =>
        day < 1 ||
            day > 7,
      );

      if (invalid) {
        return 'Invalid weekly schedule.';
      }
    }

    // ---------------------------------------------------------
    // Monthly
    // ---------------------------------------------------------

    if (form.frequency ==
        HabitFrequency.monthly) {
      if (form.monthlyDay < 1 ||
          form.monthlyDay > 31) {
        return 'Please select a valid day of the month.';
      }
    }

    // ---------------------------------------------------------
    // Reminder
    // ---------------------------------------------------------

    if (form.reminderEnabled) {
      if (form.reminderHour == null ||
          form.reminderMinute == null) {
        return 'Please select a reminder time.';
      }

      if (form.reminderHour! < 0 ||
          form.reminderHour! > 23) {
        return 'Invalid reminder hour.';
      }

      if (form.reminderMinute! < 0 ||
          form.reminderMinute! > 59) {
        return 'Invalid reminder minute.';
      }
    }

    return null;
  }
}
