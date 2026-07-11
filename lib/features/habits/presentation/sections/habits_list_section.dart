import 'package:flutter/material.dart';

import '../../../../shared/widgets/slidable/app_slidable.dart';
import '../../../dashboard/domain/models/habit_card_model.dart';
import '../../habit_card.dart';

class HabitListSection extends StatelessWidget {
  const HabitListSection({
    super.key,
    required this.title,
    required this.habits,
    this.actionText,
    this.onActionPressed,
    this.onHabitTap,
    this.onHabitCompleted,
    this.onEdit,
    this.onDuplicate,
    this.onArchive,
    this.onDelete,
    this.emptyTitle,
    this.emptySubtitle,
  });

  final String title;

  final String? actionText;

  final VoidCallback? onActionPressed;

  final List<HabitCardModel> habits;

  final ValueChanged<HabitCardModel>? onHabitTap;

  final void Function(HabitCardModel habit, bool completed)? onHabitCompleted;

  final ValueChanged<HabitCardModel>? onEdit;

  final ValueChanged<HabitCardModel>? onDuplicate;

  final ValueChanged<HabitCardModel>? onArchive;

  final ValueChanged<HabitCardModel>? onDelete;

  final String? emptyTitle;

  final String? emptySubtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //--------------------------------------------------
        // Header
        //--------------------------------------------------

        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (actionText != null)
              TextButton(
                onPressed: onActionPressed,
                child: Text(actionText!),
              ),
          ],
        ),

        const SizedBox(height: 16),

        //--------------------------------------------------
        // Empty State
        //--------------------------------------------------

        if (habits.isEmpty)
          _EmptyState(
            title: emptyTitle ?? "No Habits",
            subtitle: emptySubtitle ??
                "Create your first habit to start building your streak.",
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: habits.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final HabitCardModel item = habits[index];

              return AppSlidable(
                onEdit: () => onEdit?.call(item),
                onDuplicate: () => onDuplicate?.call(item),
                onArchive: () => onArchive?.call(item),
                onDelete: () => onDelete?.call(item),
                child: HabitCard(
                  habit: item,
                  onTap: () => onHabitTap?.call(item),
                  onCompleted: (bool completed) {
                    onHabitCompleted?.call(item, completed);
                  },
                  onEdit: () => onEdit?.call(item),
                  onCopy: () => onDuplicate?.call(item),
                  onArchive: () => onArchive?.call(item),
                  onDelete: () => onDelete?.call(item),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 36,
        ),
        child: Column(
          children: [
            Icon(
              Icons.task_alt_outlined,
              size: 60,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
