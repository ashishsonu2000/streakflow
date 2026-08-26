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
    final completion =
    (weekly.completionRate * 100)
        .toStringAsFixed(0);

    final trendColor = switch (weekly.trend) {
      WeeklyTrend.improving =>
      const Color(0xFF16A34A),
      WeeklyTrend.declining =>
      const Color(0xFFDC2626),
      WeeklyTrend.stable =>
      const Color(0xFF2563EB),
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
                  valueColor:
                  const Color(0xFF0F172A),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Completed',
                  value:
                  '${weekly.totalCompleted}/${weekly.totalTarget}',
                  valueColor:
                  const Color(0xFF0F172A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

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
                  const Color(0xFFD97706),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Duration',
                  value:
                  '${weekly.totalDurationMinutes} min',
                  valueColor:
                  const Color(0xFF0F172A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

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
                  valueColor:
                  const Color(0xFF0F172A),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Trend',
                  value:
                  '${weekly.weeklyChangePercentage.toStringAsFixed(1)}%',
                  valueColor: trendColor,
                  trailing: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: trendColor.withValues(
                        alpha: 0.10,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      trendIcon,
                      color: trendColor,
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

          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 14,
            ),
            child: Divider(
              height: 1,
              color: Color(0xFFD7E3F1),
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
                  const Color(0xFF16A34A),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Needs Attention',
                  value: _weekday(
                    weekly.worstDay.date,
                  ),
                  valueColor:
                  const Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _weekday(DateTime date) {
    const names = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return names[date.weekday - 1];
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 5),

          Row(
            children: [
              Flexible(
                child: Text(
                  value,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    color: valueColor ??
                        const Color(
                          0xFF0F172A,
                        ),
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w700,
                    height: 1.15,
                  ),
                ),
              ),

              if (trailing != null) ...[
                const SizedBox(width: 6),
                trailing!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}