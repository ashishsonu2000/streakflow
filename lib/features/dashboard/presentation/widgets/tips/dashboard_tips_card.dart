import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/dashboard_tips_provider.dart';

/// Dashboard card with one first-use tip at a time.
/// Shown by [dashboardTipsProvider].
class DashboardTipsCard extends ConsumerWidget {
  const DashboardTipsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(dashboardTipsProvider);
    if (index == null) {
      return const SizedBox.shrink();
    }

    final notifier = ref.read(dashboardTipsProvider.notifier);
    final isLast = index == dashboardTips.length - 1;

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 4, 8),
        decoration: BoxDecoration(
          color: colors.secondaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: colors.onSecondaryContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tip ${index + 1} of ${dashboardTips.length}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colors.onSecondaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dashboardTips[index],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Hide tips',
                  icon: const Icon(Icons.close_rounded),
                  color: colors.onSecondaryContainer,
                  onPressed: notifier.dismiss,
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilledButton.tonal(
                  onPressed: notifier.next,
                  child: Text(isLast ? 'Got it' : 'Next tip'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
