import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/habit_category.dart';
import '../provider/habit_form_provider.dart';

class HabitCategorySelector extends ConsumerWidget {
  const HabitCategorySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitFormProvider).value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Category",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: HabitCategory.values.map((category) {
            return FilterChip(
              selected: state.category == category,
              label: Text(category.name),
              onSelected: (_) {
                ref.read(habitFormProvider.notifier).setCategory(category);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
