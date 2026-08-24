import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../notifications/presentation/providers/notification_usecase_provider.dart';

import '../../domain/usecases/archive_habit_usecase.dart';
import '../../domain/usecases/complete_habit_usecase.dart';
import '../../domain/usecases/create_habit_usecase.dart';
import '../../domain/usecases/delete_habit_usecase.dart';
import '../../domain/usecases/get_habits_usecase.dart';
import '../../domain/usecases/restore_habit_usecase.dart';
import '../../domain/usecases/uncomplete_habit_usecase.dart';
import '../../domain/usecases/update_habit_usecase.dart';

import 'habit_repository_provider.dart';

// =========================================================
// Create Habit
// =========================================================

final createHabitUseCaseProvider =
Provider<CreateHabitUseCase>((ref) {
  return CreateHabitUseCase(
    ref.read(habitRepositoryProvider),
    ref.read(
      scheduleHabitReminderUseCaseProvider,
    ),
  );
});

// =========================================================
// Update Habit
// =========================================================

final updateHabitUseCaseProvider =
Provider<UpdateHabitUseCase>((ref) {
  return UpdateHabitUseCase(
    ref.read(habitRepositoryProvider),
    ref.read(
      scheduleHabitReminderUseCaseProvider,
    ),
    ref.read(
      cancelHabitReminderUseCaseProvider,
    ),
  );
});

// =========================================================
// Delete Habit
// =========================================================

final deleteHabitUseCaseProvider =
Provider<DeleteHabitUseCase>((ref) {
  return DeleteHabitUseCase(
    ref.read(habitRepositoryProvider),
  );
});

// =========================================================
// Archive Habit
// =========================================================

final archiveHabitUseCaseProvider =
Provider<ArchiveHabitUseCase>((ref) {
  return ArchiveHabitUseCase(
    ref.read(habitRepositoryProvider),
  );
});

// =========================================================
// Restore Habit
// =========================================================

final restoreHabitUseCaseProvider =
Provider<RestoreHabitUseCase>((ref) {
  return RestoreHabitUseCase(
    ref.read(habitRepositoryProvider),
  );
});

// =========================================================
// Complete Habit
// =========================================================

final completeHabitUseCaseProvider =
Provider<CompleteHabitUseCase>((ref) {
  return CompleteHabitUseCase(
    ref.read(habitRepositoryProvider),
  );
});

// =========================================================
// Uncomplete Habit
// =========================================================

final uncompleteHabitUseCaseProvider =
Provider<UncompleteHabitUseCase>((ref) {
  return UncompleteHabitUseCase(
    ref.read(habitRepositoryProvider),
  );
});

// =========================================================
// Get Habits
// =========================================================

final getHabitsUseCaseProvider =
Provider<GetHabitsUseCase>((ref) {
  return GetHabitsUseCase(
    ref.read(habitRepositoryProvider),
  );
});