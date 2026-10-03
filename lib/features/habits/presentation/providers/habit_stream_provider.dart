import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/entities/habit_log_entity.dart';
import '../../domain/models/habit.dart';
import 'habit_repository_provider.dart';

/// ------------------------------------------------------------
/// Habits Stream
/// ------------------------------------------------------------
///
/// Single source of truth for all Habits.
///
/// Used by:
/// • Habits Page
/// • Dashboard
/// • Statistics
/// • Calendar
/// • Achievements
///
final habitsProvider = StreamProvider.autoDispose<List<Habit>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);

  return repository.watchAll();
});

/// ------------------------------------------------------------
/// Habit Logs Stream
/// ------------------------------------------------------------
///
/// Reactive stream of all habit logs.
///
/// Used by:
/// • Dashboard
/// • Calendar Heatmap
/// • Weekly Progress
/// • Monthly Analytics
/// • Achievements
///
final habitLogsProvider =
    StreamProvider.autoDispose<List<HabitLogEntity>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);

  return repository.watchHabitLogs();
});
