import 'package:flutter/material.dart';

import '../../../../../core/ui/empty/app_empty_state.dart';
import '../../../../../core/ui/layouts/responsive_grid.dart';
import '../../../domain/models/habit_card_view_model.dart';
import '../cards/habit_card.dart';
import 'empty_habits.dart';

class HabitList extends StatelessWidget {
  const HabitList({
    super.key,
    required this.habits,
  });

  final List<HabitCardViewModel> habits;

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      return AppEmptyState(
        icon: Icons.spa,
        title: "Start Your First Habit",
        subtitle: "Consistency begins with one small step.",
        buttonText: "Create Habit",
        onPressed: () {},
      );
    }

    final width = MediaQuery.of(context).size.width;

    int columns = 1;

    if (width >= 1200) {
      columns = 3;
    } else if (width >= 700) {
      columns = 2;
    }

    return ResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 2,
      desktopColumns: 3,
      mobileAspectRatio: 1.05,
      tabletAspectRatio: 0.95,
      desktopAspectRatio: 0.90,
      children: habits
          .map(
            (habit) => HabitCard(
              habit: habit,
            ),
          )
          .toList(),
    );
  }
}
