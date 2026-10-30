import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/presentation/provider/habit_form_provider.dart';
import '../../domain/screen_time_limits.dart';
import '../screen_time_providers.dart';

/// Habit form: turns the habit into a "Digital detox" habit with a
/// daily screen-time limit.
class HabitScreenTimeTile extends ConsumerStatefulWidget {
  const HabitScreenTimeTile({super.key});

  @override
  ConsumerState<HabitScreenTimeTile> createState() =>
      _HabitScreenTimeTileState();
}

class _HabitScreenTimeTileState extends ConsumerState<HabitScreenTimeTile> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();

    // Back from the system "Usage access" screen.
    _lifecycle = AppLifecycleListener(
      onResume: () => ref.invalidate(usageAccessProvider),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(habitFormProvider).value!;
    final notifier = ref.read(habitFormProvider.notifier);
    final limit = state.screenTimeLimitMinutes;

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.phonelink_erase_rounded),
            title: const Text('Screen-time limit'),
            subtitle: Text(
              limit == null
                  ? 'Digital detox: stay under a daily screen-time limit'
                  : 'Under ${ScreenTimeLimits.format(limit)} of screen time a day',
            ),
            value: limit != null,
            onChanged: (enabled) => notifier.setScreenTimeLimit(
              enabled ? ScreenTimeLimits.defaultMinutes : null,
            ),
          ),
          if (limit != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final minutes in ScreenTimeLimits.choices)
                        ChoiceChip(
                          label: Text(ScreenTimeLimits.format(minutes)),
                          selected: minutes == limit,
                          onSelected: (_) =>
                              notifier.setScreenTimeLimit(minutes),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _AccessStatus(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AccessStatus extends ConsumerWidget {
  const _AccessStatus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final service = ref.watch(screenTimeServiceProvider);
    final available = ref.watch(screenTimeAvailableProvider).valueOrNull;
    final granted = ref.watch(usageAccessProvider).valueOrNull;

    Text note(String text) => Text(text, style: theme.textTheme.bodySmall);

    if (available == null || granted == null) return const SizedBox.shrink();

    if (!available) {
      return note(
        'Automatic screen-time alerts need iOS 16 or later. Tap the habit '
        'to check in once your day stayed under the limit, and set a '
        'reminder below as an evening nudge.',
      );
    }

    if (granted) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          note(
            service.isIOS
                ? 'You get a notification with an idea for a break when you '
                    'reach the limit in the apps you chose (and a heads-up at '
                    '80%). Days under the limit are completed automatically '
                    'the next day.'
                : 'You get a notification with an idea for a break when you '
                    'reach the limit (and a heads-up at 80%). Days under the '
                    'limit are completed automatically the next day.',
          ),
          if (service.isIOS) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.apps_rounded),
              label: const Text('Change apps'),
              onPressed: () => setUpScreenTime(ref),
            ),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        note(
          service.isIOS
              ? 'Allow Screen Time access and choose the apps that count '
                  '(choose all categories to count every app). Apple never '
                  'shares your usage with StreakFlow. Without it, tap the '
                  'habit yourself on days you stayed under the limit.'
              : 'To measure screen time, allow StreakFlow "Usage access". It '
                  'is read only on this device and never leaves it. Without '
                  'it, tap the habit yourself on days you stayed under the '
                  'limit.',
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: Icon(
            service.isIOS ? Icons.apps_rounded : Icons.settings_outlined,
          ),
          label: Text(
            service.isIOS ? 'Choose apps' : 'Allow usage access',
          ),
          onPressed: () => setUpScreenTime(ref),
        ),
      ],
    );
  }
}
