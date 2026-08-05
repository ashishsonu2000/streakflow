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
    final color = _color(metric.type);

    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //----------------------------------------------------------
          // Header
          //----------------------------------------------------------

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _icon(metric.type),
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  metric.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          //----------------------------------------------------------
          // Value
          //----------------------------------------------------------

          Text(
            metric.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          if (metric.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              metric.subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],

          //----------------------------------------------------------
          // Trend
          //----------------------------------------------------------

          if (metric.trend != null) ...[
            const Spacer(),
            Row(
              children: [
                Icon(
                  metric.positiveTrend
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  size: 16,
                  color: metric.positiveTrend ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    metric.trend!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: metric.positiveTrend ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  IconData _icon(AnalyticsMetricType type) {
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

  Color _color(AnalyticsMetricType type) {
    switch (type) {
      case AnalyticsMetricType.streak:
        return Colors.deepOrange;

      case AnalyticsMetricType.xp:
        return Colors.amber.shade700;

      case AnalyticsMetricType.habits:
        return Colors.purple;

      case AnalyticsMetricType.completion:
        return Colors.green;

      case AnalyticsMetricType.consistency:
        return Colors.blue;

      case AnalyticsMetricType.duration:
        return Colors.lightBlue;

      case AnalyticsMetricType.perfectDays:
        return Colors.deepPurple;
    }
  }
}
