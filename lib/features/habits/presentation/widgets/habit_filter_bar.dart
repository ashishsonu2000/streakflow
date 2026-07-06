import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/habit_filter_provider.dart';

class HabitFilterBar extends ConsumerWidget {
  const HabitFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(habitFilterProvider);

    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _chip(
            ref,
            "All",
            HabitFilter.all,
            selected,
          ),
          _chip(
            ref,
            "Today",
            HabitFilter.today,
            selected,
          ),
          _chip(
            ref,
            "Completed",
            HabitFilter.completed,
            selected,
          ),
          _chip(
            ref,
            "Pending",
            HabitFilter.pending,
            selected,
          ),
          _chip(
            ref,
            "Archived",
            HabitFilter.archived,
            selected,
          ),
        ],
      ),
    );
  }

  Widget _chip(
    WidgetRef ref,
    String label,
    HabitFilter value,
    HabitFilter selected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected == value,
        onSelected: (_) {
          ref.read(habitFilterProvider.notifier).state = value;
        },
      ),
    );
  }
}
