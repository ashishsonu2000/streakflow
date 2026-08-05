import 'package:flutter/material.dart';

import '../../../../core/ui/insights/insight_item.dart';
import '../../../dashboard/domain/models/Insight_type.dart';

import '../../domain/models/insight.dart';

class InsightMapper {
  const InsightMapper();

  List<InsightItem> map(
    List<Insight> insights,
  ) {
    return insights.map(_mapInsight).toList();
  }

  InsightItem _mapInsight(
    Insight insight,
  ) {
    return InsightItem(
      title: insight.title,
      message: insight.description,
      icon: _icon(insight.icon),
      color: _color(insight.icon),
    );
  }

  InsightType _type(String icon) {
    switch (icon) {
      case 'emoji_events':
        return InsightType.success;

      case 'warning':
        return InsightType.warning;

      case 'rocket_launch':
        return InsightType.info;

      case 'trending_up':
        return InsightType.tip;

      default:
        return InsightType.info;
    }
  }

  IconData _icon(String icon) {
    switch (icon) {
      case 'emoji_events':
        return Icons.emoji_events;

      case 'warning':
        return Icons.warning_amber_rounded;

      case 'rocket_launch':
        return Icons.rocket_launch;

      case 'trending_up':
        return Icons.trending_up;

      default:
        return Icons.lightbulb_outline;
    }
  }

  Color _color(String icon) {
    switch (icon) {
      case 'emoji_events':
        return Colors.amber;

      case 'warning':
        return Colors.orange;

      case 'rocket_launch':
        return Colors.blue;

      case 'trending_up':
        return Colors.green;

      default:
        return Colors.indigo;
    }
  }
}
