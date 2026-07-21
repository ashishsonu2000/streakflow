import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/archive_habit_usecase.dart';
import '../../domain/usecases/complete_habit_usecase.dart';
import '../../domain/usecases/create_habit_usecase.dart';
import '../../domain/usecases/delete_habit_usecase.dart';

import '../../domain/usecases/restore_habit_usecase.dart';
import '../../domain/usecases/uncomplete_habit_usecase.dart';
import '../../domain/usecases/update_habit_usecase.dart';
import 'habit_repository_provider.dart';

final createHabitUseCaseProvider = Provider<CreateHabitUseCase>(
  (ref) => CreateHabitUseCase(
    ref.read(habitRepositoryProvider),
  ),
);

final updateHabitUseCaseProvider = Provider<UpdateHabitUseCase>(
  (ref) => UpdateHabitUseCase(
    ref.read(habitRepositoryProvider),
  ),
);

final deleteHabitUseCaseProvider = Provider<DeleteHabitUseCase>(
  (ref) => DeleteHabitUseCase(
    ref.read(habitRepositoryProvider),
  ),
);

final archiveHabitUseCaseProvider = Provider<ArchiveHabitUseCase>(
  (ref) => ArchiveHabitUseCase(
    ref.read(habitRepositoryProvider),
  ),
);

final restoreHabitUseCaseProvider = Provider<RestoreHabitUseCase>(
  (ref) => RestoreHabitUseCase(
    ref.read(habitRepositoryProvider),
  ),
);

final completeHabitUseCaseProvider = Provider<CompleteHabitUseCase>(
  (ref) => CompleteHabitUseCase(
    ref.read(habitRepositoryProvider),
  ),
);

final uncompleteHabitUseCaseProvider = Provider<UncompleteHabitUseCase>(
  (ref) => UncompleteHabitUseCase(
    ref.read(habitRepositoryProvider),
  ),
);

// final getHabitAnalyticsUseCaseProvider = Provider<GetHabitAnalyticsUseCase>(
//   (ref) => GetHabitAnalyticsUseCase(
//     ref.read(habitRepositoryProvider),
//   ),
// );
