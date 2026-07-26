import 'package:flutter/material.dart';

import '../actions/habit_popup_menu.dart';

class HabitCardMenu extends StatelessWidget {
  const HabitCardMenu({
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
          child: Text('Edit'),
        ),
        PopupMenuItem(
          value: HabitMenuAction.duplicate,
          child: Text('Duplicate'),
        ),
        PopupMenuItem(
          value: HabitMenuAction.archive,
          child: Text('Archive'),
        ),
        PopupMenuItem(
          value: HabitMenuAction.delete,
          child: Text('Delete'),
        ),
      ],
    );
  }
}
