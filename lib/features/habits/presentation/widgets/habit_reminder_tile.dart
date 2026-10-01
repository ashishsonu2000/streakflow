import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entitlements/entitlement_provider.dart';
import '../../../../core/entitlements/premium_config.dart';
import '../../../../core/entitlements/premium_feature.dart';
import '../../../premium/presentation/premium_gate.dart';
import '../provider/habit_form_provider.dart';

class HabitReminderTile extends ConsumerWidget {
  const HabitReminderTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(habitFormProvider.notifier);
    final state = ref.watch(habitFormProvider).value!;

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
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
          if (state.hasReminder) const _AdditionalReminders(),
        ],
      ),
    );
  }
}

/// Extra reminder times for the same habit (StreakFlow Premium).
class _AdditionalReminders extends ConsumerWidget {
  const _AdditionalReminders();

  static const _maxExtra = PremiumConfig.premiumRemindersPerHabit - 1;

  static String _format(int minutesOfDay) =>
      '${(minutesOfDay ~/ 60).toString().padLeft(2, '0')}:'
      '${(minutesOfDay % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final notifier = ref.read(habitFormProvider.notifier);
    final extras = ref.watch(habitFormProvider).value!.additionalReminderMinutes;
    final unlocked = ref
        .watch(featureAccessProvider)
        .canUse(PremiumFeature.multipleReminders);

    Future<void> addReminder() async {
      if (!await PremiumGate.canUse(
        context,
        ref,
        PremiumFeature.multipleReminders,
      )) {
        return;
      }

      if (!context.mounted) return;

      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        helpText: 'Add reminder time',
      );

      if (picked == null) return;

      final added =
          notifier.addAdditionalReminder(picked.hour * 60 + picked.minute);

      if (!added && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('That reminder time is already set.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'More reminder times',
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.workspace_premium_outlined,
                size: 16,
                color: colors.primary,
              ),
            ],
          ),
          if (extras.isNotEmpty && !unlocked)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Paused — extra reminders need StreakFlow Premium.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final minutes in extras)
                InputChip(
                  avatar: const Icon(Icons.alarm_rounded, size: 18),
                  label: Text(_format(minutes)),
                  onDeleted: () => notifier.removeAdditionalReminder(minutes),
                  deleteButtonTooltipMessage: 'Remove reminder',
                ),
              if (extras.length < _maxExtra)
                ActionChip(
                  avatar: Icon(
                    unlocked
                        ? Icons.add_alarm_rounded
                        : Icons.workspace_premium_outlined,
                    size: 18,
                  ),
                  label: const Text('Add reminder time'),
                  onPressed: addReminder,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
