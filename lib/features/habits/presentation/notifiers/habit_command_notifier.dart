import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/enums/habit_frequency.dart';
import '../../domain/models/create_habit_request.dart';
import '../../domain/models/habit_category.dart';
import '../../domain/models/update_habit_request.dart';
import '../../domain/usecases/archive_habit_usecase.dart';
import '../../domain/usecases/complete_habit_usecase.dart';
import '../../domain/usecases/create_habit_usecase.dart';
import '../../domain/usecases/delete_habit_usecase.dart';
import '../../domain/usecases/restore_habit_usecase.dart';
import '../../domain/usecases/uncomplete_habit_usecase.dart';
import '../../domain/usecases/update_habit_usecase.dart';
import '../providers/habit_usecase_provider.dart';

class HabitCommandNotifier extends AsyncNotifier<void> {
  late final CreateHabitUseCase _createHabit;
  late final UpdateHabitUseCase _updateHabit;
  late final DeleteHabitUseCase _deleteHabit;
  late final ArchiveHabitUseCase _archiveHabit;
  late final RestoreHabitUseCase _restoreHabit;
  late final CompleteHabitUseCase _completeHabit;
  late final UncompleteHabitUseCase _uncompleteHabit;

  @override
  Future<void> build() async {
    _createHabit = ref.read(createHabitUseCaseProvider);
    _updateHabit = ref.read(updateHabitUseCaseProvider);
    _deleteHabit = ref.read(deleteHabitUseCaseProvider);
    _archiveHabit = ref.read(archiveHabitUseCaseProvider);
    _restoreHabit = ref.read(restoreHabitUseCaseProvider);
    _completeHabit = ref.read(completeHabitUseCaseProvider);
    _uncompleteHabit = ref.read(uncompleteHabitUseCaseProvider);
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
      debugPrint('AddHabit Error: $e');
      debugPrintStack(stackTrace: stack);
      state = AsyncError(e, stack);
    }
  }

  Future<void> updateHabit(UpdateHabitRequest request) async {
    state = const AsyncLoading();

    try {
      await _updateHabit(request);
      state = const AsyncData(null);
    } catch (e, stack) {
      debugPrint('UpdateHabit Error: $e');
      debugPrintStack(stackTrace: stack);
      state = AsyncError(e, stack);
    }
  }

  Future<void> completeHabit(
    String habitId, {
    int durationMinutes = 0,
    String notes = '',
  }) async {
    state = const AsyncLoading();

    try {
      await _completeHabit(
        habitId,
        durationMinutes: durationMinutes,
        notes: notes,
      );

      state = const AsyncData(null);
    } catch (e, stack) {
      debugPrint('CompleteHabit Error: $e');
      debugPrintStack(stackTrace: stack);
      state = AsyncError(e, stack);
    }
  }

  Future<void> uncompleteHabit(String habitId) async {
    state = const AsyncLoading();

    try {
      await _uncompleteHabit(habitId);
      state = const AsyncData(null);
    } catch (e, stack) {
      debugPrint('UncompleteHabit Error: $e');
      debugPrintStack(stackTrace: stack);
      state = AsyncError(e, stack);
    }
  }

  Future<void> deleteHabit(String habitId) async {
    state = const AsyncLoading();

    try {
      await _deleteHabit(habitId);
      state = const AsyncData(null);
    } catch (e, stack) {
      debugPrint('DeleteHabit Error: $e');
      debugPrintStack(stackTrace: stack);
      state = AsyncError(e, stack);
    }
  }

  Future<void> archiveHabit(String habitId) async {
    state = const AsyncLoading();

    try {
      await _archiveHabit(habitId);
      state = const AsyncData(null);
    } catch (e, stack) {
      debugPrint('ArchiveHabit Error: $e');
      debugPrintStack(stackTrace: stack);
      state = AsyncError(e, stack);
    }
  }

  Future<void> restoreHabit(String habitId) async {
    state = const AsyncLoading();

    try {
      await _restoreHabit(habitId);
      state = const AsyncData(null);
    } catch (e, stack) {
      debugPrint('RestoreHabit Error: $e');
      debugPrintStack(stackTrace: stack);
      state = AsyncError(e, stack);
    }
  }
}
