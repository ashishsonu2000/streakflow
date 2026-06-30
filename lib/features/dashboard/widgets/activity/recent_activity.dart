import 'package:flutter/material.dart';

import '../../domain/models/activity_item.dart';
import '../sections/section_title.dart';
import 'activity_tile.dart';

class RecentActivity extends StatelessWidget {
  final List<ActivityItem> activities;

  const RecentActivity({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: "Recent Activity",
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            return ActivityTile(
              activity: activities[index],
            );
          },
        ),
      ],
    );
  }
}
