import 'package:flutter/material.dart';

import '../../../../core/ui/insights/insight_item.dart';
import '../../../../core/ui/section/app_section_header.dart';

import 'insight_card.dart';

class DashboardInsights extends StatelessWidget {
  const DashboardInsights({
    super.key,
    required this.insights,
  });

  final List<InsightItem> insights;

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(
          title: 'Insights',
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: insights.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final insight = insights[index];

            return InsightCard(
              icon: insight.icon,
              color: insight.color,
              title: insight.title,
              message: insight.message,
            );
          },
        ),
      ],
    );
  }
}
