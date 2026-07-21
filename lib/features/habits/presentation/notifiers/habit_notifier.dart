import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/enums/habit_frequency.dart';
import '../../domain/models/create_habit_request.dart';
import '../../domain/models/habit_category.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../domain/usecases/complete_habit_usecase.dart';
import '../../domain/usecases/create_habit_usecase.dart';
import '../provider/habit_providers.dart';

class HabitNotifier extends AsyncNotifier<void> {
  late HabitRepository _repository;
  late CreateHabitUseCase _createHabit;
  late CompleteHabitUseCase _completeHabit;

  @override
  Future<void> build() async {
    _repository = ref.watch(habitRepositoryProvider);
    _createHabit = ref.watch(createHabitUseCaseProvider);
    _completeHabit = ref.watch(completeHabitUseCaseProvider);
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
    state = const AsyncLoading();

    try {
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

      state = const AsyncData(null);
    } catch (e, stack) {
      debugPrint("AddHabit Error: $e");
      debugPrintStack(stackTrace: stack);

      state = AsyncError(e, stack);
    }
  }

  Future<void> completeHabit(String habitId) async {
    state = const AsyncLoading();

    try {
      await _completeHabit(habitId);

      state = const AsyncData(null);
    } catch (e, stack) {
      debugPrint("CompleteHabit Error: $e");
      debugPrintStack(stackTrace: stack);

      state = AsyncError(e, stack);
    }
  }

  Future<void> uncompleteHabit(String habitId) async {
    state = const AsyncLoading();

    try {
      await _repository.uncompleteHabit(habitId);

      state = const AsyncData(null);
    } catch (e, stack) {
      debugPrint("UncompleteHabit Error: $e");
      debugPrintStack(stackTrace: stack);

      state = AsyncError(e, stack);
    }
  }

  Future<void> deleteHabit(String id) async {
    state = const AsyncLoading();

    try {
      await _repository.delete(id);

      state = const AsyncData(null);
    } catch (e, stack) {
      debugPrint("DeleteHabit Error: $e");
      debugPrintStack(stackTrace: stack);

      state = AsyncError(e, stack);
    }
  }

  Future<void> archiveHabit(String id) async {
    state = const AsyncLoading();

    try {
      await _repository.archive(id);

      state = const AsyncData(null);
    } catch (e, stack) {
      debugPrint("ArchiveHabit Error: $e");
      debugPrintStack(stackTrace: stack);

      state = AsyncError(e, stack);
    }
  }

  Future<void> restoreHabit(String id) async {
    state = const AsyncLoading();

    try {
      await _repository.restore(id);

      state = const AsyncData(null);
    } catch (e, stack) {
      debugPrint("RestoreHabit Error: $e");
      debugPrintStack(stackTrace: stack);

      state = AsyncError(e, stack);
    }
  }
}
