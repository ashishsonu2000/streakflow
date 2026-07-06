import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/entities/habit_frequency.dart';
import '../provider/habit_form_provider.dart';

class HabitFrequencySelector extends ConsumerWidget {
  const HabitFrequencySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitFormProvider).value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Frequency",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SegmentedButton<HabitFrequency>(
          segments: HabitFrequency.values
              .map(
                (frequency) => ButtonSegment(
                  value: frequency,
                  label: Text(frequency.name),
                ),
              )
              .toList(),
          selected: {state.frequency},
          onSelectionChanged: (selection) {
            ref.read(habitFormProvider.notifier).setFrequency(selection.first);
          },
        ),
      ],
    );
  }
}
