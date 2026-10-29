import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/domain/models/habit.dart';
import '../../domain/screen_time_limits.dart';
import '../screen_time_providers.dart';

/// Habit details of a "Digital detox" habit: screen time so far today
/// against the limit (Android with usage access), or how to check in.
class ScreenTimeTodayCard extends ConsumerWidget {
  const ScreenTimeTodayCard({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final limit = habit.screenTimeLimitMinutes;
    if (limit == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final service = ref.watch(screenTimeServiceProvider);

    final granted = service.isSupported &&
        ref.watch(usageAccessProvider).valueOrNull == true;
    final minutes =
        granted ? ref.watch(todayScreenTimeProvider).valueOrNull : null;

    final String body;
    double? progress;

    if (!service.isSupported) {
      body = 'Tap the habit to check in once your day stayed under '
          '${ScreenTimeLimits.format(limit)}.';
    } else if (!granted) {
      body = 'Allow "Usage access" to measure screen time; until then, '
          'check in yourself.';
    } else if (minutes == null) {
      body = 'No screen-time data yet today.';
    } else {
      progress = (minutes / limit).clamp(0.0, 1.0);
      body = minutes >= limit
          ? 'Limit reached: ${ScreenTimeLimits.format(minutes)} of '
              '${ScreenTimeLimits.format(limit)}. Time for a break.'
          : '${ScreenTimeLimits.format(minutes)} of '
              '${ScreenTimeLimits.format(limit)} used today, '
              '${ScreenTimeLimits.format(limit - minutes)} left.';
    }

    final over = minutes != null && minutes >= limit;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.phonelink_erase_rounded, color: colors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Screen time today',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (granted)
                  IconButton(
                    tooltip: 'Refresh',
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: () => ref.invalidate(todayScreenTimeProvider),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (progress != null) ...[
              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
                color: over ? colors.error : colors.primary,
              ),
              const SizedBox(height: 8),
            ],
            Text(body, style: theme.textTheme.bodyMedium),
            if (service.isSupported && !granted) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.settings_outlined),
                label: const Text('Allow usage access'),
                onPressed: service.openUsageAccessSettings,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
