import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/repositories/habit_repository.dart';
import '../../data/entities/habit_frequency.dart';
import '../../domain/models/create_habit_request.dart';
import '../../domain/models/habit_category.dart';
import '../../domain/models/habit_form_state.dart';
import '../../usecases/complete_habit_usecase.dart';
import '../../usecases/create_habit_usecase.dart';
import '../provider/habit_providers.dart';

class HabitNotifier extends AsyncNotifier<List<Habit>> {
  late final HabitRepository _repository;
  late final CreateHabitUseCase _createHabit;
  late final CompleteHabitUseCase _completeHabit;

  @override
  Future<List<Habit>> build() async {
    _repository = ref.read(habitRepositoryProvider);
    _createHabit = ref.read(createHabitUseCaseProvider);
    _completeHabit = ref.read(completeHabitUseCaseProvider);

    return _repository.getAll();
  }

  Future<void> refresh() async {
    try {
      state = const AsyncLoading();

      final habits = await _repository.getAll();

      state = AsyncData(habits);
    } catch (e, stack) {
      debugPrint("Refresh Error: $e");
      debugPrintStack(stackTrace: stack);

      state = AsyncError(e, stack);
    }
  }

  Future<void> addHabit({
    required String title,
    String description = '',
    HabitCategory category = HabitCategory.personal,
    HabitFrequency frequency = HabitFrequency.daily,
    int iconCodePoint = 0,
    int colorValue = 0,
    int targetPerDay = 1,
    bool reminderEnabled = false,
    int? reminderHour,
    int? reminderMinute,
  }) async {
    try {
      state = const AsyncLoading();

      await _createHabit(
        CreateHabitRequest(
          title: title,
          description: description,
          category: category,
          frequency: frequency,
          iconCodePoint: iconCodePoint,
          colorValue: colorValue,
          targetPerDay: targetPerDay,
          reminderEnabled: reminderEnabled,
          reminderHour: reminderHour,
          reminderMinute: reminderMinute,
        ),
      );

      final habits = await _repository.getAll();

      state = AsyncData(habits);
    } catch (e, stack) {
      debugPrint("AddHabit Error: $e");
      debugPrintStack(stackTrace: stack);

      state = AsyncError(e, stack);
    }
  }

  Future<void> completeHabit(String habitId) async {
    try {
      state = const AsyncLoading();

      await _completeHabit(habitId);

      final habits = await _repository.getAll();

      state = AsyncData(habits);
    } catch (e, stack) {
      debugPrint("CompleteHabit Error: $e");
      debugPrintStack(stackTrace: stack);

      state = AsyncError(e, stack);
    }
  }

  Future<void> uncompleteHabit(String habitId) async {
    try {
      state = const AsyncLoading();

      await _repository.uncompleteHabit(habitId);

      final habits = await _repository.getAll();

      state = AsyncData(habits);
    } catch (e, stack) {
      debugPrint("UncompleteHabit Error: $e");
      debugPrintStack(stackTrace: stack);

      state = AsyncError(e, stack);
    }
  }

  Future<void> deleteHabit(String id) async {
    try {
      state = const AsyncLoading();

      await _repository.delete(id);

      final habits = await _repository.getAll();

      state = AsyncData(habits);
    } catch (e, stack) {
      debugPrint("DeleteHabit Error: $e");
      debugPrintStack(stackTrace: stack);

      state = AsyncError(e, stack);
    }
  }

  Future<void> archiveHabit(String id) async {
    try {
      state = const AsyncLoading();

      await _repository.archive(id);

      final habits = await _repository.getAll();

      state = AsyncData(habits);
    } catch (e, stack) {
      debugPrint("ArchiveHabit Error: $e");
      debugPrintStack(stackTrace: stack);

      state = AsyncError(e, stack);
    }
  }

  Future<void> restoreHabit(String id) async {
    try {
      state = const AsyncLoading();

      await _repository.restore(id);

      final habits = await _repository.getAll();

      state = AsyncData(habits);
    } catch (e, stack) {
      debugPrint("RestoreHabit Error: $e");
      debugPrintStack(stackTrace: stack);

      state = AsyncError(e, stack);
    }
  }

  List<Habit>? get current => state.valueOrNull;
}
