import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';

import '../../data/datasource/habit_local_datasource.dart';
import '../../data/datasource/habit_local_datasource_impl.dart';
import '../../data/mapper/habit_mapper.dart';

final habitMapperProvider = Provider<HabitMapper>(
  (ref) => const HabitMapper(),
);

final habitLocalDataSourceProvider = Provider<HabitLocalDataSource>(
  (ref) {
    return HabitLocalDataSourceImpl(
      ref.read(isarServiceProvider), // Uses the shared provider
      ref.read(habitMapperProvider),
    );
  },
);
