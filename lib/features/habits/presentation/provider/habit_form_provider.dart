import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/entities/habit_frequency.dart';
import '../../domain/models/create_habit_request.dart';
import '../../domain/models/habit.dart';
import '../../domain/models/habit_category.dart';
import '../../domain/models/habit_form_state.dart';
import '../../domain/models/update_habit_request.dart';
import '../../usecases/create_habit_usecase.dart';
import '../../usecases/update_habit_usecase.dart';
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

  HabitFormState get form => state.value!;

  //==================================================
  // Basic
  //==================================================

  void setTitle(String value) {
    state = AsyncData(
      form.copyWith(title: value),
    );
  }

  void setDescription(String value) {
    state = AsyncData(
      form.copyWith(description: value),
    );
  }

  //==================================================
  // Category
  //==================================================

  void setCategory(HabitCategory category) {
    state = AsyncData(
      form.copyWith(category: category),
    );
  }

  //==================================================
  // Frequency
  //==================================================

  void setFrequency(HabitFrequency frequency) {
    state = AsyncData(
      form.copyWith(frequency: frequency),
    );
  }

  //==================================================
  // Icon
  //==================================================

  void setIcon(int iconCodePoint) {
    state = AsyncData(
      form.copyWith(iconCodePoint: iconCodePoint),
    );
  }

  //==================================================
  // Color
  //==================================================

  void setColor(int colorValue) {
    state = AsyncData(
      form.copyWith(colorValue: colorValue),
    );
  }

  //==================================================
  // Target
  //==================================================

  void setTarget(int target) {
    state = AsyncData(
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
    state = AsyncData(
      form.copyWith(
        reminderEnabled: enabled,
      ),
    );
  }

  void setReminderTime({
    required int hour,
    required int minute,
  }) {
    state = AsyncData(
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
    state = AsyncData(
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
  // Validation
  //==================================================

  bool validate() {
    final title = form.title.trim();

    if (title.isEmpty) {
      state = AsyncData(
        form.copyWith(error: "Habit title is required."),
      );
      return false;
    }

    if (title.length < 2) {
      state = AsyncData(
        form.copyWith(error: "Title is too short."),
      );
      return false;
    }

    if (title.length > 60) {
      state = AsyncData(
        form.copyWith(error: "Maximum 60 characters allowed."),
      );
      return false;
    }

    state = AsyncData(
      form.copyWith(clearError: true),
    );

    return true;
  }

  //==================================================
  // Save
  //==================================================

  Future<bool> save() async {
    if (!validate()) {
      return false;
    }

    state = AsyncData(
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

      state = AsyncData(
        form.copyWith(isSaving: false),
      );

      return true;
    } catch (e) {
      state = AsyncData(
        form.copyWith(
          isSaving: false,
          error: e.toString(),
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
