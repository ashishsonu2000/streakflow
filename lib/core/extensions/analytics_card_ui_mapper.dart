import 'package:flutter/material.dart';

import '../ui/analytics/analytics_card_model.dart';
import '../ui/analytics/analytics_metric_type.dart';

extension AnalyticsCardUI on AnalyticsCardModel {
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