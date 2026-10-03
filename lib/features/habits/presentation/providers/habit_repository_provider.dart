import 'package:flutter_riverpod/flutter_riverpod.dart';

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
