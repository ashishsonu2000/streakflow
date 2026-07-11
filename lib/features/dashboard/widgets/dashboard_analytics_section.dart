import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../habits/presentation/analytics/sections/analytics_section.dart';
import '../../habits/presentation/provider/habit_providers.dart';

class DashboardAnalyticsSection extends ConsumerWidget {
  const DashboardAnalyticsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);

    return habitsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(error.toString()),
        ),
      ),
      data: (habits) {
        if (habits.isEmpty) {
          return const SizedBox.shrink();
        }

        //--------------------------------------------------
        // For now show analytics of first habit
        //--------------------------------------------------

        final firstHabit = habits.first;

        final analyticsAsync = ref.watch(
          habitAnalyticsProvider(firstHabit.id),
        );

        return analyticsAsync.when(
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          error: (error, stack) => Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(error.toString()),
            ),
          ),
          data: (analytics) {
            return AnalyticsSection(
              analytics: analytics,
            );
          },
        );
      },
    );
  }
}
