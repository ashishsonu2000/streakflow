import 'package:flutter/material.dart';

enum AppStatus {
  active,
  archived,
  completed,
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.status,
  });

  final AppStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      AppStatus.active => (
          Colors.green,
          'Active',
        ),
      AppStatus.archived => (
          Colors.orange,
          'Archived',
        ),
      AppStatus.completed => (
          Colors.blue,
          'Completed',
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
