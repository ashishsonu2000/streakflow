import 'package:flutter/material.dart';

import '../../../../../core/ui/design/app_breakpoints.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int crossAxisCount;
        double childAspectRatio;

        if (width >= AppBreakpoints.largeDesktop) {
          crossAxisCount = 4;
          childAspectRatio = 1.75;
        } else if (width >= AppBreakpoints.desktop) {
          crossAxisCount = 4;
          childAspectRatio = 1.65;
        } else if (width >= AppBreakpoints.tablet) {
          crossAxisCount = 2;
          childAspectRatio = 1.60;
        } else {
          crossAxisCount = 2;
          childAspectRatio = 1.25;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: analytics.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            return AnalyticsCard(
              metric: analytics[index],
            );
          },
        );
      },
    );
  }
}
