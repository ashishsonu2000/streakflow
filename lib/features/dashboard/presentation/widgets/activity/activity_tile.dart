import 'package:flutter/material.dart';

import '../../../../../core/ui/avatars/app_avatar.dart';
import '../../../domain/models/activity_item.dart';
import 'activity_time_formatter.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile({
    super.key,
    required this.activity,
  });

  final ActivityItem activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isDark =
        theme.brightness == Brightness.dark;

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,

      // =========================================================
      // AVATAR
      // =========================================================

      leading: AppAvatar(
        icon: activity.icon,
        color: activity.color,
        size: 40,
      ),

      // =========================================================
      // TITLE
      // =========================================================

      title: Text(
        activity.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleSmall?.copyWith(
          color: colors.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),

      // =========================================================
      // TIME
      // =========================================================

      subtitle: Text(
        ActivityTimeFormatter.format(
          activity.date,
        ),
        style: theme.textTheme.bodySmall?.copyWith(
          color: colors.onSurfaceVariant,
        ),
      ),

      // =========================================================
      // XP
      // =========================================================

      trailing: Text(
        "+${activity.xp} XP",
        style: theme.textTheme.labelLarge?.copyWith(
          color: isDark
              ? const Color(0xFF4ADE80)
              : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}