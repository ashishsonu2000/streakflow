import 'package:flutter/material.dart';

import '../../../../../../shared/ui/cards/app_section_card.dart';

import '../../../domain/models/weekly_statistics.dart';
import '../../../domain/models/weekly_trend.dart';

class WeeklySummaryCard extends StatelessWidget {
  const WeeklySummaryCard({
    super.key,
    required this.weekly,
  });

  final WeeklyStatistics weekly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final completion =
    (weekly.completionRate * 100)
        .toStringAsFixed(0);

    final trendColor = switch (weekly.trend) {
      WeeklyTrend.improving =>
      const Color(0xFF22C55E),
      WeeklyTrend.declining =>
      const Color(0xFFEF4444),
      WeeklyTrend.stable =>
      const Color(0xFF3B82F6),
    };

    final trendIcon = switch (weekly.trend) {
      WeeklyTrend.improving =>
      Icons.trending_up_rounded,
      WeeklyTrend.declining =>
      Icons.trending_down_rounded,
      WeeklyTrend.stable =>
      Icons.trending_flat_rounded,
    };

    return AppSectionCard(
      title: 'This Week',
      child: Column(
        children: [
          // =========================================================
          // COMPLETION / COMPLETED
          // =========================================================

          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Completion',
                  value: '$completion%',
                ),
              ),

              Expanded(
                child: _Metric(
                  label: 'Completed',
                  value:
                  '${weekly.totalCompleted}/${weekly.totalTarget}',
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 16,
          ),

          // =========================================================
          // XP / DURATION
          // =========================================================

          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'XP',
                  value: '${weekly.totalXP}',
                  valueColor:
                  const Color(0xFFF59E0B),
                ),
              ),

              Expanded(
                child: _Metric(
                  label: 'Duration',
                  value:
                  '${weekly.totalDurationMinutes} min',
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 16,
          ),

          // =========================================================
          // ACTIVE DAYS / TREND
          // =========================================================

          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Active Days',
                  value:
                  '${weekly.activeDays}/7',
                ),
              ),

              Expanded(
                child: _Metric(
                  label: 'Trend',
                  value:
                  '${weekly.weeklyChangePercentage.toStringAsFixed(1)}%',
                  valueColor:
                  trendColor,
                  trailing:
                  Container(
                    width: 28,
                    height: 28,
                    decoration:
                    BoxDecoration(
                      color:
                      trendColor.withValues(
                        alpha:
                        theme.brightness ==
                            Brightness.dark
                            ? 0.16
                            : 0.10,
                      ),
                      shape:
                      BoxShape.circle,
                    ),
                    child: Icon(
                      trendIcon,
                      color:
                      trendColor,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // =========================================================
          // DIVIDER
          // =========================================================

          Padding(
            padding:
            const EdgeInsets.symmetric(
              vertical: 14,
            ),
            child: Divider(
              height: 1,
              color:
              colors.outlineVariant,
            ),
          ),

          // =========================================================
          // BEST / NEEDS ATTENTION
          // =========================================================

          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Best Day',
                  value: _weekday(
                    weekly.bestDay.date,
                  ),
                  valueColor:
                  const Color(0xFF22C55E),
                ),
              ),

              Expanded(
                child: _Metric(
                  label: 'Needs Attention',
                  value: _weekday(
                    weekly.worstDay.date,
                  ),
                  valueColor:
                  const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _weekday(
      DateTime date,
      ) {
    const names = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return names[
    date.weekday - 1];
  }
}

// ===================================================================
// METRIC
// ===================================================================

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.trailing,
    this.valueColor,
  });

  final String label;
  final String value;
  final Widget? trailing;
  final Color? valueColor;

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // =========================================================
          // LABEL
          // =========================================================

          Text(
            label,

            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color:
              colors.onSurfaceVariant,
              fontSize: 12,
              fontWeight:
              FontWeight.w500,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          // =========================================================
          // VALUE
          // =========================================================

          Row(
            children: [
              Flexible(
                child: Text(
                  value,

                  overflow:
                  TextOverflow.ellipsis,

                  style: theme
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                    // -------------------------------------------------
                    // IMPORTANT:
                    // Never use the old #0F172A here in dark mode.
                    // -------------------------------------------------

                    color:
                    valueColor ??
                        colors.onSurface,

                    fontSize: 15,
                    fontWeight:
                    FontWeight.w700,
                    height: 1.15,
                  ),
                ),
              ),

              if (trailing != null) ...[
                const SizedBox(
                  width: 6,
                ),
                trailing!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}