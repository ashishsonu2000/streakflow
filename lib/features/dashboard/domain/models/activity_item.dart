import 'package:flutter/cupertino.dart';

import 'activity_status.dart';

class ActivityItem {
  const ActivityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.status,
    required this.date,
    required this.time,
    required this.xp,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final ActivityStatus status;
  final DateTime date;
  final String time;
  final int xp;

  String get dayLabel {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final activityDay = DateTime(date.year, date.month, date.day);

    final diff = today.difference(activityDay).inDays;

    if (diff == 0) return "Today";
    if (diff == 1) return "Yesterday";
    return "${date.day}/${date.month}/${date.year}";
  }


}