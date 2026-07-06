import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/habit_filter_provider.dart';
import '../provider/habit_providers.dart';
import '../provider/habit_search_provider.dart';
import '../provider/habit_sort_provider.dart';
import 'habit_tile.dart';

class HabitsList extends ConsumerWidget {
  const HabitsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);
    final search = ref.watch(habitSearchProvider);
    final filter = ref.watch(habitFilterProvider);

    return habitsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text(error.toString()),
      ),
      data: (habits) {
        final filteredHabits = habits.where((habit) {
          // Search
          if (search.trim().isNotEmpty) {
            final query = search.toLowerCase();

            final matches = habit.title.toLowerCase().contains(query) ||
                habit.description.toLowerCase().contains(query);

            if (!matches) {
              return false;
            }
          }

          // Filter
          switch (filter) {
            case HabitFilter.all:
              return true;

            case HabitFilter.today:
              return !habit.archived;

            case HabitFilter.completed:
              return habit.completedToday;

            case HabitFilter.pending:
              return !habit.completedToday && !habit.archived;

            case HabitFilter.archived:
              return habit.archived;
          }
        }).toList();

        final sort = ref.watch(habitSortProvider);

        switch (sort) {
          case HabitSort.name:
            filteredHabits.sort(
              (a, b) => a.title.toLowerCase().compareTo(
                    b.title.toLowerCase(),
                  ),
            );
            break;

          case HabitSort.createdDate:
            filteredHabits.sort(
              (a, b) => b.createdAt.compareTo(a.createdAt),
            );
            break;

          case HabitSort.currentStreak:
            filteredHabits.sort(
              (a, b) => b.currentStreak.compareTo(a.currentStreak),
            );
            break;

          case HabitSort.bestStreak:
            filteredHabits.sort(
              (a, b) => b.bestStreak.compareTo(a.bestStreak),
            );
            break;

          case HabitSort.xp:
            filteredHabits.sort(
              (a, b) => b.xp.compareTo(a.xp),
            );
            break;
        }

        if (habits.isEmpty) {
          return const Center(
            child: Text(
              "No habits yet.\nTap + to create one.",
              textAlign: TextAlign.center,
            ),
          );
        }

        if (filteredHabits.isEmpty) {
          return const Center(
            child: Text(
              "No habits found",
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: filteredHabits.length,
          itemBuilder: (context, index) {
            final habit = filteredHabits[index];

            return HabitTile(
              habit: habit,
              onComplete: () async {
                final notifier = ref.read(
                  habitNotifierProvider.notifier,
                );

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
              onTap: () {
                // Batch 7.8 - Edit Habit
              },
              onLongPress: () {
                // Batch 7.7 - Popup Menu
              },
              onArchive: () async {
                await ref.read(habitRepositoryProvider).archive(habit.id);

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${habit.title} archived"),
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
