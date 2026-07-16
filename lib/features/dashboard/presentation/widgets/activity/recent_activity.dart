import 'package:flutter/material.dart';

import '../../../domain/models/activity_item.dart';

import 'activity_empty.dart';
import 'activity_tile.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({
    super.key,
    required this.activities,
  });

  final List<ActivityItem> activities;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent Activity",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            if (activities.isEmpty)
              const ActivityEmpty()
            else
              ...activities.map(
                (activity) => ActivityTile(
                  activity: activity,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
