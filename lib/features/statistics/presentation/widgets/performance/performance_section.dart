import 'package:flutter/material.dart';

import '../../../../../../shared/ui/cards/app_section_card.dart';

import '../../../domain/models/habit_performance.dart';

import 'performance_tile.dart';

class PerformanceSection extends StatelessWidget {
  const PerformanceSection({
    super.key,
    required this.performance,
  });

  final List<HabitPerformance> performance;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: 'Habit Performance',
      child: performance.isEmpty
          ? const _EmptyPerformance()
          : Column(
        children: List.generate(
          performance.length,
              (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index ==
                    performance.length - 1
                    ? 0
                    : 12,
              ),
              child: PerformanceTile(
                performance:
                performance[index],
              ),
            );
          },
        ),
      ),
    );
  }
}

// =====================================================================
// EMPTY STATE
// =====================================================================

class _EmptyPerformance
    extends StatelessWidget {
  const _EmptyPerformance();

  @override
  Widget build(BuildContext context) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 24,
      ),
      child: Column(
        children: [
          // ===========================================================
          // ICON
          // ===========================================================

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.primary
                  .withValues(
                alpha:
                theme.brightness ==
                    Brightness.dark
                    ? 0.16
                    : 0.08,
              ),
              shape:
              BoxShape.circle,
            ),
            child: Icon(
              Icons.insights_rounded,
              size: 24,
              color:
              colors.primary,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          // ===========================================================
          // TITLE
          // ===========================================================

          Text(
            'No performance data yet',
            style: theme
                .textTheme
                .titleSmall
                ?.copyWith(
              color:
              colors.onSurface,
              fontSize: 14,
              fontWeight:
              FontWeight.w600,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          // ===========================================================
          // DESCRIPTION
          // ===========================================================

          Text(
            'Complete some habits to see your performance.',
            textAlign:
            TextAlign.center,
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color:
              colors.onSurfaceVariant,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}