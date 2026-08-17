import 'package:flutter/material.dart';

import '../../../domain/models/habit_log.dart';



class RecentActivityTile extends StatelessWidget {
  const RecentActivityTile({
    super.key,
    required this.log,
  });

  final HabitLog log;

  String _relativeDate() {
    final now = DateTime.now();

    final difference =
        now.difference(log.date).inDays;

    if (difference == 0) {
      return 'Today';
    }

    if (difference == 1) {
      return 'Yesterday';
    }

    return '$difference days ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        child: Icon(Icons.check),
      ),
      title: Text(
        'Completed ${_relativeDate()}',
      ),
      subtitle: Text(
        '+${log.xpEarned} XP',
      ),
      trailing: Text(
        log.completedAt == null
            ? '--'
            : TimeOfDay.fromDateTime(
          log.completedAt!,
        ).format(context),
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}