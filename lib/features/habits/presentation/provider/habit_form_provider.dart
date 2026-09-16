import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/enums/habit_frequency.dart';
import '../../domain/models/create_habit_request.dart';
import '../../domain/models/habit.dart';
import '../../domain/models/habit_category.dart';
import '../../domain/models/habit_form_state.dart';
import '../../domain/models/update_habit_request.dart';

import '../../domain/usecases/create_habit_usecase.dart';
import '../../domain/usecases/update_habit_usecase.dart';

import '../providers/habit_usecase_provider.dart';

final habitFormProvider =
AsyncNotifierProvider<HabitFormNotifier, HabitFormState>(
  HabitFormNotifier.new,
);

class HabitFormNotifier
    extends AsyncNotifier<HabitFormState> {
  late final CreateHabitUseCase _createHabit;
  late final UpdateHabitUseCase _updateHabit;

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Future<HabitFormState> build() async {
    _createHabit =
        ref.read(createHabitUseCaseProvider);

    _updateHabit =
        ref.read(updateHabitUseCaseProvider);

    AppLogger.log(
      'HABIT FORM CREATE USE CASE: '
          '${_createHabit.runtimeType}',
    );

    AppLogger.log(
      'HABIT FORM UPDATE USE CASE: '
          '${_updateHabit.runtimeType}',
    );

    return HabitFormState();
  }

  // =========================================================
  // STATE
  // =========================================================

  HabitFormState get form =>
      state.requireValue;

  HabitFormState? get current =>
      state.valueOrNull;

  void _update(
      HabitFormState value,
      ) {
    state = AsyncData(value);
  }

  // =========================================================
  // BASIC
  // =========================================================

  void setTitle(
      String value,
      ) {
    _update(
      form.copyWith(
        title: value,
        clearError: true,
      ),
    );
  }

  void setDescription(
      String value,
      ) {
    _update(
      form.copyWith(
        description: value,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // CATEGORY
  // =========================================================

  void setCategory(
      HabitCategory category,
      ) {
    _update(
      form.copyWith(
        category: category,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // FREQUENCY
  // =========================================================

  void setFrequency(
      HabitFrequency frequency,
      ) {
    var weeklyDays =
    List<int>.from(
      form.weeklyDays,
    );

    var monthlyDay =
        form.monthlyDay;

    // ---------------------------------------------------------
    // WEEKLY
    // ---------------------------------------------------------

    if (frequency ==
        HabitFrequency.weekly &&
        weeklyDays.isEmpty) {
      weeklyDays = [
        form.startDate.weekday,
      ];
    }

    // ---------------------------------------------------------
    // MONTHLY
    // ---------------------------------------------------------

    if (frequency ==
        HabitFrequency.monthly) {
      // Preserve a previously selected monthly day.
      //
      // For a brand-new form, monthlyDay is initialized from
      // the start date when appropriate.
      if (monthlyDay < 1 ||
          monthlyDay > 31) {
        monthlyDay =
            form.startDate.day;
      }
    }

    _update(
      form.copyWith(
        frequency: frequency,
        weeklyDays: weeklyDays,
        monthlyDay: monthlyDay,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // WEEKLY DAYS
  // =========================================================

  void toggleWeeklyDay(
      int weekday,
      ) {
    if (weekday < 1 ||
        weekday > 7) {
      return;
    }

    final days =
    List<int>.from(
      form.weeklyDays,
    );

    if (days.contains(weekday)) {
      // Never allow zero selected days.
      if (days.length == 1) {
        _update(
          form.copyWith(
            error:
            'Select at least one day.',
          ),
        );

        return;
      }

      days.remove(weekday);
    } else {
      days.add(weekday);
    }

    days.sort();

    _update(
      form.copyWith(
        weeklyDays: days,
        clearError: true,
      ),
    );
  }

  void setWeeklyDays(
      List<int> days,
      ) {
    final normalized = days
        .where(
          (day) =>
      day >= 1 &&
          day <= 7,
    )
        .toSet()
        .toList()
      ..sort();

    if (normalized.isEmpty) {
      _update(
        form.copyWith(
          error:
          'Select at least one day.',
        ),
      );

      return;
    }

    _update(
      form.copyWith(
        weeklyDays: normalized,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // MONTHLY DAY
  // =========================================================

  void setMonthlyDay(
      int day,
      ) {
    if (day < 1 ||
        day > 31) {
      return;
    }

    _update(
      form.copyWith(
        monthlyDay: day,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // ICON
  // =========================================================

  void setIcon(
      int iconCodePoint,
      ) {
    _update(
      form.copyWith(
        iconCodePoint:
        iconCodePoint,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // COLOR
  // =========================================================

  void setColor(
      int colorValue,
      ) {
    _update(
      form.copyWith(
        colorValue: colorValue,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // TARGET
  // =========================================================

  void setTarget(
      int target,
      ) {
    _update(
      form.copyWith(
        targetPerDay:
        target.clamp(
          1,
          100,
        ),
        clearError: true,
      ),
    );
  }

  void incrementTarget() {
    setTarget(
      form.targetPerDay + 1,
    );
  }

  void decrementTarget() {
    if (form.targetPerDay <= 1) {
      return;
    }

    setTarget(
      form.targetPerDay - 1,
    );
  }

  // =========================================================
  // REMINDER
  // =========================================================

  void setReminderEnabled(
      bool enabled,
      ) {
    _update(
      form.copyWith(
        reminderEnabled:
        enabled,
        clearError: true,
      ),
    );
  }

  void setReminderTime({
    required int hour,
    required int minute,
  }) {
    _update(
      form.copyWith(
        reminderHour: hour,
        reminderMinute: minute,
        clearError: true,
      ),
    );
  }

  void clearReminderTime() {
    _update(
      form.copyWith(
        clearReminderHour: true,
        clearReminderMinute: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // START DATE
  // =========================================================

  void setStartDate(
      DateTime date,
      ) {
    final normalized =
    _dateOnly(date);

    final currentEndDate =
        form.endDate;

    DateTime? newEndDate =
        currentEndDate;

    if (currentEndDate != null &&
        normalized.isAfter(
          _dateOnly(
            currentEndDate,
          ),
        )) {
      newEndDate = null;
    }

    // ---------------------------------------------------------
    // Weekly
    // ---------------------------------------------------------

    var weeklyDays =
    List<int>.from(
      form.weeklyDays,
    );

    if (form.frequency ==
        HabitFrequency.weekly &&
        weeklyDays.isEmpty) {
      weeklyDays = [
        normalized.weekday,
      ];
    }

    // ---------------------------------------------------------
    // Monthly
    // ---------------------------------------------------------

    var monthlyDay =
        form.monthlyDay;

    if (form.frequency ==
        HabitFrequency.monthly) {
      // If the user has not explicitly selected another day,
      // keep the monthly schedule aligned with the start date.
      if (monthlyDay < 1 ||
          monthlyDay > 31) {
        monthlyDay =
            normalized.day;
      }
    }

    _update(
      form.copyWith(
        startDate: normalized,
        endDate: newEndDate,
        weeklyDays: weeklyDays,
        monthlyDay: monthlyDay,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // END DATE
  // =========================================================

  void setEndDate(
      DateTime? date,
      ) {
    if (date == null) {
      clearEndDate();
      return;
    }

    final normalized =
    _dateOnly(date);

    final start =
    _dateOnly(
      form.startDate,
    );

    if (normalized.isBefore(start)) {
      _update(
        form.copyWith(
          error:
          'End date cannot be before start date.',
        ),
      );

      return;
    }

    _update(
      form.copyWith(
        endDate: normalized,
        clearError: true,
      ),
    );
  }

  void clearEndDate() {
    _update(
      form.copyWith(
        clearEndDate: true,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // LOAD EXISTING HABIT
  // =========================================================

  Future<void> loadFromHabit(
      Habit habit,
      ) async {
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

    _update(
      form.copyWith(
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

        startDate:
        _dateOnly(
          habit.startDate,
        ),

        endDate:
        habit.endDate == null
            ? null
            : _dateOnly(
          habit.endDate!,
        ),

        isEditing: true,

        isSaving: false,

        clearError: true,
      ),
    );
  }

  // =========================================================
  // DUPLICATE HABIT
  // =========================================================
  void duplicateFrom(Habit habit) {
    duplicateHabit(habit);
  }
  void duplicateHabit(
      Habit habit,
      ) {
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
        _today().weekday,
      ];
    }

    if (habit.frequency ==
        HabitFrequency.monthly &&
        (monthlyDay < 1 ||
            monthlyDay > 31)) {
      monthlyDay =
          _today().day;
    }

    _update(
      HabitFormState(
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

        startDate:
        _today(),

        endDate:
        null,

        weeklyDays:
        weeklyDays,

        monthlyDay:
        monthlyDay,

        isEditing: false,

        isSaving: false,
      ),
    );
  }

  // =========================================================
  // VALIDATION
  // =========================================================

  bool validate() {
    final title =
    form.title.trim();

    final description =
    form.description.trim();

    // ---------------------------------------------------------
    // Description
    // ---------------------------------------------------------

    if (description.length > 500) {
      _update(
        form.copyWith(
          error:
          'Description cannot exceed 500 characters.',
        ),
      );

      return false;
    }

    // ---------------------------------------------------------
    // Title
    // ---------------------------------------------------------

    if (title.isEmpty) {
      _update(
        form.copyWith(
          error:
          'Habit title is required.',
        ),
      );

      return false;
    }

    if (title.length < 2) {
      _update(
        form.copyWith(
          error:
          'Title is too short.',
        ),
      );

      return false;
    }

    if (title.length > 60) {
      _update(
        form.copyWith(
          error:
          'Maximum 60 characters allowed.',
        ),
      );

      return false;
    }

    // ---------------------------------------------------------
    // Dates
    // ---------------------------------------------------------

    if (form.isEndDateBeforeStart) {
      _update(
        form.copyWith(
          error:
          'End date cannot be before start date.',
        ),
      );

      return false;
    }

    // ---------------------------------------------------------
    // Weekly
    // ---------------------------------------------------------

    if (form.frequency ==
        HabitFrequency.weekly &&
        form.weeklyDays.isEmpty) {
      _update(
        form.copyWith(
          error:
          'Please select at least one day for the weekly habit.',
        ),
      );

      return false;
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
        _update(
          form.copyWith(
            error:
            'Invalid weekly schedule.',
          ),
        );

        return false;
      }
    }

    // ---------------------------------------------------------
    // Monthly
    // ---------------------------------------------------------

    if (form.frequency ==
        HabitFrequency.monthly) {
      if (form.monthlyDay < 1 ||
          form.monthlyDay > 31) {
        _update(
          form.copyWith(
            error:
            'Please select a valid day of the month.',
          ),
        );

        return false;
      }
    }

    // ---------------------------------------------------------
    // Reminder
    // ---------------------------------------------------------

    if (form.reminderEnabled) {
      if (form.reminderHour == null ||
          form.reminderMinute == null) {
        _update(
          form.copyWith(
            error:
            'Please select a reminder time.',
          ),
        );

        return false;
      }

      if (form.reminderHour! < 0 ||
          form.reminderHour! > 23) {
        _update(
          form.copyWith(
            error:
            'Invalid reminder hour.',
          ),
        );

        return false;
      }

      if (form.reminderMinute! < 0 ||
          form.reminderMinute! > 59) {
        _update(
          form.copyWith(
            error:
            'Invalid reminder minute.',
          ),
        );

        return false;
      }
    }

    _update(
      form.copyWith(
        clearError: true,
      ),
    );

    return true;
  }

  // =========================================================
  // SAVE
  // =========================================================

  Future<bool> save() async {
    AppLogger.log(
      '========== HabitFormNotifier.save ==========',
    );

    if (form.isSaving) {
      return false;
    }

    if (!validate()) {
      return false;
    }

    _update(
      form.copyWith(
        isSaving: true,
      ),
    );

    try {
      AppLogger.log(
        'mode = '
            '${form.isCreateMode ? 'CREATE' : 'UPDATE'}',
      );

      AppLogger.log(
        'title = ${form.title}',
      );

      AppLogger.log(
        'frequency = ${form.frequency}',
      );

      AppLogger.log(
        'weeklyDays = ${form.weeklyDays}',
      );

      AppLogger.log(
        'monthlyDay = ${form.monthlyDay}',
      );

      AppLogger.log(
        'targetPerDay = ${form.targetPerDay}',
      );

      AppLogger.log(
        'startDate = ${form.startDate}',
      );

      AppLogger.log(
        'endDate = ${form.endDate}',
      );

      // =======================================================
      // CREATE
      // =======================================================

      if (form.isCreateMode) {
        await _createHabit(
          CreateHabitRequest(
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
          ),
        );
      }

      // =======================================================
      // UPDATE
      // =======================================================

      else {
        final habit =
        form.originalHabit!;

        await _updateHabit(
          UpdateHabitRequest(
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
          ),
        );
      }

      // =======================================================
      // SUCCESS
      // =======================================================

      _update(
        form.copyWith(
          isSaving: false,
        ),
      );

      reset();

      return true;
    } catch (
    e,
    stackTrace
    ) {
      AppLogger.log(
        'Failed to save habit: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _update(
        form.copyWith(
          isSaving: false,
          error:
          'Unable to save your habit. Please try again.',
        ),
      );

      return false;
    }
  }

  // =========================================================
  // RESET
  // =========================================================

  void reset() {
    state = AsyncData(
      HabitFormState(),
    );
  }

  // =========================================================
  // DATE HELPERS
  // =========================================================

  DateTime _today() {
    final now =
    DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
    );
  }

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