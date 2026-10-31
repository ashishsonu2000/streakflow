import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/domain/models/habit.dart';
import '../../domain/screen_time_limits.dart';
import '../screen_time_providers.dart';
import 'screen_time_diagnostics_sheet.dart';

/// Habit details of a "Digital detox" habit: screen time so far today
/// against the limit (Android with usage access), whether limit alerts
/// are on (iPhone, which doesn't share minutes), or how to check in.
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

    final available = ref.watch(screenTimeAvailableProvider).valueOrNull;
    final granted =
        available == true && ref.watch(usageAccessProvider).valueOrNull == true;
    final showMinutes = granted && !service.isIOS;
    final minutes =
        showMinutes ? ref.watch(todayScreenTimeProvider).valueOrNull : null;

    final String body;
    double? progress;

    if (available != true) {
      body = 'Tap the habit to check in once your day stayed under '
          '${ScreenTimeLimits.format(limit)}.';
    } else if (!granted) {
      body = service.isIOS
          ? 'Allow Screen Time access and choose the apps that count; '
              'until then, check in yourself.'
          : 'Allow "Usage access" to measure screen time; until then, '
              'check in yourself.';
    } else if (service.isIOS) {
      body = 'Limit alerts are on for the apps you chose. Apple does not '
          'share screen-time minutes with apps, so the day is completed '
          'automatically tomorrow if you stay under '
          '${ScreenTimeLimits.format(limit)}.';
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
                  child: _DiagnosticsTitle(
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (showMinutes)
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
            if (available == true && (!granted || service.isIOS)) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: Icon(
                  service.isIOS ? Icons.apps_rounded : Icons.settings_outlined,
                ),
                label: Text(
                  !service.isIOS
                      ? 'Allow usage access'
                      : granted
                          ? 'Change apps'
                          : 'Choose apps',
                ),
                onPressed: () => setUpScreenTime(ref),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// "Screen time today"; 5 quick taps open the diagnostics panel.
class _DiagnosticsTitle extends StatefulWidget {
  const _DiagnosticsTitle({this.style});

  final TextStyle? style;

  @override
  State<_DiagnosticsTitle> createState() => _DiagnosticsTitleState();
}

class _DiagnosticsTitleState extends State<_DiagnosticsTitle> {
  int _taps = 0;
  DateTime _lastTap = DateTime(2000);

  void _onTap() {
    final now = DateTime.now();
    _taps =
        now.difference(_lastTap) < const Duration(seconds: 2) ? _taps + 1 : 1;
    _lastTap = now;

    if (_taps >= 5) {
      _taps = 0;
      ScreenTimeDiagnosticsSheet.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: Text('Screen time today', style: widget.style),
    );
  }
}
