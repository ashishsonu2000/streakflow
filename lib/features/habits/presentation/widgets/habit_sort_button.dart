import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/habit_sort_provider.dart';

class HabitSortButton extends ConsumerWidget {
  const HabitSortButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(habitSortProvider);

    return PopupMenuButton<HabitSort>(
      tooltip: "Sort Habits",
      icon: const Icon(Icons.sort),
      initialValue: sort,
      onSelected: (value) {
        ref.read(habitSortProvider.notifier).state = value;
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: HabitSort.name,
          child: Text("Name"),
        ),
        PopupMenuItem(
          value: HabitSort.createdDate,
          child: Text("Created Date"),
        ),
        PopupMenuItem(
          value: HabitSort.currentStreak,
          child: Text("Current Streak"),
        ),
        PopupMenuItem(
          value: HabitSort.bestStreak,
          child: Text("Best Streak"),
        ),
        PopupMenuItem(
          value: HabitSort.xp,
          child: Text("XP"),
        ),
      ],
    );
  }
}
