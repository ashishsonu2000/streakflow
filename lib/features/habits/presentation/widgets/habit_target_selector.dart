import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/habit_form_provider.dart';

class HabitTargetSelector extends ConsumerWidget {
  const HabitTargetSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitFormProvider).value!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Daily Target",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              onPressed: ref.read(habitFormProvider.notifier).decrementTarget,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(
              "${state.targetPerDay}",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            IconButton(
              onPressed: ref.read(habitFormProvider.notifier).incrementTarget,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}
