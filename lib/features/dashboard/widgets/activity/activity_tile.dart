import 'package:flutter/material.dart';

import '../../../../../core/ui/avatars/app_avatar.dart';
import '../../domain/models/activity_item.dart';
import '../../presentation/widgets/activity/activity_time_formatter.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile({
    super.key,
    required this.activity,
  });

  final ActivityItem activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: AppAvatar(
        icon: activity.icon,
        color: activity.color,
        size: 40,
      ),
      title: Text(
        activity.title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        ActivityTimeFormatter.format(
          activity.date,
        ),
      ),
      trailing: Text(
        "+${activity.xp} XP",
        style: theme.textTheme.labelMedium?.copyWith(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
