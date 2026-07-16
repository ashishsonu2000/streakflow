import 'package:flutter/material.dart';

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
    required this.xp,
  });

  final String id;

  final String title;

  final String description;

  final IconData icon;

  final Color color;

  final ActivityStatus status;

  final DateTime date;

  final int xp;
}
