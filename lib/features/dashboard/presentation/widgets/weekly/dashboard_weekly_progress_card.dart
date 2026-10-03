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
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // =============================================================
    // PROGRESS
    // =============================================================

    final progress = weekly.completionRate.clamp(
      0.0,
      1.0,
    );

    // =============================================================
    // TREND
    // =============================================================

    final trendColor = switch (weekly.trend) {
      WeeklyTrend.improving => const Color(0xFF10B981),
      WeeklyTrend.declining => const Color(0xFFEF4444),
      WeeklyTrend.stable => colors.primary,
    };

    final trendBackground = switch (weekly.trend) {
      WeeklyTrend.improving => isDark
          ? const Color(0xFF123B2A)
          : const Color(0xFFECFDF5),
      WeeklyTrend.declining => isDark
          ? const Color(0xFF451A1A)
          : const Color(0xFFFEF2F2),
      WeeklyTrend.stable => isDark
          ? colors.primaryContainer
          : const Color(0xFFEFF6FF),
    };

    final trendIcon = switch (weekly.trend) {
      WeeklyTrend.improving => Icons.trending_up_rounded,
      WeeklyTrend.declining => Icons.trending_down_rounded,
      WeeklyTrend.stable => Icons.trending_flat_rounded,
    };

    return AppCard(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),

          // =========================================================
          // DARK / LIGHT THEME
          // =========================================================

          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
              colors.surfaceContainerLow,
              colors.surfaceContainerHighest,
            ]
                : [
              const Color(0xFFF8FAFC),
              const Color(0xFFEEF4FA),
            ],
          ),

          border: Border.all(
            color: colors.outlineVariant,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.22 : 0.04,
              ),
              blurRadius: isDark ? 18 : 12,
              offset: const Offset(0, 5),
            ),
          ],
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
                      color: isDark
                          ? colors.primaryContainer
                          : const Color(0xFFEFF6FF),
                      borderRadius:
                      BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.calendar_view_week_rounded,
                      size: 21,
                      color: colors.primary,
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
              // PROGRESS LABEL
              // =====================================================

              Row(
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      'This week',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  Text(
                    '${(progress * 100).round()}%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // =====================================================
              // PROGRESS BAR
              // =====================================================

              ClipRRect(
                borderRadius:
                BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor:
                  colors.surfaceContainerHighest,
                  valueColor:
                  AlwaysStoppedAnimation<Color>(
                    colors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // =====================================================
              // METRICS
              // =====================================================

              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      icon:
                      Icons.check_circle_rounded,
                      iconColor:
                      colors.primary,
                      label: 'Completed',
                      value:
                      '${weekly.completed}/${weekly.target}',
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _MetricTile(
                      icon:
                      Icons.bolt_rounded,
                      iconColor:
                      const Color(0xFFF59E0B),
                      label: 'XP',
                      value:
                      '${weekly.xp}',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      icon:
                      Icons.local_fire_department_rounded,
                      iconColor:
                      const Color(0xFFF97316),
                      label: 'Active Days',
                      value:
                      '${weekly.activeDays}/7',
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _TrendTile(
                      icon: trendIcon,
                      color: trendColor,
                      background:
                      trendBackground,
                      value:
                      _formatTrend(
                        weekly.changePercentage,
                      ),
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

  // ===============================================================
  // FORMAT TREND
  // ===============================================================

  String _formatTrend(double value) {
    if (value > 0) {
      return '+${value.toStringAsFixed(1)}%';
    }

    if (value < 0) {
      return '${value.toStringAsFixed(1)}%';
    }

    return '0.0%';
  }
}

// ===================================================================
// METRIC TILE
// ===================================================================

class _MetricTile extends StatelessWidget {
  const _MetricTile({
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
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      constraints: const BoxConstraints(
        minHeight: 62,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? colors.surfaceContainerHighest
            : colors.surfaceContainerLow,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withValues(
                alpha: isDark ? 0.18 : 0.10,
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
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color:
                    colors.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colors.onSurface,
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

// ===================================================================
// TREND TILE
// ===================================================================

class _TrendTile extends StatelessWidget {
  const _TrendTile({
    required this.icon,
    required this.color,
    required this.background,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      constraints: const BoxConstraints(
        minHeight: 62,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(
            alpha: 0.28,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(
                alpha: 0.15,
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
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Trend',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color:
                    colors.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: color,
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