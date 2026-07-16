import 'package:flutter/material.dart';

enum StatusChipType {
  completed,
  pending,
  archived,
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.status,
  });

  final StatusChipType status;

  @override
  Widget build(BuildContext context) {
    late final Color color;
    late final IconData icon;
    late final String label;

    switch (status) {
      case StatusChipType.completed:
        color = Colors.green;
        icon = Icons.check_circle_rounded;
        label = "Completed";
        break;

      case StatusChipType.pending:
        color = Colors.orange;
        icon = Icons.schedule_rounded;
        label = "Pending";
        break;

      case StatusChipType.archived:
        color = Colors.grey;
        icon = Icons.archive_rounded;
        label = "Archived";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
