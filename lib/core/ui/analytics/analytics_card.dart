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

    final accent = _color(metric.type);
    final icon = _icon(metric.type);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),

          // Very subtle navy/blue tint.
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFF7FAFF),
            ],
          ),
        ),
        child: Stack(
          children: [
            // =========================================================
            // TOP ACCENT
            // =========================================================

            Positioned(
              top: 0,
              left: 18,
              right: 18,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  borderRadius:
                  const BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      accent.withValues(alpha: 0.95),
                      accent.withValues(alpha: 0.25),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // ===================================================
                  // HEADER
                  // ===================================================

                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: accent.withValues(
                            alpha: 0.10,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accent.withValues(
                              alpha: 0.10,
                            ),
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: accent,
                          size: 23,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          metric.title,
                          maxLines: 2,
                          overflow:
                          TextOverflow.ellipsis,
                          style: theme
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                            fontWeight:
                            FontWeight.w700,
                            color: const Color(
                              0xFF172033,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ===================================================
                  // VALUE
                  // ===================================================

                  Text(
                    metric.value,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: theme
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                      fontWeight:
                      FontWeight.w800,
                      color: const Color(
                        0xFF0F172A,
                      ),
                      letterSpacing: -0.5,
                    ),
                  ),

                  // ===================================================
                  // SUBTITLE
                  // ===================================================

                  if (metric.subtitle != null) ...[
                    const SizedBox(height: 4),

                    Text(
                      metric.subtitle!,
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
                      ),
                    ),
                  ],

                  const Spacer(),

                  // ===================================================
                  // TREND
                  // ===================================================

                  if (metric.trend != null)
                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: metric.positiveTrend
                            ? const Color(
                          0xFFECFDF5,
                        )
                            : const Color(
                          0xFFFEF2F2,
                        ),
                        borderRadius:
                        BorderRadius.circular(
                          999,
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                        MainAxisSize.min,
                        children: [
                          Icon(
                            metric.positiveTrend
                                ? Icons
                                .trending_up_rounded
                                : Icons
                                .trending_down_rounded,
                            size: 15,
                            color:
                            metric.positiveTrend
                                ? const Color(
                              0xFF059669,
                            )
                                : const Color(
                              0xFFDC2626,
                            ),
                          ),

                          const SizedBox(width: 4),

                          Flexible(
                            child: Text(
                              metric.trend!,
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: theme
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                color: metric
                                    .positiveTrend
                                    ? const Color(
                                  0xFF047857,
                                )
                                    : const Color(
                                  0xFFB91C1C,
                                ),
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
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
  // ICONS
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
  // COLORS
  // ===============================================================

  Color _color(
      AnalyticsMetricType type,
      ) {
    switch (type) {
    // Keep streak visually connected to the
    // fire animation in the Hero.
      case AnalyticsMetricType.streak:
        return const Color(0xFFEA580C);

    // XP keeps its gold identity.
      case AnalyticsMetricType.xp:
        return const Color(0xFFD97706);

    // Main app blue.
      case AnalyticsMetricType.habits:
        return const Color(0xFF2563EB);

    // Navy-blue.
      case AnalyticsMetricType.completion:
        return const Color(0xFF1D4ED8);

    // Indigo-blue.
      case AnalyticsMetricType.consistency:
        return const Color(0xFF4F46E5);

    // Light blue.
      case AnalyticsMetricType.duration:
        return const Color(0xFF0284C7);

    // Deep navy.
      case AnalyticsMetricType.perfectDays:
        return const Color(0xFF3730A3);
    }
  }
}