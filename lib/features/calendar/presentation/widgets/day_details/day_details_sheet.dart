import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/day_summary_provider.dart';

class DayDetailsSheet extends ConsumerWidget {
  const DayDetailsSheet({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(
      daySummaryProvider(date),
    );

    return SafeArea(
      child: summary.when(
        loading: () => const SizedBox(
          height: 350,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => SizedBox(
          height: 300,
          child: Center(
            child: Text(error.toString()),
          ),
        ),
        data: (summary) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${summary.date.day}/${summary.date.month}/${summary.date.year}",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.check_circle),
                    title: const Text("Completed"),
                    trailing: Text(
                      "${summary.completed.length}/${summary.totalHabits}",
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.stars),
                    title: const Text("XP Earned"),
                    trailing: Text(
                      "${summary.totalXp}",
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Completed Habits",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...summary.completed.map(
                  (habit) => ListTile(
                    leading: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    title: Text(
                      habit.title,
                    ),
                  ),
                ),
                if (summary.missed.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    "Missed Habits",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...summary.missed.map(
                    (habit) => ListTile(
                      leading: const Icon(
                        Icons.radio_button_unchecked,
                      ),
                      title: Text(
                        habit.title,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
