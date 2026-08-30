import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/enums/habit_frequency.dart';
import '../provider/habit_form_provider.dart';

class HabitTargetSelector extends ConsumerWidget {
  const HabitTargetSelector({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final asyncState =
    ref.watch(habitFormProvider);

    return asyncState.when(
      loading: () => const SizedBox.shrink(),

      error: (error, stackTrace) =>
      const SizedBox.shrink(),

      data: (state) {
        final notifier =
        ref.read(
          habitFormProvider.notifier,
        );

        return Card(
          child: Padding(
            padding:
            const EdgeInsets.all(16),
            child: Row(
              children: [
                // =================================================
                // Target Label
                // =================================================

                Expanded(
                  child: Text(
                    _targetLabel(
                      state.frequency,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                ),

                // =================================================
                // Decrease
                // =================================================

                IconButton(
                  onPressed:
                  state.targetPerDay > 1
                      ? notifier
                      .decrementTarget
                      : null,
                  tooltip:
                  'Decrease target',
                  icon: const Icon(
                    Icons
                        .remove_circle_outline,
                  ),
                ),

                // =================================================
                // Value
                // =================================================

                Text(
                  '${state.targetPerDay}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                // =================================================
                // Increase
                // =================================================

                IconButton(
                  onPressed:
                  state.targetPerDay < 100
                      ? notifier
                      .incrementTarget
                      : null,
                  tooltip:
                  'Increase target',
                  icon: const Icon(
                    Icons
                        .add_circle_outline,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===========================================================
  // Target Label
  // ===========================================================

  String _targetLabel(
      HabitFrequency frequency,
      ) {
    switch (frequency) {
      case HabitFrequency.daily:
        return 'Daily Target';

      case HabitFrequency.weekly:
        return 'Target per occurrence';

      case HabitFrequency.monthly:
        return 'Target per occurrence';

      case HabitFrequency.custom:
        return 'Target';
    }
  }
}