import 'package:flutter/material.dart';

import '../../../domain/models/habit_statistics.dart';
import 'habit_stats_formatters.dart';
import 'habit_stats_period_summary_card.dart';
import 'habit_stats_progress_row.dart';
import 'habit_stats_section_card.dart';

// =====================================================================
// YEAR
// =====================================================================

class HabitStatsYearView extends StatelessWidget {
  const HabitStatsYearView({
    super.key,
    required this.statistics,
  });

  final HabitStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final scheduled = statistics
        .yearlyProgress
        .where(
          (day) => day.isWithinHabitRange,
    )
        .toList();

    final completed = scheduled
        .where(
          (day) => day.completed,
    )
        .length;

    return Column(
      children: [
        HabitStatsPeriodSummaryCard(
          title: 'Yearly Progress',
          completed: completed,
          total: scheduled.length,
          icon:
          Icons.calendar_today_rounded,
        ),

        const SizedBox(height: 14),

        _YearlyProgressCard(
          statistics: statistics,
        ),
      ],
    );
  }
}

// =====================================================================
// YEARLY PROGRESS
// =====================================================================

class _YearlyProgressCard
    extends StatelessWidget {
  const _YearlyProgressCard({
    required this.statistics,
  });

  final HabitStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final days =
        statistics.yearlyProgress;

    return HabitStatsSectionCard(
      title: 'Year',
      children: [
        HabitStatsProgressRow(
          label: 'Completed Days',
          value: habitStatsPercentage(
            days
                .where(
                  (day) => day.completed,
            )
                .length,
            days
                .where(
                  (day) =>
              day.isWithinHabitRange,
            )
                .length,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          '${days.length} calendar days',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
