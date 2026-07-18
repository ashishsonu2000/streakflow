import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';

import '../../data/datasource/habit_local_datasource_impl.dart';
import '../../data/mapper/habit_mapper.dart';

import '../../domain/models/analytics_summary.dart';
import '../../domain/models/habit.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../domain/repositories/habit_repository_impl.dart';

import '../../usecases/complete_habit_usecase.dart';
import '../../usecases/create_habit_usecase.dart';
import '../../usecases/get_habit_analytics_usecase.dart';
import '../../usecases/update_habit_usecase.dart';
import '../notifiers/habit_notifier.dart';
import 'habit_analytics_provider.dart';

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepositoryImpl(
    HabitLocalDataSourceImpl(
      ref.read(isarServiceProvider),
      const HabitMapper(),
    ),
    ref.read(habitAnalyticsServiceProvider),
  );
});

final habitsProvider = StreamProvider<List<Habit>>((ref) {
  return ref.read(habitRepositoryProvider).watchAll();
});

final habitNotifierProvider = AsyncNotifierProvider<HabitNotifier, void>(
  HabitNotifier.new,
);

final getHabitAnalyticsUseCaseProvider =
    Provider<GetHabitAnalyticsUseCase>((ref) {
  return GetHabitAnalyticsUseCase(
    ref.read(habitRepositoryProvider),
  );
});

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

final habitAnalyticsProvider = FutureProvider.family<AnalyticsSummary, String>(
  (ref, habitId) {
    return ref.read(getHabitAnalyticsUseCaseProvider)(habitId);
  },
);
