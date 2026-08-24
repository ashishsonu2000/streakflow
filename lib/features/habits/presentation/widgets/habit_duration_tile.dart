import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/habit_form_provider.dart';

class HabitDurationTile extends ConsumerWidget {
  const HabitDurationTile({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final state =
        ref.watch(habitFormProvider).requireValue;

    final notifier =
    ref.read(habitFormProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'Duration',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),

            const SizedBox(height: 4),

            Text(
              'Choose how long this habit should be active.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall,
            ),

            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.play_circle_outline,
              ),
              title: const Text(
                'Start Date',
              ),
              subtitle: Text(
                _formatDate(
                  state.startDate,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () async {
                final selected =
                await showDatePicker(
                  context: context,
                  initialDate: state.startDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );

                if (selected == null) {
                  return;
                }

                notifier.setStartDate(
                  selected,
                );
              },
            ),

            const Divider(),

            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Set End Date',
              ),
              subtitle: Text(
                state.endDate == null
                    ? 'Ongoing habit'
                    : _formatDate(
                  state.endDate!,
                ),
              ),
              value: state.endDate != null,
              onChanged: (enabled) async {
                if (!enabled) {
                  notifier.clearEndDate();
                  return;
                }

                final initialDate =
                    state.endDate ??
                        state.startDate.add(
                          const Duration(
                            days: 30,
                          ),
                        );

                final selected =
                await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: state.startDate,
                  lastDate: DateTime(2100),
                );

                if (selected == null) {
                  return;
                }

                notifier.setEndDate(
                  selected,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}