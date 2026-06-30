import 'package:flutter/material.dart';

import '../../domain/models/activity_item.dart';

class ActivityIcon extends StatelessWidget {
  final ActivityItem activity;

  const ActivityIcon({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: activity.color.withOpacity(.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        activity.icon,
        color: activity.color,
        size: 26,
      ),
    );
  }
}
