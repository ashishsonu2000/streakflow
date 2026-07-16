import 'package:flutter/material.dart';

import '../../../domain/models/analytics_card_model.dart';
import '../../../domain/models/dashboard_metric_type.dart';

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

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //----------------------------------------------------------
            // Header
            //----------------------------------------------------------

            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.12),
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
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            //----------------------------------------------------------
            // Value
            //----------------------------------------------------------

            Text(
              metric.value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            if (metric.subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                metric.subtitle!,
                style: theme.textTheme.bodySmall,
              ),
            ],

            const SizedBox(height: 10),

            //----------------------------------------------------------
            // Trend
            //----------------------------------------------------------

            if (metric.trend != null)
              Row(
                children: [
                  Icon(
                    metric.positiveTrend
                        ? Icons.trending_up
                        : Icons.trending_down,
                    size: 16,
                    color: metric.positiveTrend ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    metric.trend!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: metric.positiveTrend ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  IconData _icon(DashboardMetricType type) {
    switch (type) {
      case DashboardMetricType.streak:
        return Icons.local_fire_department_rounded;

      case DashboardMetricType.xp:
        return Icons.stars_rounded;

      case DashboardMetricType.habits:
        return Icons.check_circle_rounded;

      case DashboardMetricType.completion:
        return Icons.task_alt_rounded;

      case DashboardMetricType.consistency:
        return Icons.insights_rounded;
    }
  }

  Color _color(DashboardMetricType type) {
    switch (type) {
      case DashboardMetricType.streak:
        return Colors.deepOrange;

      case DashboardMetricType.xp:
        return Colors.amber.shade700;

      case DashboardMetricType.habits:
        return Colors.purple;

      case DashboardMetricType.completion:
        return Colors.green;

      case DashboardMetricType.consistency:
        return Colors.blue;
    }
  }
}
