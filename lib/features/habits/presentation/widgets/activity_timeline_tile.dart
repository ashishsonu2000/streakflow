import 'package:flutter/material.dart';

import '../../data/entities/completion_status.dart';
import '../../data/entities/habit_log_entity.dart';

class ActivityTimelineTile extends StatelessWidget {
  const ActivityTimelineTile({
    super.key,
    required this.log,
  });

  final HabitLogEntity log;

  @override
  Widget build(BuildContext context) {
    final completed = log.status == CompletionStatus.completed;

    final color = completed ? Colors.green : Colors.red;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: color.withOpacity(.12),
              child: Icon(
                completed ? Icons.check : Icons.close,
                color: color,
                size: 18,
              ),
            ),
            Container(
              width: 2,
              height: 48,
              color: Colors.grey.shade300,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title(log),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  _subtitle(log),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _title(HabitLogEntity log) {
    if (log.status == CompletionStatus.completed) {
      return "Completed";
    }

    return "Missed";
  }

  String _subtitle(HabitLogEntity log) {
    final date = log.completedAt ?? log.date;

    final hour = date.hour.toString().padLeft(2, '0');

    final minute = date.minute.toString().padLeft(2, '0');

    return "${date.day}/${date.month}/${date.year} • $hour:$minute";
  }
}
