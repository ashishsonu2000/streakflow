import 'package:flutter/material.dart';
import 'package:streak_calculator_flutter/features/dashboard/domain/models/insight_item.dart';

import '../../../../core/ui/section/app_section_header.dart';
import 'insight_card.dart';

class DashboardInsights extends StatelessWidget {
  const DashboardInsights({
    super.key,
    required List<InsightItem> insights,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: "Insights",
        ),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.4,
          children: const [
            InsightCard(
              icon: Icons.check_circle,
              color: Colors.green,
              value: "3 / 4",
              label: "Completed",
            ),
            InsightCard(
              icon: Icons.local_fire_department,
              color: Colors.orange,
              value: "18",
              label: "Day Streak",
            ),
            InsightCard(
              icon: Icons.stars,
              color: Colors.amber,
              value: "+10 XP",
              label: "Earned Today",
            ),
            InsightCard(
              icon: Icons.track_changes,
              color: Colors.blue,
              value: "82%",
              label: "Weekly Success",
            ),
          ],
        ),
      ],
    );
  }
}
