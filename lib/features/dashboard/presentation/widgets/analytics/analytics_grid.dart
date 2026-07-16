import 'package:flutter/material.dart';

import '../../../../../core/ui/layouts/responsive_grid.dart';
import '../../../domain/models/analytics_card_model.dart';
import 'analytics_card.dart';

class AnalyticsGrid extends StatelessWidget {
  const AnalyticsGrid({
    super.key,
    required this.analytics,
  });

  final List<AnalyticsCardModel> analytics;

  @override
  Widget build(BuildContext context) {
    return ResponsiveGrid(
      mobileColumns: 2,
      tabletColumns: 2,
      desktopColumns: 4,
      largeDesktopColumns: 4,
      mobileAspectRatio: 1.20,
      tabletAspectRatio: 1.55,
      desktopAspectRatio: 1.65,
      largeDesktopAspectRatio: 1.75,
      children: analytics
          .map(
            (metric) => AnalyticsCard(
              metric: metric,
            ),
          )
          .toList(),
    );
  }
}
