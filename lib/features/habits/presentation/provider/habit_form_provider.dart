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

  @override
  Future<HabitFormState> build() async {
    _createHabit =
        ref.read(createHabitUseCaseProvider);
    debugPrint(
      'HABIT FORM USING CREATE USE CASE: ${_createHabit.runtimeType}',
    );
    _updateHabit =
        ref.read(updateHabitUseCaseProvider);
    debugPrint(
      'HABIT FORM USING CREATE USE CASE: ${_updateHabit.runtimeType}',
    );
    return HabitFormState();
  }

  HabitFormState get form => state.requireValue;

  /// Safe getter.
  HabitFormState? get current =>
      state.valueOrNull;

  /// Updates state consistently.
  void _update(HabitFormState value) {
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
      ),
    );
  }

  // =========================================================
  // Frequency
  // =========================================================

  void setFrequency(
      HabitFrequency frequency,
      ) {
    _update(
      form.copyWith(
        frequency: frequency,
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
        iconCodePoint: iconCodePoint,
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
      ),
    );
  }

  // =========================================================
  // Target
  // =========================================================

  void setTarget(int target) {
    _update(
      form.copyWith(
        targetPerDay: target.clamp(1, 100),
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

    final endDate = form.endDate;

    // If the new start date is after
    // the current end date, clear the end date.
    if (endDate != null &&
        normalized.isAfter(
          _dateOnly(endDate),
        )) {
      _update(
        form.copyWith(
          startDate: normalized,
          clearEndDate: true,
          clearError: true,
        ),
      );

      return;
    }

    _update(
      form.copyWith(
        startDate: normalized,
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
    _dateOnly(form.startDate);

    if (normalized.isBefore(startDate)) {
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
    state = AsyncData(
      form.copyWith(
        originalHabit: habit,

        title: habit.title,
        description: habit.description,

        category: habit.category,
        frequency: habit.frequency,

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

        // Schedule
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
    state = AsyncData(
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

        // New duplicated habit starts today.
        startDate:
        _today(),

        // Do not copy the old habit's
        // expiration date.
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

    if (description.length > 500) {
      _update(
        form.copyWith(
          error:
          'Description cannot exceed 500 characters.',
        ),
      );

      return false;
    }

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
    // Schedule validation
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
    // Reminder validation
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
    debugPrint('========== FLOW 2: HabitFormNotifier.save ==========');
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
        'FLOW 2: mode = ${form.isCreateMode ? 'CREATE' : 'EDIT'}',
      );

      debugPrint(
        'FLOW 2: title = ${form.title}',
      );

      debugPrint(
        'FLOW 2: reminderEnabled = ${form.reminderEnabled}',
      );

      debugPrint(
        'FLOW 2: reminderTime = '
            '${form.reminderHour}:${form.reminderMinute}',
      );

      debugPrint(
        'FLOW 2: startDate = ${form.startDate}',
      );

      debugPrint(
        'FLOW 2: endDate = ${form.endDate}',
      );
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
          ),
        );
      } else {
        final habit =
        form.originalHabit!;

        await _updateHabit(
          UpdateHabitRequest(
            id: habit.id,

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