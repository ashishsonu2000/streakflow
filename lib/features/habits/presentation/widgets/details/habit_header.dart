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
    final habitColor = habit.color;

    return Column(
      children: [
        // =============================================================
        // ICON
        // =============================================================

        Hero(
          tag: AppHeroTags.habitIcon(
            habit.id,
          ),
          child: Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: habitColor.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: habitColor.withValues(
                  alpha: 0.18,
                ),
              ),
            ),
            child: Center(
              child: HabitIcon(
                iconCodePoint: habit.iconCodePoint,
                color: habitColor,
                size: 52,
              ),
            ),
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        // =============================================================
        // TITLE
        // =============================================================

        Text(
          habit.title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),

        // =============================================================
        // DESCRIPTION
        // =============================================================

        if (habit.description.isNotEmpty) ...[
          const SizedBox(
            height: 8,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 520,
            ),
            child: Text(
              habit.description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
                height: 1.4,
              ),
            ),
          ),
        ],

        const SizedBox(
          height: 12,
        ),

        // =============================================================
        // ACTIVE / ARCHIVED STATUS
        // =============================================================

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: habit.archived
                ? Colors.orange.withValues(
              alpha: 0.10,
            )
                : theme.colorScheme.primary.withValues(
              alpha: 0.09,
            ),
            borderRadius: BorderRadius.circular(
              999,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                habit.archived
                    ? Icons.archive_outlined
                    : Icons.check_circle_outline_rounded,
                size: 15,
                color: habit.archived
                    ? Colors.orange
                    : theme.colorScheme.primary,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                habit.archived ? 'Archived' : 'Active',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: habit.archived
                      ? Colors.orange.shade800
                      : theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}