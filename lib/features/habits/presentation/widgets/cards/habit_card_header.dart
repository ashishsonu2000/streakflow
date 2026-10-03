import 'package:flutter/material.dart';

import '../../../../../core/ui/hero/app_hero_tags.dart';
import '../../../../../core/ui/icons/habit_icon.dart';

import '../../../domain/models/habit.dart';

import '../actions/habit_popup_menu.dart';
import 'habit_card_menu.dart';

class HabitCardHeader extends StatelessWidget {
  const HabitCardHeader({
    super.key,
    required this.habit,
    required this.onMenuSelected,
  });

  final Habit habit;
  final ValueChanged<HabitMenuAction> onMenuSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final habitColor = Color(
      habit.colorValue,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =============================================================
        // HABIT ICON
        // =============================================================

        Hero(
          tag: AppHeroTags.habitIcon(
            habit.id,
          ),
          child: HabitIcon(
            iconCodePoint: habit.iconCodePoint,
            color: habitColor,
          ),
        ),

        const SizedBox(
          width: 12,
        ),

        // =============================================================
        // TITLE + DESCRIPTION
        // =============================================================

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                habit.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),

              if (habit.description.isNotEmpty) ...[
                const SizedBox(
                  height: 5,
                ),
                Text(
                  habit.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(
          width: 8,
        ),

        // =============================================================
        // ACTIVE / ARCHIVED + MENU
        // =============================================================

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatusPill(
              label: habit.archived
                  ? 'Archived'
                  : 'Active',
              icon: habit.archived
                  ? Icons.archive_outlined
                  : Icons.play_circle_outline_rounded,
              color: habit.archived
                  ? colors.onSurfaceVariant
                  : colors.primary,
            ),

            const SizedBox(
              width: 2,
            ),

            HabitCardMenu(
              onSelected: onMenuSelected,
            ),
          ],
        ),
      ],
    );
  }
}

// =====================================================================
// STATUS PILL
// =====================================================================

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: isDark ? 0.14 : 0.09,
        ),
        borderRadius: BorderRadius.circular(
          999,
        ),
        border: Border.all(
          color: color.withValues(
            alpha: isDark ? 0.25 : 0.16,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}