import 'package:flutter/material.dart';

import '../../../../../core/extensions/habit_extensions.dart';
import '../../../../../core/ui/hero/app_hero_tags.dart';
import '../../../../../core/ui/icons/habit_icon.dart';
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
        Hero(
          tag: AppHeroTags.habitIcon(habit.id),
          child: HabitIcon(
            iconCodePoint: habit.iconCodePoint,
            color: habit.color,
            size: 84,
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
