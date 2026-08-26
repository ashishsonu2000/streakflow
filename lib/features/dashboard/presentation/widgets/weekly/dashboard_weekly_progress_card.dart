import 'package:flutter/material.dart';

import '../../../../../../shared/ui/cards/app_card.dart';
import '../../../../../../core/ui/design/app_spacing.dart';
import '../../../../../../core/ui/section/app_section_header.dart';

import '../../../domain/models/weekly_progress_view_model.dart';
import '../../../../statistics/domain/models/weekly_trend.dart';

class DashboardWeeklyProgressCard extends StatelessWidget {
  const DashboardWeeklyProgressCard({
    super.key,
    required this.weekly,
  });

  final WeeklyProgressViewModel weekly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final trendColor = switch (weekly.trend) {
      WeeklyTrend.improving => const Color(0xFF059669),
      WeeklyTrend.declining => const Color(0xFFDC2626),
      WeeklyTrend.stable => const Color(0xFF2563EB),
    };

    final trendBackground = switch (weekly.trend) {
      WeeklyTrend.improving => const Color(0xFFECFDF5),
      WeeklyTrend.declining => const Color(0xFFFEF2F2),
      WeeklyTrend.stable => const Color(0xFFEFF6FF),
    };

    final trendIcon = switch (weekly.trend) {
      WeeklyTrend.improving => Icons.trending_up_rounded,
      WeeklyTrend.declining => Icons.trending_down_rounded,
      WeeklyTrend.stable => Icons.trending_flat_rounded,
    };

    final progress = weekly.completionRate.clamp(
      0.0,
      1.0,
    );

    return AppCard(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),

          // =========================================================
          // CARD BACKGROUND
          // =========================================================

          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC),
              Color(0xFFEEF4FA),
            ],
          ),

          // =========================================================
          // NAVY / BLUE BORDER
          // =========================================================

          border: Border.all(
            color: const Color(0xFF2563EB).withValues(
              alpha: 0.28,
            ),
            width: 1.2,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // =====================================================
              // HEADER
              // =====================================================

              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius:
                      BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.calendar_view_week_rounded,
                      size: 21,
                      color: Color(0xFF2563EB),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: AppSectionHeader(
                      title: 'Weekly Progress',
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: AppSpacing.cardSpacing,
              ),

              // =====================================================
              // PROGRESS HEADER
              // =====================================================

              Row(
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [
                  const Expanded(
                    child: Text(
                      'This week',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  Text(
                    '${(progress * 100).round()}%',
                    style: theme
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      color: const Color(0xFF0F172A),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // =====================================================
              // PROGRESS BAR
              // =====================================================

              SizedBox(
                height: 9,
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(999),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          color: const Color(
                            0xFFDCE7F5,
                          ),
                        ),
                      ),

                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          decoration:
                          const BoxDecoration(
                            gradient:
                            LinearGradient(
                              begin: Alignment
                                  .centerLeft,
                              end: Alignment
                                  .centerRight,
                              colors: [
                                Color(0xFF1D4ED8),
                                Color(0xFF3B82F6),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: AppSpacing.sectionSpacing,
              ),

              // =====================================================
              // MAIN METRICS
              // =====================================================

              Row(
                children: [
                  Expanded(
                    child: _Metric(
                      icon:
                      Icons.check_circle_rounded,
                      iconColor:
                      const Color(0xFF2563EB),
                      label: 'Completed',
                      value:
                      '${weekly.completed}/${weekly.target}',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _Metric(
                      icon: Icons.stars_rounded,
                      iconColor:
                      const Color(0xFFD97706),
                      label: 'XP',
                      value:
                      '${weekly.totalXP}',
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: AppSpacing.cardSpacing,
              ),

              // =====================================================
              // SECONDARY METRICS
              // =====================================================

              Row(
                children: [
                  Expanded(
                    child: _Metric(
                      icon: Icons
                          .local_fire_department_rounded,
                      iconColor:
                      const Color(0xFFEA580C),
                      label: 'Active Days',
                      value:
                      '${weekly.activeDays}/7',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _TrendMetric(
                      icon: trendIcon,
                      color: trendColor,
                      backgroundColor:
                      trendBackground,
                      percentage:
                      weekly.changePercentage,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// METRIC
// =====================================================================

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1F8),
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD9E2EC),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconColor.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 17,
              color: iconColor,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: const Color(
                      0xFF64748B,
                    ),
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    color: const Color(
                      0xFF0F172A,
                    ),
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// TREND
// =====================================================================

class _TrendMetric extends StatelessWidget {
  const _TrendMetric({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.percentage,
  });

  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(
            alpha: 0.10,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trend',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  '${percentage >= 0 ? '+' : ''}'
                      '${percentage.toStringAsFixed(1)}%',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}