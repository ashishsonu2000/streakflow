import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../habits/data/datasource/habit_local_datasource.dart';
import '../../../habits/data/datasource/habit_local_datasource_impl.dart';
import '../../../habits/data/mapper/habit_mapper.dart';
import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/repositories/habit_repository.dart';
import '../../../habits/domain/repositories/habit_repository_impl.dart';
import '../../domain/models/analytics_summary.dart';
import '../../domain/services/habit_analytics_service.dart';
import '../../usecases/complete_habit_usecase.dart';
import '../../usecases/create_habit_usecase.dart';
import '../../usecases/get_habit_analytics_usecase.dart';

import '../../usecases/update_habit_usecase.dart';
import '../notifiers/habit_notifier.dart';
import '../../data/entities/habit_log_entity.dart';

/// Mapper
final habitMapperProvider = Provider<HabitMapper>((ref) {
  return const HabitMapper();
});

/// Live stream of habit logs from Isar
final habitLogsProvider = StreamProvider<List<HabitLogEntity>>((ref) {
  return ref.read(habitRepositoryProvider).watchHabitLogs();
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
    ref.read(habitAnalyticsServiceProvider),
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

final completeHabitUseCaseProvider = Provider<CompleteHabitUseCase>((ref) {
  return CompleteHabitUseCase(
    ref.read(habitRepositoryProvider),
  );
});

final updateHabitUseCaseProvider = Provider<UpdateHabitUseCase>((ref) {
  return UpdateHabitUseCase(
    ref.watch(habitRepositoryProvider),
  );
});

final habitAnalyticsServiceProvider = Provider<HabitAnalyticsService>(
  (_) => const HabitAnalyticsService(),
);

final getHabitAnalyticsUseCaseProvider = Provider<GetHabitAnalyticsUseCase>(
  (ref) {
    return GetHabitAnalyticsUseCase(
      ref.read(
        habitRepositoryProvider,
      ),
    );
  },
);

final habitAnalyticsProvider = FutureProvider.family<AnalyticsSummary, String>(
  (ref, habitId) {
    return ref
        .read(
          getHabitAnalyticsUseCaseProvider,
        )
        .call(
          habitId,
        );
  },
);
