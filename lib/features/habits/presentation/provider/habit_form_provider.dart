import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entitlements/premium_config.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/enums/habit_frequency.dart';
import '../../domain/mappers/habit_form_mapper.dart';
import '../../domain/models/habit.dart';
import '../../domain/models/habit_category.dart';
import '../../domain/models/habit_form_state.dart';

import '../../domain/usecases/create_habit_usecase.dart';
import '../../domain/usecases/update_habit_usecase.dart';

import '../../../onboarding/domain/models/suggested_habit.dart';
import '../providers/habit_usecase_provider.dart';
import '../../domain/services/habit_form_validator.dart';
import '../../domain/services/habit_limit_guard.dart';

final habitFormProvider =
AsyncNotifierProvider<HabitFormNotifier, HabitFormState>(
  HabitFormNotifier.new,
);

class HabitFormNotifier
    extends AsyncNotifier<HabitFormState> {
  late final CreateHabitUseCase _createHabit;
  late final UpdateHabitUseCase _updateHabit;

  static const _validator = HabitFormValidator();
  static const _mapper = HabitFormMapper();

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
  // ADDITIONAL REMINDERS (Premium)
  // =========================================================

  /// Adds an extra reminder time (minutes since midnight). Ignores
  /// invalid values, duplicates, the primary time, and anything beyond
  /// the Premium per-habit maximum. Returns whether it was added.
  bool addAdditionalReminder(int minutesOfDay) {
    final current = form.additionalReminderMinutes;
    final primary = form.reminderHour != null && form.reminderMinute != null
        ? form.reminderHour! * 60 + form.reminderMinute!
        : null;

    if (minutesOfDay < 0 ||
        minutesOfDay >= 24 * 60 ||
        minutesOfDay == primary ||
        current.contains(minutesOfDay) ||
        current.length >= PremiumConfig.premiumRemindersPerHabit - 1) {
      return false;
    }

    _update(
      form.copyWith(
        additionalReminderMinutes: [...current, minutesOfDay]..sort(),
        clearError: true,
      ),
    );

    return true;
  }

  void removeAdditionalReminder(int minutesOfDay) {
    _update(
      form.copyWith(
        additionalReminderMinutes: form.additionalReminderMinutes
            .where((m) => m != minutesOfDay)
            .toList(),
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
    AppDateUtils.dateOnly(date);

    final currentEndDate =
        form.endDate;

    DateTime? newEndDate =
        currentEndDate;

    if (currentEndDate != null &&
        normalized.isAfter(
          AppDateUtils.dateOnly(
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
    AppDateUtils.dateOnly(date);

    final start =
    AppDateUtils.dateOnly(
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
    _update(
      _mapper.forEdit(form, habit),
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
    _update(
      _mapper.forDuplicate(
        habit,
        today: AppDateUtils.today,
      ),
    );
  }

  // =========================================================
  // VALIDATION
  // =========================================================

  bool validate() {
    final error =
    _validator.validate(form);

    if (error != null) {
      _update(
        form.copyWith(
          error: error,
        ),
      );

      return false;
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
          _mapper.toCreateRequest(form),
        );
      }

      // =======================================================
      // UPDATE
      // =======================================================

      else {
        await _updateHabit(
          _mapper.toUpdateRequest(form),
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
    } on HabitLimitReachedException catch (limitReached) {
      // Free plan active-habit limit (backstop; the UI checks before
      // opening the form).
      _update(
        form.copyWith(
          isSaving: false,
          error: limitReached.message,
        ),
      );

      return false;
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
  // SUGGESTION ("Ideas for you" on Create Habit)
  // =========================================================

  /// Fills the form from a suggested habit. The user can still change
  /// everything before saving; start date and reminders are left as set.
  void applySuggestion(
      SuggestedHabit suggestion,
      ) {
    final weekly = suggestion.frequency == HabitFrequency.weekly;

    _update(
      form.copyWith(
        title: suggestion.title,
        description: suggestion.description,
        category: suggestion.category,
        iconCodePoint: suggestion.icon.codePoint,
        colorValue: suggestion.colorValue,
        frequency: suggestion.frequency,
        weeklyDays: weekly
            ? List<int>.from(suggestion.weeklyDays)
            : null,
        clearError: true,
      ),
    );
  }

  // =========================================================
  // RESET
  // =========================================================

  void reset() {
    state = AsyncData(
      HabitFormState(),
    );
  }
}