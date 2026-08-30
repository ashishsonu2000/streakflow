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
  // Build
  // =========================================================

  @override
  Future<HabitFormState> build() async {
    _createHabit =
        ref.read(createHabitUseCaseProvider);

    _updateHabit =
        ref.read(updateHabitUseCaseProvider);

    debugPrint(
      'HABIT FORM CREATE USE CASE: '
          '${_createHabit.runtimeType}',
    );

    debugPrint(
      'HABIT FORM UPDATE USE CASE: '
          '${_updateHabit.runtimeType}',
    );

    return HabitFormState();
  }

  // =========================================================
  // State Helpers
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
  // Basic
  // =========================================================

  void setTitle(String value) {
    _update(
      form.copyWith(
        title: value,
        clearError: true,
      ),
    );
  }

  void setDescription(String value) {
    _update(
      form.copyWith(
        description: value,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // Category
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
  // Frequency
  // =========================================================

  void setFrequency(
      HabitFrequency frequency,
      ) {
    var weeklyDays =
    List<int>.from(form.weeklyDays);

    var monthlyDay =
        form.monthlyDay;

    // -------------------------------------------------------
    // Weekly
    // -------------------------------------------------------

    if (frequency ==
        HabitFrequency.weekly &&
        weeklyDays.isEmpty) {
      weeklyDays = [
        form.startDate.weekday,
      ];
    }

    // -------------------------------------------------------
    // Monthly
    // -------------------------------------------------------

    if (frequency ==
        HabitFrequency.monthly) {
      monthlyDay =
          form.startDate.day;
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
  // Weekly Days
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
      // At least one weekday must remain selected.
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
  // Monthly Day
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
  // Icon
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
  // Color
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
  // Target
  // =========================================================

  void setTarget(
      int target,
      ) {
    _update(
      form.copyWith(
        targetPerDay:
        target.clamp(1, 100),
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
    if (form.targetPerDay > 1) {
      setTarget(
        form.targetPerDay - 1,
      );
    }
  }

  // =========================================================
  // Reminder
  // =========================================================

  void setReminderEnabled(
      bool enabled,
      ) {
    _update(
      form.copyWith(
        reminderEnabled: enabled,
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
  // Schedule
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
          _dateOnly(currentEndDate),
        )) {
      newEndDate = null;
    }

    // -------------------------------------------------------
    // Weekly
    // -------------------------------------------------------

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

    // -------------------------------------------------------
    // Monthly
    //
    // Only set the start-date day when there isn't already
    // a monthly selection.
    // -------------------------------------------------------

    var monthlyDay =
        form.monthlyDay;

    if (form.frequency ==
        HabitFrequency.monthly &&
        monthlyDay < 1) {
      monthlyDay =
          normalized.day;
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

  void setEndDate(
      DateTime? date,
      ) {
    if (date == null) {
      clearEndDate();
      return;
    }

    final normalized =
    _dateOnly(date);

    final startDate =
    _dateOnly(
      form.startDate,
    );

    if (normalized.isBefore(
      startDate,
    )) {
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
  // Edit
  // =========================================================

  Future<void> loadFromHabit(
      Habit habit,
      ) async {
    var weeklyDays =
    List<int>.from(
      habit.weeklyDays,
    );

    // Backward compatibility for old weekly habits.
    if (habit.frequency ==
        HabitFrequency.weekly &&
        weeklyDays.isEmpty) {
      weeklyDays = [
        habit.startDate.weekday,
      ];
    }

    var monthlyDay =
        habit.monthlyDay;

    // Backward compatibility for old monthly habits.
    if (habit.frequency ==
        HabitFrequency.monthly &&
        (monthlyDay < 1 ||
            monthlyDay > 31)) {
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
        habit.startDate,

        endDate:
        habit.endDate,

        isEditing: true,

        clearError: true,
      ),
    );
  }

  // =========================================================
  // Duplicate
  // =========================================================

  Future<void> duplicateFrom(
      Habit habit,
      ) async {
    var weeklyDays =
    List<int>.from(
      habit.weeklyDays,
    );

    if (habit.frequency ==
        HabitFrequency.weekly &&
        weeklyDays.isEmpty) {
      weeklyDays = [
        habit.startDate.weekday,
      ];
    }

    var monthlyDay =
        habit.monthlyDay;

    if (habit.frequency ==
        HabitFrequency.monthly &&
        (monthlyDay < 1 ||
            monthlyDay > 31)) {
      monthlyDay =
          habit.startDate.day;
    }

    _update(
      form.copyWith(
        originalHabit: null,

        title:
        '${habit.title} Copy',

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
        _today(),

        clearEndDate: true,

        isEditing: false,

        clearError: true,
      ),
    );
  }

  // =========================================================
  // Validation
  // =========================================================

  bool validate() {
    final title =
    form.title.trim();

    final description =
    form.description.trim();

    // -------------------------------------------------------
    // Description
    // -------------------------------------------------------

    if (description.length > 500) {
      _update(
        form.copyWith(
          error:
          'Description cannot exceed 500 characters.',
        ),
      );

      return false;
    }

    // -------------------------------------------------------
    // Title
    // -------------------------------------------------------

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

    // -------------------------------------------------------
    // Dates
    // -------------------------------------------------------

    if (form.isEndDateBeforeStart) {
      _update(
        form.copyWith(
          error:
          'End date cannot be before start date.',
        ),
      );

      return false;
    }

    // -------------------------------------------------------
    // Weekly schedule
    // -------------------------------------------------------

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

    // -------------------------------------------------------
    // Monthly schedule
    // -------------------------------------------------------

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

    // -------------------------------------------------------
    // Reminder
    // -------------------------------------------------------

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
  // Save
  // =========================================================

  Future<bool> save() async {
    debugPrint(
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
      debugPrint(
        'mode = '
            '${form.isCreateMode ? 'CREATE' : 'EDIT'}',
      );

      debugPrint(
        'title = ${form.title}',
      );

      debugPrint(
        'frequency = ${form.frequency}',
      );

      debugPrint(
        'weeklyDays = ${form.weeklyDays}',
      );

      debugPrint(
        'monthlyDay = ${form.monthlyDay}',
      );

      debugPrint(
        'target = ${form.targetPerDay}',
      );

      debugPrint(
        'startDate = ${form.startDate}',
      );

      debugPrint(
        'endDate = ${form.endDate}',
      );

      // =====================================================
      // CREATE
      // =====================================================

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

            weeklyDays:
            List<int>.from(
              form.weeklyDays,
            ),

            monthlyDay:
            form.monthlyDay,

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

            startDate:
            form.startDate,

            endDate:
            form.endDate,
          ),
        );
      }

      // =====================================================
      // UPDATE
      // =====================================================

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

            weeklyDays:
            List<int>.from(
              form.weeklyDays,
            ),

            monthlyDay:
            form.monthlyDay,

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

            startDate:
            form.startDate,

            endDate:
            form.endDate,

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

      // =====================================================
      // Success
      // =====================================================

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
      debugPrint(
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
  // Reset
  // =========================================================

  void reset() {
    state = AsyncData(
      HabitFormState(),
    );
  }

  // =========================================================
  // Date Helpers
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