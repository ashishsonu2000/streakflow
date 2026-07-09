import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/habits_view_provider.dart';
import '../state/habits_view_state.dart';

class HabitSortButton extends ConsumerWidget {
  const HabitSortButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(habitsViewProvider);

    return PopupMenuButton<HabitSort>(
      tooltip: "Sort",
      icon: const Icon(Icons.sort),
      initialValue: view.sort,
      onSelected: (sort) {
        ref.read(habitsViewProvider.notifier).setSort(sort);
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: HabitSort.newest,
          child: Text("Newest"),
        ),
        PopupMenuItem(
          value: HabitSort.oldest,
          child: Text("Oldest"),
        ),
        PopupMenuItem(
          value: HabitSort.alphabetical,
          child: Text("Alphabetical"),
        ),
        PopupMenuItem(
          value: HabitSort.highestStreak,
          child: Text("Highest Streak"),
        ),
        PopupMenuItem(
          value: HabitSort.highestXP,
          child: Text("Highest XP"),
        ),
      ],
    );
  }
}
