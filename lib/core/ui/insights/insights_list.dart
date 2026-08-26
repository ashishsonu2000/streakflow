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
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(
          title: 'Insights',
        ),

        const SizedBox(height: 14),

        Column(
          children: List.generate(
            insights.length,
                (index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom:
                  index == insights.length - 1
                      ? 0
                      : 12,
                ),
                child: InsightCard(
                  insight: insights[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}