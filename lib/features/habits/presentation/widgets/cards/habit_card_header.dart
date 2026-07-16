import 'package:flutter/material.dart';

import '../../../../../core/ui/avatars/app_avatar.dart';
import '../../../../../core/ui/chips/app_chip.dart';
import '../../../domain/extensions/habit_category_extension.dart';
import '../../../domain/extensions/difficulty_extension.dart';
import '../../../domain/models/habit_card_view_model.dart';

class HabitCardHeader extends StatelessWidget {
  const HabitCardHeader({
    super.key,
    required this.habit,
  });

  final HabitCardViewModel habit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAvatar(
          icon: habit.icon,
          color: habit.color,
          size: 52,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                habit.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  AppChip(
                    label: habit.category.label,
                    color: habit.category.color,
                    icon: habit.category.icon,
                  ),
                  AppChip(
                    label: habit.difficulty.label,
                    color: habit.difficulty.color,
                    icon: habit.difficulty.icon,
                  ),
                ],
              ),
            ],
          ),
        ),
        Icon(
          habit.completedToday
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          color: habit.completedToday ? Colors.green : Colors.orange,
        ),
      ],
    );
  }
}
