import 'package:flutter/material.dart';

import '../../../../../core/ui/layouts/responsive_grid.dart';

import 'analytics_card.dart';
import 'analytics_card_model.dart';

class AnalyticsGrid extends StatelessWidget {
  const AnalyticsGrid({
    super.key,
    required this.analytics,
  });

  final List<AnalyticsCardModel> analytics;

  @override
  Widget build(BuildContext context) {
    return ResponsiveGrid(
      //------------------------------------------
      // Grid configuration
      //------------------------------------------

      mobileColumns: 2,
      tabletColumns: 2,
      desktopColumns: 4,
      largeDesktopColumns: 4,

      //------------------------------------------
      // Card Aspect Ratio
      //------------------------------------------
      // Smaller ratio = Taller cards
      //------------------------------------------

      mobileAspectRatio: 0.90,
      tabletAspectRatio: 1.05,
      desktopAspectRatio: 1.20,
      largeDesktopAspectRatio: 1.30,

      //------------------------------------------
      // Cards
      //------------------------------------------

      children: analytics
          .map(
            (metric) => AnalyticsCard(
              metric: metric,
            ),
          )
          .toList(growable: false),
    );
  }
}
