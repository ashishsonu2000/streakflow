import 'package:flutter/material.dart';

import '../../../../../core/ui/empty/app_empty_state.dart';
import '../../../../../core/ui/layouts/responsive_grid.dart';
import '../../../domain/models/habit_card_view_model.dart';
import '../actions/habit_popup_menu.dart';
import '../cards/habit_card.dart';

class HabitList extends StatelessWidget {
  const HabitList({
    super.key,
    required this.habits,
    this.onHabitTap,
    this.onMenuSelected,
  });

  final List<HabitCardViewModel> habits;

  final ValueChanged<HabitCardViewModel>? onHabitTap;

  final void Function(
    HabitCardViewModel habit,
    HabitMenuAction action,
  )? onMenuSelected;

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      return AppEmptyState(
        icon: Icons.spa,
        title: 'Start Your First Habit',
        subtitle: 'Consistency begins with one small step.',
        buttonText: 'Create Habit',
        onPressed: () {},
      );
    }

    return ResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 2,
      desktopColumns: 3,
      mobileAspectRatio: 1.05,
      tabletAspectRatio: 0.95,
      desktopAspectRatio: 0.90,
      shrinkWrap: false,
      physics: const AlwaysScrollableScrollPhysics(),
      children: habits.map((habit) {
        return HabitCard(
          habit: habit,
          onTap: () => onHabitTap?.call(habit),
          onMenuSelected: (action) {
            onMenuSelected?.call(habit, action);
          },
        );
      }).toList(),
    );
  }
}
