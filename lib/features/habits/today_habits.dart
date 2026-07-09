import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../shared/widgets/slidable/app_slidable.dart';

import '../dashboard/domain/models/habit_card_model.dart';
import '../dashboard/widgets/sections/section_title.dart';
import '../habits/habit_card.dart';

/// ===============================================================
///
/// Today's Habits Section
///
/// ===============================================================

class TodayHabits extends StatelessWidget {
  const TodayHabits({
    super.key,
    required this.habits,
    this.onSeeAll,
    this.onHabitTap,
    this.onHabitCompleted,
    this.onEdit,
    this.onDuplicate,
    this.onArchive,
    this.onDelete,
  });

  final List<HabitCardModel> habits;

  final VoidCallback? onSeeAll;

  final ValueChanged<HabitCardModel>? onHabitTap;

  final void Function(HabitCardModel habit, bool completed)? onHabitCompleted;

  final ValueChanged<HabitCardModel>? onEdit;

  final ValueChanged<HabitCardModel>? onDuplicate;

  final ValueChanged<HabitCardModel>? onArchive;

  final ValueChanged<HabitCardModel>? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: "Today's Habits",
          actionText: habits.isEmpty ? null : "See All",
          onActionPressed: onSeeAll,
        ),
        const SizedBox(height: 16),
        if (habits.isEmpty)
          _buildEmptyState(context)
        else
          SlidableAutoCloseBehavior(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: habits.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = habits[index];

                return AppSlidable(
                  onEdit: () => onEdit?.call(item),
                  onDuplicate: () => onDuplicate?.call(item),
                  onArchive: () => onArchive?.call(item),
                  onDelete: () => onDelete?.call(item),
                  child: HabitCard(
                    habit: item,

                    onTap: () => onHabitTap?.call(item),

                    onCompleted: (completed) {
                      onHabitCompleted?.call(
                        item,
                        completed,
                      );
                    },

                    // Popup menu actions
                    onEdit: () => onEdit?.call(item),

                    onCopy: () => onDuplicate?.call(item),

                    onArchive: () => onArchive?.call(item),

                    onDelete: () => onDelete?.call(item),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 32,
        ),
        child: Column(
          children: [
            Icon(
              Icons.task_alt_outlined,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              "No habits for today",
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "Tap the Add Habit button to create your first habit.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
