import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../core/extensions/habit_extensions.dart';
import '../../domain/models/habit.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onComplete;
  final VoidCallback? onArchive;

  const HabitTile({
    super.key,
    required this.habit,
    this.onTap,
    this.onLongPress,
    this.onComplete,
    this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Slidable(
      key: ValueKey(habit.id),
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onComplete?.call(),
            backgroundColor:
                habit.completedToday ? Colors.orange : Colors.green,
            foregroundColor: Colors.white,
            icon: habit.completedToday ? Icons.undo : Icons.check,
            label: habit.completedToday ? "Undo" : "Complete",
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onTap?.call(),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: "Edit",
          ),
          SlidableAction(
            onPressed: (_) => onArchive?.call(),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: "Archive",
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: habit.color,
                  child: Icon(
                    habit.icon,
                    color: Colors.white,
                  ),
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
                          decoration: habit.completedToday
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habit.description.isEmpty
                            ? habit.category.name
                            : habit.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${habit.currentStreak} Days",
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${habit.xp} XP",
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onComplete,
                  icon: Icon(
                    habit.completedToday
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: habit.completedToday ? Colors.green : Colors.grey,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
