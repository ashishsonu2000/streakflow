import 'package:flutter/material.dart';

enum HabitMenuAction {
  edit,
  duplicate,
  history,
  archive,
  delete,
}

class HabitPopupMenu extends StatelessWidget {
  const HabitPopupMenu({
    super.key,
    required this.onSelected,
  });

  final ValueChanged<HabitMenuAction> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<HabitMenuAction>(
      tooltip: 'More actions',
      onSelected: onSelected,
      itemBuilder: (_) => const [
        // =========================================================
        // EDIT
        // =========================================================

        PopupMenuItem(
          value: HabitMenuAction.edit,
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
              ),
              SizedBox(
                width: 12,
              ),
              Text('Edit'),
            ],
          ),
        ),

        // =========================================================
        // DUPLICATE
        // =========================================================

        PopupMenuItem(
          value: HabitMenuAction.duplicate,
          child: Row(
            children: [
              Icon(
                Icons.copy_outlined,
              ),
              SizedBox(
                width: 12,
              ),
              Text('Duplicate'),
            ],
          ),
        ),

        // =========================================================
        // HISTORY
        // =========================================================

        PopupMenuItem(
          value: HabitMenuAction.history,
          child: Row(
            children: [
              Icon(
                Icons.history_rounded,
              ),
              SizedBox(
                width: 12,
              ),
              Text('History'),
            ],
          ),
        ),

        // =========================================================
        // ARCHIVE
        // =========================================================

        PopupMenuItem(
          value: HabitMenuAction.archive,
          child: Row(
            children: [
              Icon(
                Icons.archive_outlined,
              ),
              SizedBox(
                width: 12,
              ),
              Text('Archive'),
            ],
          ),
        ),

        // =========================================================
        // SEPARATOR
        // =========================================================

        PopupMenuDivider(),

        // =========================================================
        // DELETE
        // =========================================================

        PopupMenuItem(
          value: HabitMenuAction.delete,
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}