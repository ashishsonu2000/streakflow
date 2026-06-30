import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/models/activity_item.dart';
import 'activity_icon.dart';
import 'activity_status_chip.dart';

class ActivityTile extends StatelessWidget {
  final ActivityItem activity;

  const ActivityTile({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActivityIcon(activity: activity),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: text.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  activity.description,
                  style: text.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  activity.time,
                  style: text.bodySmall,
                ),
              ],
            ),
          ),
          ActivityStatusChip(
            status: activity.status,
          ),
        ],
      ),
    );
  }
}
