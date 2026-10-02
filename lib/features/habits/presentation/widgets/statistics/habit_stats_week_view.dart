import 'package:flutter/material.dart';

import '../../../domain/models/habit_statistics.dart';
import 'habit_stats_formatters.dart';
import 'habit_stats_period_summary_card.dart';
import 'habit_stats_section_card.dart';

// =====================================================================
// WEEK
// =====================================================================

class HabitStatsWeekView extends StatelessWidget {
  const HabitStatsWeekView({
    super.key,
    required this.statistics,
  });

  final HabitStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final scheduled = statistics
        .weeklyProgress
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
          title: 'Weekly Progress',
          completed: completed,
          total: scheduled.length,
          icon:
          Icons.calendar_view_week_rounded,
        ),

        const SizedBox(height: 14),

        _WeeklyProgressCard(
          statistics: statistics,
        ),
      ],
    );
  }
}

// =====================================================================
// WEEKLY PROGRESS
// =====================================================================

class _WeeklyProgressCard
    extends StatelessWidget {
  const _WeeklyProgressCard({
    required this.statistics,
  });

  final HabitStatistics statistics;

  @override
  Widget build(BuildContext context) {
    return HabitStatsSectionCard(
      title: 'This Week',
      children: [
        ...statistics.weeklyProgress.map(
              (day) {
            final theme =
            Theme.of(context);
            final colors =
                theme.colorScheme;

            return Padding(
              padding:
              const EdgeInsets.only(
                bottom: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      formatHabitStatsDate(day.date),
                      style: theme
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        color:
                        colors.onSurface,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),
                  ),

                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: day.completed
                          ? Colors.green
                          .withValues(
                        alpha: 0.10,
                      )
                          : colors
                          .surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      day.completed
                          ? Icons
                          .check_circle_rounded
                          : Icons
                          .radio_button_unchecked_rounded,
                      size: 20,
                      color: day.completed
                          ? Colors.green
                          : colors
                          .onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
