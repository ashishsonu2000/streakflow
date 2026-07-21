import 'package:flutter/material.dart';
import 'package:streak_calculator_flutter/features/habits/domain/extensions/habit_frequency_extension.dart';

import '../../../../../core/ui/colors/app_colors.dart';
import '../../../../../core/ui/ui.dart';
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
            if (habit.description.trim().isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                habit.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ],
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
                  label: habit.frequency.label,
                  color: AppColors.primary,
                  icon: Icons.repeat,
                ),
                AppChip(
                  label: habit.difficulty.label,
                  color: habit.difficulty.color,
                  icon: habit.difficulty.icon,
                ),
              ],
            ),
          ],
        )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            StatusChip(
              status: habit.completedToday
                  ? AppStatus.completed
                  : AppStatus.pending,
            ),
          ],
        )
      ],
    );
  }
}
