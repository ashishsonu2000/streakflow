import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streak_calculator_flutter/features/habits/domain/usecases/uncomplete_habit_usecase.dart';

import '../../../../core/database/database_provider.dart';

import '../../data/datasource/habit_local_datasource_impl.dart';
import '../../data/mapper/habit_mapper.dart';
import '../../data/repositories/habit_repository_impl.dart';

import '../../domain/models/habit.dart';
import '../../domain/repositories/habit_repository.dart';

import '../../domain/services/habit_statistics_rebuilder.dart';
import '../../domain/usecases/archive_habit_usecase.dart';
import '../../domain/usecases/complete_habit_usecase.dart';
import '../../domain/usecases/create_habit_usecase.dart';
import '../../domain/usecases/delete_habit_usecase.dart';
import '../../domain/usecases/rebuild_habit_statistics_usecase.dart';
import '../../domain/usecases/restore_habit_usecase.dart';
import '../../domain/usecases/update_habit_usecase.dart';

import '../notifiers/habit_notifier.dart';

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepositoryImpl(
    HabitLocalDataSourceImpl(
      ref.read(isarServiceProvider),
      const HabitMapper(),
    ),
  );
});

/// Active habits (archived == false)
final habitsProvider = StreamProvider<List<Habit>>((ref) {
  return ref.read(habitRepositoryProvider).watchAll();
});

/// Archived habits (archived == true)
final archivedHabitsProvider = StreamProvider<List<Habit>>((ref) {
  return ref.read(habitRepositoryProvider).watchArchived();
});

final habitNotifierProvider = AsyncNotifierProvider<HabitNotifier, void>(
  HabitNotifier.new,
);

final createHabitUseCaseProvider = Provider<CreateHabitUseCase>((ref) {
  return CreateHabitUseCase(
    ref.read(habitRepositoryProvider),
  );
});

final updateHabitUseCaseProvider = Provider<UpdateHabitUseCase>((ref) {
  return UpdateHabitUseCase(
    ref.read(habitRepositoryProvider),
  );
});

final completeHabitUseCaseProvider = Provider<CompleteHabitUseCase>((ref) {
  return CompleteHabitUseCase(
    ref.read(habitRepositoryProvider),
  );
});

final archiveHabitUseCaseProvider = Provider<ArchiveHabitUseCase>((ref) {
  return ArchiveHabitUseCase(
    ref.read(habitRepositoryProvider),
  );
});

final restoreHabitUseCaseProvider = Provider<RestoreHabitUseCase>((ref) {
  return RestoreHabitUseCase(
    ref.read(habitRepositoryProvider),
  );
});

final deleteHabitUseCaseProvider = Provider<DeleteHabitUseCase>((ref) {
  return DeleteHabitUseCase(
    ref.read(habitRepositoryProvider),
  );
});

final uncompleteUseCaseProvider = Provider<UncompleteHabitUseCase>((ref) {
  return UncompleteHabitUseCase(
    ref.read(habitRepositoryProvider),
  );
});

final habitStatisticsRebuilderProvider = Provider<HabitStatisticsRebuilder>(
  (_) => const HabitStatisticsRebuilder(),
);

final rebuildHabitStatisticsUseCaseProvider =
    Provider<RebuildHabitStatisticsUseCase>(
  (ref) {
    return RebuildHabitStatisticsUseCase(
      ref.read(habitRepositoryProvider),
    );
  },
);
