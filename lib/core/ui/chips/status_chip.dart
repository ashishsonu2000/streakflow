import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

enum AppStatus {
  completed,
  pending,
  archived,
  missed,
  locked,
  unlocked,
  active,
  inactive,
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.status,
  });

  final AppStatus status;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        _icon,
        size: 14,
        color: _color,
      ),
      label: Text(_label),
      backgroundColor: _color.withValues(alpha: .12),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelStyle: TextStyle(
        color: _color,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  String get _label {
    switch (status) {
      case AppStatus.completed:
        return "Completed";

      case AppStatus.pending:
        return "Pending";

      case AppStatus.archived:
        return "Archived";

      case AppStatus.missed:
        return "Missed";

      case AppStatus.locked:
        return "Locked";

      case AppStatus.unlocked:
        return "Unlocked";

      case AppStatus.active:
        return "Active";

      case AppStatus.inactive:
        return "Inactive";
    }
  }

  Color get _color {
    switch (status) {
      case AppStatus.completed:
        return AppColors.success;

      case AppStatus.pending:
        return AppColors.warning;

      case AppStatus.archived:
        return Colors.grey;

      case AppStatus.missed:
        return AppColors.error;

      case AppStatus.locked:
        return Colors.grey;

      case AppStatus.unlocked:
        return AppColors.gold;

      case AppStatus.active:
        return AppColors.primary;

      case AppStatus.inactive:
        return Colors.grey;
    }
  }

  IconData get _icon {
    switch (status) {
      case AppStatus.completed:
        return Icons.check_circle;

      case AppStatus.pending:
        return Icons.schedule;

      case AppStatus.archived:
        return Icons.archive;

      case AppStatus.missed:
        return Icons.close;

      case AppStatus.locked:
        return Icons.lock;

      case AppStatus.unlocked:
        return Icons.lock_open;

      case AppStatus.active:
        return Icons.play_circle;

      case AppStatus.inactive:
        return Icons.pause_circle;
    }
  }
}
