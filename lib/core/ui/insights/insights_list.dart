import 'package:flutter/material.dart';

import '../section/app_section_header.dart';

import 'insight_card.dart';
import 'insight_item.dart';

class InsightsList extends StatelessWidget {
  const InsightsList({
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
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: insights.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            return InsightCard(
              insight: insights[index],
            );
          },
        ),
      ],
    );
  }
}
