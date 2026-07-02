import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../habits/data/datasource/habit_local_datasource.dart';
import '../../../habits/data/datasource/habit_local_datasource_impl.dart';
import '../../../habits/data/mapper/habit_mapper.dart';
import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/repositories/habit_repository.dart';
import '../../../habits/domain/repositories/habit_repository_impl.dart';
import '../../usecases/create_habit_usecase.dart';
import '../notifiers/habit_notifier.dart';

/// Mapper
final habitMapperProvider = Provider<HabitMapper>((ref) {
  return const HabitMapper();
});

/// Local Data Source
final habitLocalDataSourceProvider = Provider<HabitLocalDataSource>((ref) {
  return HabitLocalDataSourceImpl(
    ref.read(isarServiceProvider),
    ref.read(habitMapperProvider),
  );
});

/// Repository
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepositoryImpl(
    ref.read(habitLocalDataSourceProvider),
  );
});

/// Live stream of habits from Isar
final habitsProvider = StreamProvider<List<Habit>>((ref) {
  return ref.read(habitRepositoryProvider).watchAll();
});

final habitNotifierProvider = AsyncNotifierProvider<HabitNotifier, List<Habit>>(
  HabitNotifier.new,
);

final createHabitUseCaseProvider = Provider<CreateHabitUseCase>((ref) {
  return CreateHabitUseCase(
    ref.read(habitRepositoryProvider),
  );
});
