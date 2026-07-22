import 'package:flutter/material.dart';

import '../../../../../core/extensions/habit_extensions.dart';
import '../../../domain/models/habit.dart';

class HabitHeader extends StatelessWidget {
  const HabitHeader({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CircleAvatar(
          radius: 42,
          backgroundColor: habit.color.withOpacity(.15),
          child: Icon(
            habit.icon,
            color: habit.color,
            size: 40,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          habit.title,
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        if (habit.description.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            habit.description,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
