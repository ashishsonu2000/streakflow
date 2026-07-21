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
import 'habit_providers.dart';

final habitFormProvider =
    AsyncNotifierProvider<HabitFormNotifier, HabitFormState>(
  HabitFormNotifier.new,
);

class HabitFormNotifier extends AsyncNotifier<HabitFormState> {
  late final CreateHabitUseCase _createHabit;
  late final UpdateHabitUseCase _updateHabit;

  @override
  Future<HabitFormState> build() async {
    _createHabit = ref.read(createHabitUseCaseProvider);
    _updateHabit = ref.read(updateHabitUseCaseProvider);

    return const HabitFormState();
  }

  HabitFormState get form => state.requireValue;

  /// Safe getter
  HabitFormState? get current => state.valueOrNull;

  /// Updates state consistently.
  void _update(HabitFormState value) {
    state = AsyncData(value);
  }

  //HabitFormState get stateform => state.value!;

  //==================================================
  // Basic
  //==================================================

  void setTitle(String value) {
    _update(
      form.copyWith(title: value),
    );
  }

  void setDescription(String value) {
    _update(
      form.copyWith(description: value),
    );
  }

  //==================================================
  // Category
  //==================================================

  void setCategory(HabitCategory category) {
    _update(
      form.copyWith(category: category),
    );
  }

  //==================================================
  // Frequency
  //==================================================

  void setFrequency(HabitFrequency frequency) {
    _update(
      form.copyWith(frequency: frequency),
    );
  }

  //==================================================
  // Icon
  //==================================================

  void setIcon(int iconCodePoint) {
    _update(
      form.copyWith(iconCodePoint: iconCodePoint),
    );
  }

  //==================================================
  // Color
  //==================================================

  void setColor(int colorValue) {
    _update(
      form.copyWith(colorValue: colorValue),
    );
  }

  //==================================================
  // Target
  //==================================================

  void setTarget(int target) {
    _update(
      form.copyWith(
        targetPerDay: target.clamp(1, 100),
      ),
    );
  }

  void incrementTarget() {
    setTarget(form.targetPerDay + 1);
  }

  void decrementTarget() {
    if (form.targetPerDay > 1) {
      setTarget(form.targetPerDay - 1);
    }
  }

  //==================================================
  // Reminder
  //==================================================

  void setReminderEnabled(bool enabled) {
    _update(
      form.copyWith(
        reminderEnabled: enabled,
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
      ),
    );
  }

  //==================================================
  // Edit
  //==================================================

  void loadFromHabit(Habit habit) {
    _update(
      HabitFormState(
        originalHabit: habit,
        title: habit.title,
        description: habit.description,
        category: habit.category,
        frequency: habit.frequency,
        iconCodePoint: habit.iconCodePoint,
        colorValue: habit.colorValue,
        targetPerDay: habit.targetPerDay,
        reminderEnabled: habit.reminderEnabled,
        reminderHour: habit.reminderHour,
        reminderMinute: habit.reminderMinute,
        isEditing: true,
      ),
    );
  }

  //==================================================
// Duplicate
//==================================================

  void duplicateFrom(Habit habit) {
    _update(
      HabitFormState(
        title: '${habit.title} (Copy)',
        description: habit.description,
        category: habit.category,
        frequency: habit.frequency,
        iconCodePoint: habit.iconCodePoint,
        colorValue: habit.colorValue,
        targetPerDay: habit.targetPerDay,
        reminderEnabled: habit.reminderEnabled,
        reminderHour: habit.reminderHour,
        reminderMinute: habit.reminderMinute,
        isEditing: false,
      ),
    );
  }
  //==================================================
  // Validation
  //==================================================

  bool validate() {
    final title = form.title.trim();
    final description = form.description.trim();

    if (description.length > 500) {
      _update(
        form.copyWith(
          error: 'Description cannot exceed 500 characters.',
        ),
      );

      return false;
    }

    if (title.isEmpty) {
      _update(
        form.copyWith(error: "Habit title is required."),
      );
      return false;
    }

    if (title.length < 2) {
      _update(
        form.copyWith(error: "Title is too short."),
      );
      return false;
    }

    if (title.length > 60) {
      _update(
        form.copyWith(error: "Maximum 60 characters allowed."),
      );
      return false;
    }

    _update(
      form.copyWith(clearError: true),
    );

    return true;
  }

  //==================================================
  // Save
  //==================================================

  Future<bool> save() async {
    if (form.isSaving) {
      return false;
    }

    if (!validate()) {
      return false;
    }

    _update(
      form.copyWith(isSaving: true),
    );

    try {
      if (form.isCreateMode) {
        await _createHabit(
          CreateHabitRequest(
            title: form.title.trim(),
            description: form.description.trim(),
            category: form.category,
            frequency: form.frequency,
            iconCodePoint: form.iconCodePoint,
            colorValue: form.colorValue,
            targetPerDay: form.targetPerDay,
            reminderEnabled: form.reminderEnabled,
            reminderHour: form.reminderHour,
            reminderMinute: form.reminderMinute,
          ),
        );
      } else {
        final habit = form.originalHabit!;

        await _updateHabit(
          UpdateHabitRequest(
            id: habit.id,
            title: form.title.trim(),
            description: form.description.trim(),
            category: form.category,
            frequency: form.frequency,
            iconCodePoint: form.iconCodePoint,
            colorValue: form.colorValue,
            targetPerDay: form.targetPerDay,
            reminderEnabled: form.reminderEnabled,
            reminderHour: form.reminderHour,
            reminderMinute: form.reminderMinute,
            currentStreak: habit.currentStreak,
            bestStreak: habit.bestStreak,
            totalCompleted: habit.totalCompleted,
            xp: habit.xp,
            archived: habit.archived,
            createdAt: habit.createdAt,
            lastCompletedDate: habit.lastCompletedDate,
            completedToday: habit.completedToday,
          ),
        );
      }

      _update(
        form.copyWith(isSaving: false),
      );
      reset();
      return true;
    } catch (e, stackTrace) {
      debugPrint('Failed to save habit: $e');
      debugPrintStack(stackTrace: stackTrace);

      _update(
        form.copyWith(
          isSaving: false,
          error: 'Unable to save your habit. Please try again.',
        ),
      );

      return false;
    }
  }

  void reset() {
    state = const AsyncData(
      HabitFormState(),
    );
  }
}
