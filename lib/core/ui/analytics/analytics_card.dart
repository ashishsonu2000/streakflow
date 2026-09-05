import 'package:flutter/material.dart';

import '../../../../../shared/ui/cards/app_card.dart';

import 'analytics_card_model.dart';
import 'analytics_metric_type.dart';

class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({
    super.key,
    required this.metric,
  });

  final AnalyticsCardModel metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final accent = _color(metric.type);
    final icon = _icon(metric.type);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),

          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
              colors.surfaceContainerLow,
              colors.surfaceContainer,
            ]
                : const [
              Colors.white,
              Color(0xFFF7FAFF),
            ],
          ),

          border: Border.all(
            color: isDark
                ? colors.outlineVariant.withValues(
              alpha: 0.70,
            )
                : const Color(0xFFD9E2EC),
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.18 : 0.035,
              ),
              blurRadius: isDark ? 12 : 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Stack(
          children: [
            // =========================================================
            // TOP ACCENT
            // =========================================================

            Positioned(
              top: 0,
              left: 14,
              right: 14,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(6),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      accent.withValues(alpha: 0.95),
                      accent.withValues(alpha: 0.20),
                    ],
                  ),
                ),
              ),
            ),

            // =========================================================
            // CONTENT
            // =========================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                14,
                10,
                14,
                9,
              ),

              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,

                children: [
                  // ===================================================
                  // ICON
                  // ===================================================

                  Container(
                    width: 38,
                    height: 38,

                    decoration: BoxDecoration(
                      color: accent.withValues(
                        alpha: isDark ? 0.16 : 0.10,
                      ),

                      shape: BoxShape.circle,

                      border: Border.all(
                        color: accent.withValues(
                          alpha: isDark ? 0.24 : 0.10,
                        ),
                      ),
                    ),

                    child: Icon(
                      icon,
                      color: accent,
                      size: 19,
                    ),
                  ),

                  // ===================================================
                  // MORE SPACE BETWEEN ICON AND TEXT
                  // ===================================================

                  const SizedBox(width: 16),

                  // ===================================================
                  // METRIC CONTENT
                  // ===================================================

                  Expanded(
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
                        Text(
                          metric.title,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,

                          style: theme
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                            color:
                            colors.onSurface,
                            fontWeight:
                            FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          metric.value,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,

                          style: theme
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                            color:
                            colors.onSurface,
                            fontWeight:
                            FontWeight.w800,
                            fontSize: 21,
                            height: 1.05,
                            letterSpacing: -0.4,
                          ),
                        ),

                        if (metric.subtitle != null)
                          Text(
                            metric.subtitle!,
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
                              height: 1.1,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // ===================================================
                  // TREND
                  // ===================================================

                  if (metric.trend != null)
                    const SizedBox(width: 6),

                  if (metric.trend != null)
                    _TrendBadge(
                      metric: metric,
                      isDark: isDark,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // ICON
  // ===============================================================

  IconData _icon(
      AnalyticsMetricType type,
      ) {
    switch (type) {
      case AnalyticsMetricType.streak:
        return Icons.local_fire_department_rounded;

      case AnalyticsMetricType.xp:
        return Icons.stars_rounded;

      case AnalyticsMetricType.habits:
        return Icons.check_circle_rounded;

      case AnalyticsMetricType.completion:
        return Icons.task_alt_rounded;

      case AnalyticsMetricType.consistency:
        return Icons.insights_rounded;

      case AnalyticsMetricType.duration:
        return Icons.timer_outlined;

      case AnalyticsMetricType.perfectDays:
        return Icons.verified_rounded;
    }
  }

  // ===============================================================
  // ACCENT COLOR
  // ===============================================================

  Color _color(
      AnalyticsMetricType type,
      ) {
    switch (type) {
      case AnalyticsMetricType.streak:
        return const Color(0xFFEA580C);

      case AnalyticsMetricType.xp:
        return const Color(0xFFD97706);

      case AnalyticsMetricType.habits:
        return const Color(0xFF2563EB);

      case AnalyticsMetricType.completion:
        return const Color(0xFF3B82F6);

      case AnalyticsMetricType.consistency:
        return const Color(0xFF6366F1);

      case AnalyticsMetricType.duration:
        return const Color(0xFF0284C7);

      case AnalyticsMetricType.perfectDays:
        return const Color(0xFF14B8A6);
    }
  }
}

// ===================================================================
// TREND BADGE
// ===================================================================

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({
    required this.metric,
    required this.isDark,
  });

  final AnalyticsCardModel metric;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final positive = metric.positiveTrend;

    final trendColor = positive
        ? const Color(0xFF34D399)
        : const Color(0xFFF87171);

    final trendBackground = positive
        ? isDark
        ? const Color(0xFF123B2A)
        : const Color(0xFFECFDF5)
        : isDark
        ? const Color(0xFF451A1A)
        : const Color(0xFFFEF2F2);

    final trendBorder = positive
        ? const Color(0xFF10B981)
        : const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 3,
      ),

      decoration: BoxDecoration(
        color: trendBackground,
        borderRadius:
        BorderRadius.circular(999),
        border: Border.all(
          color: trendBorder.withValues(
            alpha: isDark ? 0.35 : 0.20,
          ),
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            positive
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            size: 13,
            color: trendColor,
          ),

          const SizedBox(width: 2),

          Text(
            metric.trend!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,

            style: theme.textTheme.labelSmall?.copyWith(
              color: trendColor,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}