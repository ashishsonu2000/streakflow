import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/presentation/provider/habit_providers.dart';

import '../../domain/habit_summary_mapper.dart';
import 'today_habits.dart';

class TodayHabitsContainer extends ConsumerWidget {
  const TodayHabitsContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);

    const mapper = HabitSummaryMapper();

    return habitsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Center(
        child: Text(error.toString()),
      ),
      data: (habits) {
        return TodayHabits(
          habits: habits.map(mapper.toSummary).toList(),
        );
      },
    );
  }
}
