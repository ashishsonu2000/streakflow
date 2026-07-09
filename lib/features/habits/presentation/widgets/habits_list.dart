import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/filtered_habits_provider.dart';

import '../provider/habit_providers.dart';

import 'habit_tile.dart';

class HabitsList extends ConsumerWidget {
  const HabitsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(filteredHabitsProvider);

    return habitsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text(error.toString()),
      ),
      data: (habits) {
        if (habits.isEmpty) {
          return const Center(
            child: Text(
              "No habits found",
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];

            return HabitTile(
              habit: habit,
              onComplete: () async {
                final notifier = ref.read(habitNotifierProvider.notifier);

                if (habit.completedToday) {
                  await notifier.uncompleteHabit(habit.id);
                } else {
                  await notifier.completeHabit(habit.id);
                }

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      habit.completedToday
                          ? "Habit marked as pending"
                          : "+5 XP • ${habit.title} completed 🎉",
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              onTap: () {},
              onLongPress: () {},
              onArchive: () async {
                await ref.read(habitRepositoryProvider).archive(habit.id);

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "${habit.title} archived",
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
