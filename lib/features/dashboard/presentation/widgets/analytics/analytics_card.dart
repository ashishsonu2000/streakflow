import 'package:flutter/material.dart';

import '../../../../../core/ui/analytics/analytics_card_model.dart';

class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({
    super.key,
    required this.metric,
  });

  final AnalyticsCardModel metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = metric.color;
    final progress = metric.progress?.clamp(0.0, 1.0);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),

          // ----------------------------------------------------------
          // Surface
          // ----------------------------------------------------------

          color: theme.colorScheme.surface,

          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(
              alpha: 0.65,
            ),
          ),

          // ----------------------------------------------------------
          // Subtle premium shadow
          // ----------------------------------------------------------

          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.06),
              blurRadius: 18,
              spreadRadius: 0,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========================================================
              // HEADER
              // ========================================================

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ----------------------------------------------------
                  // Icon
                  // ----------------------------------------------------

                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.11),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      metric.icon,
                      color: color,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 11),

                  // ----------------------------------------------------
                  // Title
                  // ----------------------------------------------------

                  Expanded(
                    child: Text(
                      metric.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // ========================================================
              // VALUE
              // ========================================================

              Text(
                metric.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  height: 1.05,
                ),
              ),

              // ========================================================
              // SUBTITLE
              // ========================================================

              if (metric.subtitle != null) ...[
                const SizedBox(height: 5),
                Text(
                  metric.subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],

              // ========================================================
              // PROGRESS
              // ========================================================

              if (progress != null) ...[
                const SizedBox(height: 13),

                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: SizedBox(
                    height: 5,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.10),
                            ),
                          ),
                        ),

                        FractionallySizedBox(
                          widthFactor: progress,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // ========================================================
              // TREND
              // ========================================================

              if (metric.trend != null) ...[
                const SizedBox(height: 12),

                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: (metric.positiveTrend
                            ? Colors.green
                            : Colors.red)
                            .withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        metric.positiveTrend
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        size: 14,
                        color: metric.positiveTrend
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),

                    const SizedBox(width: 7),

                    Expanded(
                      child: Text(
                        metric.trend!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: metric.positiveTrend
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}