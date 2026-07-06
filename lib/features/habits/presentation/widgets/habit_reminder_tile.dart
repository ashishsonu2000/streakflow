import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/habit_form_provider.dart';

class HabitReminderTile extends ConsumerWidget {
  const HabitReminderTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(habitFormProvider.notifier);
    final state = ref.watch(habitFormProvider).value!;

    return Card(
      child: SwitchListTile(
        title: const Text("Daily Reminder"),
        subtitle: Text(
          state.hasReminder
              ? "${state.reminderHour!.toString().padLeft(2, '0')}:${state.reminderMinute!.toString().padLeft(2, '0')}"
              : "No reminder selected",
        ),
        value: state.reminderEnabled,
        onChanged: (enabled) async {
          notifier.setReminderEnabled(enabled);

          if (!enabled) return;

          final now = TimeOfDay.now();

          final picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
              hour: state.reminderHour ?? now.hour,
              minute: state.reminderMinute ?? now.minute,
            ),
          );

          if (picked == null) return;

          notifier.setReminderTime(
            hour: picked.hour,
            minute: picked.minute,
          );
        },
      ),
    );
  }
}
