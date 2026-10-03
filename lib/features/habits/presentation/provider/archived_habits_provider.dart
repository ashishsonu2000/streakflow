import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/habit.dart';
import 'habit_providers.dart';

final archivedHabitsProvider = StreamProvider<List<Habit>>((ref) {
  return ref
      .watch(
        habitRepositoryProvider,
      )
      .watchArchived();
});
