import 'package:flutter/material.dart';

import '../../../../../core/ui/analytics/analytics_card_model.dart';
import '../../../../../core/ui/analytics/analytics_metric_type.dart';

extension AnalyticsCardUI on AnalyticsCardModel {
  Color get color {
    switch (type) {
      case AnalyticsMetricType.completion:
        return Colors.green;

      case AnalyticsMetricType.streak:
        return Colors.orange;

      case AnalyticsMetricType.xp:
        return Colors.blue;

      case AnalyticsMetricType.duration:
        return Colors.purple;

      default:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (type) {
      case AnalyticsMetricType.completion:
        return Icons.check_circle;

      case AnalyticsMetricType.streak:
        return Icons.local_fire_department;

      case AnalyticsMetricType.xp:
        return Icons.star;

      case AnalyticsMetricType.duration:
        return Icons.timer;

      default:
        return Icons.bar_chart;
    }
  }
}