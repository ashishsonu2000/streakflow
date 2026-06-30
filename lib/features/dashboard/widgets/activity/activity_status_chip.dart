import 'package:flutter/material.dart';

import '../../domain/models/activity_status.dart';

class ActivityStatusChip extends StatelessWidget {
  final ActivityStatus status;

  const ActivityStatusChip({
    super.key,
    required this.status,
  });

  Color get _color {
    switch (status) {
      case ActivityStatus.completed:
        return Colors.green;
      case ActivityStatus.skipped:
        return Colors.orange;
      case ActivityStatus.failed:
        return Colors.red;
      case ActivityStatus.pending:
        return Colors.blue;
    }
  }

  IconData get _icon {
    switch (status) {
      case ActivityStatus.completed:
        return Icons.check_circle;
      case ActivityStatus.skipped:
        return Icons.skip_next;
      case ActivityStatus.failed:
        return Icons.cancel;
      case ActivityStatus.pending:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        _icon,
        size: 16,
        color: Colors.white,
      ),
      label: Text(
        status.label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: _color,
      visualDensity: VisualDensity.compact,
    );
  }
}
