import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streak_calculator_flutter/features/habits/domain/extensions/habit_category_extension.dart';

import '../../domain/models/habit_category.dart';
import '../provider/habits_view_provider.dart';

class HabitFilterBar extends ConsumerWidget {
  const HabitFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(habitsViewProvider);
    final notifier = ref.read(habitsViewProvider.notifier);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            label: const Text("All"),
            selected: view.category == null,
            onSelected: (_) => notifier.clearCategory(),
          ),
          const SizedBox(width: 8),
          ...HabitCategory.values.map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category.label),
                selected: view.category == category,
                onSelected: (_) {
                  notifier.setCategory(category);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
