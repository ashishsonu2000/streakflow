import 'package:flutter/material.dart';

import '../../domain/models/calendar_view_model.dart';

class CalendarMonthSummary extends StatelessWidget {
  const CalendarMonthSummary({
    super.key,
    required this.calendar,
  });

  final CalendarViewModel calendar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final monthDays = calendar.days
        .where(
          (day) => day.isCurrentMonth,
    )
        .toList();

    final completedDays = monthDays
        .where(
          (day) => day.hasActivity,
    )
        .length;

    final completedHabits = monthDays.fold<int>(
      0,
          (sum, day) => sum + day.completedHabits,
    );

    final totalPossibleCompletions =
    monthDays.fold<int>(
      0,
          (sum, day) => sum + day.totalHabits,
    );

    final completionRate =
    totalPossibleCompletions == 0
        ? 0.0
        : completedHabits /
        totalPossibleCompletions;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              icon: Icons.check_circle_outline_rounded,
              value: '$completedDays',
              label: 'Active days',
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: _SummaryCard(
              icon: Icons.task_alt_rounded,
              value:
              '$completedHabits / '
                  '$totalPossibleCompletions',
              label: 'Completions',
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: _SummaryCard(
              icon: Icons.insights_rounded,
              value:
              '${(completionRate * 100).round()}%',
              label: 'Completion',
            ),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// SUMMARY CARD
// ===================================================================

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: scheme.primary,
          ),

          const SizedBox(
            height: 6,
          ),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(
            height: 2,
          ),

          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}