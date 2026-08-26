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
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        // =========================================================
        // SECTION HEADER
        // =========================================================

        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.lightbulb_rounded,
                size: 21,
                color: Color(0xFF2563EB),
              ),
            ),

            const SizedBox(width: 12),

            const Expanded(
              child: AppSectionHeader(
                title: 'Insights',
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // =========================================================
        // INSIGHTS
        // =========================================================

        ListView.separated(
          shrinkWrap: true,
          physics:
          const NeverScrollableScrollPhysics(),
          itemCount: insights.length,
          separatorBuilder: (_, __) {
            return const SizedBox(
              height: 10,
            );
          },
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