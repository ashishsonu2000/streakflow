import 'package:flutter/material.dart';

enum HabitMenuAction {
  edit,
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
      onSelected: onSelected,
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: HabitMenuAction.edit,
          child: Text("Edit"),
        ),
        PopupMenuItem(
          value: HabitMenuAction.history,
          child: Text("History"),
        ),
        PopupMenuItem(
          value: HabitMenuAction.archive,
          child: Text("Archive"),
        ),
        PopupMenuItem(
          value: HabitMenuAction.delete,
          child: Text("Delete"),
        ),
      ],
    );
  }
}
