import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../dashboard/domain/models/habit_summary.dart';
import 'habit_footer.dart';
import 'habit_icon.dart';

enum HabitMenuAction {
  edit,
  archive,
  delete,
}

class HabitCard extends StatelessWidget {
  final HabitSummary habit;

  final VoidCallback? onTap;

  final ValueChanged<bool>? onCompleted;

  final VoidCallback? onEdit;

  final VoidCallback? onArchive;

  final VoidCallback? onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    this.onTap,
    this.onCompleted,
    this.onEdit,
    this.onArchive,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AppCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HabitIcon(
                icon: habit.icon,
                color: habit.color,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      habit.subtitle,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    HabitFooter(
                      streak: habit.streak,
                      points: habit.points,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Checkbox(
                    value: habit.completed,
                    onChanged: (value) {
                      debugPrint(
                        "Checkbox changed: ${habit.title} -> $value",
                      );

                      if (value != null) {
                        onCompleted?.call(value);
                      }
                    },
                  ),
                  PopupMenuButton<HabitMenuAction>(
                    tooltip: "Habit Actions",
                    onSelected: (action) {
                      switch (action) {
                        case HabitMenuAction.edit:
                          onEdit?.call();
                          break;

                        case HabitMenuAction.archive:
                          onArchive?.call();
                          break;

                        case HabitMenuAction.delete:
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: HabitMenuAction.edit,
                        child: ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text("Edit"),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem(
                        value: HabitMenuAction.archive,
                        child: ListTile(
                          leading: Icon(Icons.archive_outlined),
                          title: Text("Archive"),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem(
                        value: HabitMenuAction.delete,
                        child: ListTile(
                          leading: Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          title: Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
