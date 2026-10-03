import 'package:flutter/material.dart';

import '../../../domain/models/habit_statistics.dart';
import 'habit_stats_formatters.dart';
import 'habit_stats_progress_row.dart';
import 'habit_stats_section_card.dart';

// =====================================================================
// OVERVIEW
// =====================================================================

class HabitStatsOverviewView extends StatelessWidget {
  const HabitStatsOverviewView({
    super.key,
    required this.statistics,
  });

  final HabitStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.stretch,
      children: [
        // =========================================================
        // TOP METRICS
        // =========================================================

        Row(
          children: [
            Expanded(
              child: _OverviewMetricCard(
                icon:
                Icons.local_fire_department_rounded,
                title: 'Current Streak',
                value:
                '${statistics.currentStreak}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OverviewMetricCard(
                icon:
                Icons.emoji_events_rounded,
                title: 'Best Streak',
                value:
                '${statistics.bestStreak}',
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _OverviewMetricCard(
                icon:
                Icons.check_circle_outline_rounded,
                title: 'Completed',
                value:
                '${statistics.totalCompleted}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OverviewMetricCard(
                icon:
                Icons.cancel_outlined,
                title: 'Missed',
                value:
                '${statistics.totalMissed}',
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _OverviewMetricCard(
                icon:
                Icons.calendar_month_rounded,
                title: 'Tracked Days',
                value:
                '${statistics.totalTrackedDays}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OverviewMetricCard(
                icon:
                Icons.event_available_rounded,
                title: 'Active Days',
                value:
                '${statistics.activeDays}',
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        _OverviewMetricCard(
          icon: Icons.bolt_rounded,
          title: 'Total XP',
          value: '${statistics.totalXP}',
        ),

        const SizedBox(height: 16),

        // =========================================================
        // PERFORMANCE
        // =========================================================

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
              theme.brightness ==
                  Brightness.dark
                  ? [
                colors.surfaceContainer,
                colors.surfaceContainerLow,
              ]
                  : [
                colors.surface,
                const Color(0xFFF7FAFF),
              ],
            ),
            borderRadius:
            BorderRadius.circular(20),
            border: Border.all(
              color: colors.outlineVariant
                  .withValues(
                alpha:
                theme.brightness ==
                    Brightness.dark
                    ? 0.70
                    : 0.65,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha:
                  theme.brightness ==
                      Brightness.dark
                      ? 0.15
                      : 0.025,
                ),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Performance',
                style: theme
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight:
                  FontWeight.w800,
                  color: colors.onSurface,
                ),
              ),

              const SizedBox(height: 20),

              HabitStatsProgressRow(
                label: 'Completion Rate',
                value:
                statistics.completionRate,
              ),

              const SizedBox(height: 20),

              HabitStatsProgressRow(
                label: 'Success Rate',
                value:
                statistics.successRate,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _OverviewInfo(
                      icon:
                      Icons.trending_up_rounded,
                      title: 'Average / Week',
                      value: statistics
                          .averagePerWeek
                          .toStringAsFixed(1),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _OverviewInfo(
                      icon:
                      Icons.timelapse_rounded,
                      title: 'Longest Gap',
                      value:
                      '${statistics.longestGap} days',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // =========================================================
        // WEEKLY SNAPSHOT
        // =========================================================

        HabitStatsSectionCard(
          title: 'This Week',
          children: [
            ...statistics.weeklyProgress.map(
                  (day) {
                final completed =
                    day.completed;

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
                          ),
                        ),
                      ),
                      Icon(
                        completed
                            ? Icons
                            .check_circle_rounded
                            : Icons
                            .radio_button_unchecked_rounded,
                        size: 22,
                        color: completed
                            ? Colors.green
                            : colors
                            .onSurfaceVariant,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

// =====================================================================
// OVERVIEW METRIC CARD
// =====================================================================

class _OverviewMetricCard
    extends StatelessWidget {
  const _OverviewMetricCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark =
        theme.brightness == Brightness.dark;

    return Container(
      height: 112,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
            colors.surfaceContainerHighest,
            colors.surfaceContainer,
          ]
              : [
            colors.surface,
            const Color(0xFFF7FAFF),
          ],
        ),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: colors.outlineVariant
              .withValues(
            alpha: isDark ? 0.70 : 0.65,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.14 : 0.025,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colors.primary.withValues(
                alpha: isDark ? 0.16 : 0.10,
              ),
              borderRadius:
              BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 19,
              color: colors.primary,
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: theme
                .textTheme
                .titleLarge
                ?.copyWith(
              color: colors.onSurface,
              fontWeight:
              FontWeight.w900,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            title,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color:
              colors.onSurfaceVariant,
              fontSize: 11,
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// OVERVIEW INFO
// =====================================================================

class _OverviewInfo extends StatelessWidget {
  const _OverviewInfo({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: colors.primary.withValues(
              alpha: 0.10,
            ),
            borderRadius:
            BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: colors.primary,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight:
                  FontWeight.w800,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
                style: theme
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  color:
                  colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
