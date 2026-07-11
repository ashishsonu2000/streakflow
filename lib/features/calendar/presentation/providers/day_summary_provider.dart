import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/presentation/provider/habit_providers.dart';
import '../../domain/models/day_summary.dart';
import '../../domain/services/day_summary_builder.dart';

final daySummaryProvider = FutureProvider.family<DaySummary, DateTime>(
  (ref, date) async {
    final repository = ref.read(habitRepositoryProvider);

    final habits = await repository.getAll();

    final logs = await repository.getHabitLogs();

    return const DaySummaryBuilder().build(
      date: date,
      habits: habits,
      logs: logs,
    );
  },
);
