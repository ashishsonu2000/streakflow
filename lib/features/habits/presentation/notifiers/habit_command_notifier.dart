import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../calendar/presentation/providers/calendar_provider.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../statistics/presentation/provider/statistics_provider.dart';

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
  CreateHabitUseCase get _createHabit =>
      ref.read(createHabitUseCaseProvider);

  UpdateHabitUseCase get _updateHabit =>
      ref.read(updateHabitUseCaseProvider);

  DeleteHabitUseCase get _deleteHabit =>
      ref.read(deleteHabitUseCaseProvider);

  ArchiveHabitUseCase get _archiveHabit =>
      ref.read(archiveHabitUseCaseProvider);

  RestoreHabitUseCase get _restoreHabit =>
      ref.read(restoreHabitUseCaseProvider);

  CompleteHabitUseCase get _completeHabit =>
      ref.read(completeHabitUseCaseProvider);

  UncompleteHabitUseCase get _uncompleteHabit =>
      ref.read(uncompleteHabitUseCaseProvider);

  @override
  Future<void> build() async {}

  // =========================================================
  // Add Habit
  // =========================================================

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

    // Schedule
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = const AsyncLoading();

    try {
      final effectiveStartDate =
      _dateOnly(
        startDate ?? DateTime.now(),
      );

      DateTime? effectiveEndDate;

      if (endDate != null) {
        effectiveEndDate =
            _dateOnly(endDate);

        if (effectiveEndDate.isBefore(
          effectiveStartDate,
        )) {
          throw ArgumentError(
            'End date cannot be before start date.',
          );
        }
      }

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

          // Schedule
          startDate: effectiveStartDate,
          endDate: effectiveEndDate,
        ),
      );

      _refreshProviders();

      state = const AsyncData(null);
    } catch (e, stack) {
      AppLogger.log(
        'AddHabit Error: $e',
      );

      debugPrintStack(
        stackTrace: stack,
      );

      state = AsyncError(
        e,
        stack,
      );
    }
  }

  // =========================================================
  // Update Habit
  // =========================================================

  Future<void> updateHabit(
      UpdateHabitRequest request,
      ) async {
    state = const AsyncLoading();

    try {
      await _updateHabit(request);

      _refreshProviders();

      state = const AsyncData(null);
    } catch (e, stack) {
      AppLogger.log(
        'UpdateHabit Error: $e',
      );

      debugPrintStack(
        stackTrace: stack,
      );

      state = AsyncError(
        e,
        stack,
      );
    }
  }

  // =========================================================
  // Complete Habit
  // =========================================================

  Future<void> completeHabit(
      String habitId, {
        int durationMinutes = 0,
        String notes = '',
      }) async {
    AppLogger.log(
      '========================================',
    );
    AppLogger.log(
      'COMPLETE HABIT START',
    );
    AppLogger.log(
      'Habit ID : $habitId',
    );
    AppLogger.log(
      '========================================',
    );

    state = const AsyncLoading();

    try {
      AppLogger.log(
        'Calling CompleteHabitUseCase...',
      );

      await _completeHabit(
        habitId,
        durationMinutes:
        durationMinutes,
        notes: notes,
      );

      _refreshProviders();

      state = const AsyncData(null);

      AppLogger.log(
        'CompleteHabitUseCase SUCCESS',
      );
    } catch (e, stack) {
      AppLogger.log(
        '========================================',
      );
      AppLogger.log(
        'COMPLETE HABIT FAILED',
      );
      AppLogger.log(
        'Error: $e',
      );

      debugPrintStack(
        stackTrace: stack,
      );

      AppLogger.log(
        '========================================',
      );

      state = AsyncError(
        e,
        stack,
      );
    }
  }

  // =========================================================
  // Uncomplete Habit
  // =========================================================

  Future<void> uncompleteHabit(
      String habitId,
      ) async {
    state = const AsyncLoading();

    try {
      await _uncompleteHabit(
        habitId,
      );

      _refreshProviders();

      state = const AsyncData(null);
    } catch (e, stack) {
      AppLogger.log(
        'UncompleteHabit Error: $e',
      );

      debugPrintStack(
        stackTrace: stack,
      );

      state = AsyncError(
        e,
        stack,
      );
    }
  }

  // =========================================================
  // Delete Habit
  // =========================================================

  Future<void> deleteHabit(
      String habitId,
      ) async {
    state = const AsyncLoading();

    try {
      await _deleteHabit(
        habitId,
      );

      _refreshProviders();

      state = const AsyncData(null);
    } catch (e, stack) {
      AppLogger.log(
        'DeleteHabit Error: $e',
      );

      debugPrintStack(
        stackTrace: stack,
      );

      state = AsyncError(
        e,
        stack,
      );
    }
  }

  // =========================================================
  // Archive Habit
  // =========================================================

  Future<void> archiveHabit(
      String habitId,
      ) async {
    state = const AsyncLoading();

    try {
      await _archiveHabit(
        habitId,
      );

      _refreshProviders();

      state = const AsyncData(null);
    } catch (e, stack) {
      AppLogger.log(
        'ArchiveHabit Error: $e',
      );

      debugPrintStack(
        stackTrace: stack,
      );

      state = AsyncError(
        e,
        stack,
      );
    }
  }

  // =========================================================
  // Restore Habit
  // =========================================================

  Future<void> restoreHabit(
      String habitId,
      ) async {
    state = const AsyncLoading();

    try {
      await _restoreHabit(
        habitId,
      );

      _refreshProviders();

      state = const AsyncData(null);
    } catch (e, stack) {
      AppLogger.log(
        'RestoreHabit Error: $e',
      );

      debugPrintStack(
        stackTrace: stack,
      );

      state = AsyncError(
        e,
        stack,
      );
    }
  }

  // =========================================================
  // Refresh Providers
  // =========================================================

  void _refreshProviders() {
    AppLogger.log(
      'Refreshing dependent providers...',
    );

    ref.invalidate(
      filteredHabitsProvider,
    );

    ref.invalidate(
      dashboardProvider,
    );

    ref.invalidate(
      calendarProvider,
    );

    ref.invalidate(
      statisticsProvider,
    );
  }

  // =========================================================
  // Date Helpers
  // =========================================================

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