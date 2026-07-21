import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streak_calculator_flutter/features/habits/presentation/provider/habit_analytics_provider.dart';

import '../../data/repositories/habit_repository_impl.dart';

import '../../domain/repositories/habit_repository.dart';
import 'habit_datasource_provider.dart';

/// Repository
final habitRepositoryProvider = Provider<HabitRepository>(
  (ref) {
    return HabitRepositoryImpl(
      ref.read(habitLocalDataSourceProvider),
      //ref.read(habitAnalyticsServiceProvider),
    );
  },
);
