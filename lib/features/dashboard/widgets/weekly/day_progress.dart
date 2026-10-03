import 'package:flutter/material.dart';

import '../../domain/models/weekly_progress.dart';

class DayProgress extends StatelessWidget {
  final WeeklyProgress progress;

  const DayProgress({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                progress.completed ? colorScheme.primary : Colors.grey.shade300,
          ),
          child: Icon(
            progress.completed ? Icons.check : Icons.close,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          progress.day,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
