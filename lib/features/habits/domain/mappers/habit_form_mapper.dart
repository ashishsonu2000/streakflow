import '../../../../core/utils/date_utils.dart';
import '../enums/habit_frequency.dart';
import '../models/create_habit_request.dart';
import '../models/habit.dart';
import '../models/habit_form_state.dart';
import '../models/update_habit_request.dart';

/// Converts between a [Habit] and the habit form, and from the form to
/// the create / update requests.
class HabitFormMapper {
  const HabitFormMapper();

  // =========================================================
  // EDIT
  // =========================================================

  /// Fills [form] with [habit] for editing.
  HabitFormState forEdit(
      HabitFormState form,
      Habit habit,
      ) {
    var weeklyDays =
    List<int>.from(
      habit.weeklyDays,
    );

    // ---------------------------------------------------------
    // Legacy weekly habit
    // ---------------------------------------------------------

    if (habit.frequency ==
        HabitFrequency.weekly &&
        weeklyDays.isEmpty) {
      weeklyDays = [
        habit.startDate.weekday,
      ];
    }

    // ---------------------------------------------------------
    // Monthly
    // ---------------------------------------------------------

    var monthlyDay =
        habit.monthlyDay;

    // Backward compatibility:
    // old monthly habits may have monthlyDay = 1.
    if (habit.frequency ==
        HabitFrequency.monthly &&
        monthlyDay == 1 &&
        habit.startDate.day != 1) {
      monthlyDay =
          habit.startDate.day;
    }

    return form.copyWith(
      originalHabit: habit,

      title:
      habit.title,

      description:
      habit.description,

      category:
      habit.category,

      frequency:
      habit.frequency,

      weeklyDays:
      weeklyDays,

      monthlyDay:
      monthlyDay,

      iconCodePoint:
      habit.iconCodePoint,

      colorValue:
      habit.colorValue,

      targetPerDay:
      habit.targetPerDay,

      reminderEnabled:
      habit.reminderEnabled,

      reminderHour:
      habit.reminderHour,

      reminderMinute:
      habit.reminderMinute,

      additionalReminderMinutes:
      List<int>.from(habit.additionalReminderMinutes),

      startDate:
      AppDateUtils.dateOnly(
        habit.startDate,
      ),

      endDate:
      habit.endDate == null
          ? null
          : AppDateUtils.dateOnly(
        habit.endDate!,
      ),

      isEditing: true,

      isSaving: false,

      clearError: true,
    );
  }

  // =========================================================
  // DUPLICATE
  // =========================================================

  /// A new-habit form copied from [habit], starting [today].
  HabitFormState forDuplicate(
      Habit habit, {
        required DateTime today,
      }) {
    var weeklyDays =
    List<int>.from(
      habit.weeklyDays,
    );

    var monthlyDay =
        habit.monthlyDay;

    if (habit.frequency ==
        HabitFrequency.weekly &&
        weeklyDays.isEmpty) {
      weeklyDays = [
        today.weekday,
      ];
    }

    if (habit.frequency ==
        HabitFrequency.monthly &&
        (monthlyDay < 1 ||
            monthlyDay > 31)) {
      monthlyDay =
          today.day;
    }

    return HabitFormState(
      title:
      habit.title,

      description:
      habit.description,

      category:
      habit.category,

      frequency:
      habit.frequency,

      iconCodePoint:
      habit.iconCodePoint,

      colorValue:
      habit.colorValue,

      targetPerDay:
      habit.targetPerDay,

      reminderEnabled:
      habit.reminderEnabled,

      reminderHour:
      habit.reminderHour,

      reminderMinute:
      habit.reminderMinute,

      additionalReminderMinutes:
      List<int>.from(habit.additionalReminderMinutes),

      startDate:
      today,

      endDate:
      null,

      weeklyDays:
      weeklyDays,

      monthlyDay:
      monthlyDay,

      isEditing: false,

      isSaving: false,
    );
  }

  // =========================================================
  // CREATE REQUEST
  // =========================================================

  CreateHabitRequest toCreateRequest(
      HabitFormState form,
      ) {
    return CreateHabitRequest(
      title:
      form.title.trim(),

      description:
      form.description.trim(),

      category:
      form.category,

      frequency:
      form.frequency,

      iconCodePoint:
      form.iconCodePoint,

      colorValue:
      form.colorValue,

      targetPerDay:
      form.targetPerDay,

      reminderEnabled:
      form.reminderEnabled,

      reminderHour:
      form.reminderHour,

      reminderMinute:
      form.reminderMinute,

      additionalReminderMinutes:
      List<int>.from(form.additionalReminderMinutes),

      // Schedule
      startDate:
      form.startDate,

      endDate:
      form.endDate,

      // Recurrence
      weeklyDays:
      List<int>.from(
        form.weeklyDays,
      ),

      monthlyDay:
      form.monthlyDay,
    );
  }

  // =========================================================
  // UPDATE REQUEST
  // =========================================================

  /// Requires [HabitFormState.originalHabit] (edit mode).
  UpdateHabitRequest toUpdateRequest(
      HabitFormState form,
      ) {
    final habit =
    form.originalHabit!;

    return UpdateHabitRequest(
      id:
      habit.id,

      title:
      form.title.trim(),

      description:
      form.description.trim(),

      category:
      form.category,

      frequency:
      form.frequency,

      iconCodePoint:
      form.iconCodePoint,

      colorValue:
      form.colorValue,

      targetPerDay:
      form.targetPerDay,

      reminderEnabled:
      form.reminderEnabled,

      reminderHour:
      form.reminderHour,

      reminderMinute:
      form.reminderMinute,

      additionalReminderMinutes:
      List<int>.from(form.additionalReminderMinutes),

      // Schedule
      startDate:
      form.startDate,

      endDate:
      form.endDate,

      // Recurrence
      weeklyDays:
      List<int>.from(
        form.weeklyDays,
      ),

      monthlyDay:
      form.monthlyDay,

      // Existing values
      currentStreak:
      habit.currentStreak,

      bestStreak:
      habit.bestStreak,

      totalCompleted:
      habit.totalCompleted,

      xp:
      habit.xp,

      archived:
      habit.archived,

      createdAt:
      habit.createdAt,

      lastCompletedDate:
      habit.lastCompletedDate,

      completedToday:
      habit.completedToday,
    );
  }
}
