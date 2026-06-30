import 'package:flutter/material.dart';

import 'activity_status.dart';

class ActivityItem {
  final String id;

  final String title;

  final String description;

  final IconData icon;

  final Color color;

  final String time;

  final ActivityStatus status;

  const ActivityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.time,
    required this.status,
  });
}
