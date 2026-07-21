import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/isar_service.dart';
import '../../data/datasource/habit_local_datasource.dart';
import '../../data/datasource/habit_local_datasource_impl.dart';
import '../../data/mapper/habit_mapper.dart';

/// Mapper
final habitMapperProvider = Provider<HabitMapper>(
  (ref) => HabitMapper(),
);

/// Isar Service
final isarServiceProvider = Provider<IsarService>(
  (ref) => IsarService(),
);

/// Local Datasource
final habitLocalDataSourceProvider = Provider<HabitLocalDataSource>(
  (ref) {
    return HabitLocalDataSourceImpl(
      ref.read(isarServiceProvider),
      ref.read(habitMapperProvider),
    );
  },
);
