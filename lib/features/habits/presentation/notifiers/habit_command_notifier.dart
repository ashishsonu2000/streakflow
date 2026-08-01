import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../calendar/presentation/providers/calendar_provider.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
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
import '../provider/filtered_habits_provider.dart';
import '../providers/habit_usecase_provider.dart';

class HabitCommandNotifier extends AsyncNotifier<void> {
  CreateHabitUseCase get _createHabit => ref.read(createHabitUseCaseProvider);

  UpdateHabitUseCase get _updateHabit => ref.read(updateHabitUseCaseProvider);

  DeleteHabitUseCase get _deleteHabit => ref.read(deleteHabitUseCaseProvider);

  ArchiveHabitUseCase get _archiveHabit =>
      ref.read(archiveHabitUseCaseProvider);

  RestoreHabitUseCase get _restoreHabit =>
      ref.read(restoreHabitUseCaseProvider);

  CompleteHabitUseCase get _completeHabit =>
      ref.read(completeHabitUseCaseProvider);

  UncompleteHabitUseCase get _uncompleteHabit =>
      ref.read(uncompleteHabitUseCaseProvider);

  @override
  Future<void> build() async => Future.value();

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
    debugPrint('========================================');
    debugPrint('COMPLETE HABIT START');
    debugPrint('Habit ID : $habitId');
    debugPrint('========================================');

    state = const AsyncLoading();

    try {
      debugPrint('Calling CompleteHabitUseCase...');

      await _completeHabit(
        habitId,
        durationMinutes: durationMinutes,
        notes: notes,
      );

      debugPrint('CompleteHabitUseCase SUCCESS');

      debugPrint('Invalidating filteredHabitsProvider');
      ref.invalidate(filteredHabitsProvider);

      debugPrint('Invalidating dashboardProvider');
      ref.invalidate(dashboardProvider);

      debugPrint('Invalidating calendarProvider');
      ref.invalidate(calendarProvider);

      state = const AsyncData(null);

      debugPrint('State changed to AsyncData');
      debugPrint('COMPLETE HABIT FINISHED');
      debugPrint('========================================');
    } catch (e, stack) {
      debugPrint('========================================');
      debugPrint('COMPLETE HABIT FAILED');
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: stack);
      debugPrint('========================================');

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
