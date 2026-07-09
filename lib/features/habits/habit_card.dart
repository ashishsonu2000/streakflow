import 'package:flutter/material.dart';
import 'package:streak_calculator_flutter/core/extensions/habit_extensions.dart';
import 'package:streak_calculator_flutter/features/dashboard/domain/models/habit_card_model.dart';

import '../../../../core/widgets/app_card.dart';
import '../../shared/ui/animations/animated_pressable.dart';
import 'habit_footer.dart';
import 'habit_icon.dart';

enum HabitMenuAction {
  edit,
  archive,
  delete,
  copy,
}

class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.habit,
    this.onTap,
    this.onCompleted,
    this.onEdit,
    this.onArchive,
    this.onDelete,
    this.onCopy,
  });

  final HabitCardModel habit;

  final VoidCallback? onTap;
  final ValueChanged<bool>? onCompleted;

  final VoidCallback? onEdit;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Hero(
      tag: 'habit_${habit.habit.id}',
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: habit.summary.completed ? .72 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: AnimatedPressable(
            onTap: onTap,
            child: AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HabitIcon(
                    icon: habit.habit.icon,
                    color: habit.habit.color,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.habit.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          habit.summary.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        HabitFooter(
                          streak: habit.summary.streak,
                          points: habit.summary.points,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Checkbox(
                          key: ValueKey(
                            habit.summary.completed,
                          ),
                          value: habit.summary.completed,
                          onChanged: (value) {
                            if (value != null) {
                              onCompleted?.call(value);
                            }
                          },
                        ),
                      ),
                      PopupMenuButton<HabitMenuAction>(
                        tooltip: "More actions",
                        icon: const Icon(
                          Icons.more_horiz_rounded,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onSelected: (action) {
                          switch (action) {
                            case HabitMenuAction.edit:
                              onEdit?.call();
                              break;

                            case HabitMenuAction.copy:
                              onCopy?.call();
                              break;

                            case HabitMenuAction.archive:
                              onArchive?.call();
                              break;

                            case HabitMenuAction.delete:
                              onDelete?.call();
                              break;
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: HabitMenuAction.edit,
                            child: ListTile(
                              leading: Icon(
                                Icons.edit_outlined,
                              ),
                              title: Text("Edit"),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          PopupMenuItem(
                            value: HabitMenuAction.copy,
                            child: ListTile(
                              leading: Icon(
                                Icons.copy_outlined,
                                color: Colors.blue,
                              ),
                              title: Text("Duplicate"),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          PopupMenuItem(
                            value: HabitMenuAction.archive,
                            child: ListTile(
                              leading: Icon(
                                Icons.archive_outlined,
                                color: Colors.orange,
                              ),
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
        ),
      ),
    );
  }
}
