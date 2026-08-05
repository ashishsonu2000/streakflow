import 'package:flutter/material.dart';

import '../../../../../shared/ui/cards/app_section_card.dart';
import '../../../../../shared/widgets/row/app_info_row.dart';

import '../../../domain/models/habit.dart';

class HabitInformation extends StatelessWidget {
  const HabitInformation({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: 'Information',
      child: Column(
        children: [
          AppInfoRow(
            label: 'Category',
            value: habit.category.name,
          ),
          AppInfoRow(
            label: 'Frequency',
            value: habit.frequency.name,
          ),
          AppInfoRow(
            label: 'Target',
            value: '${habit.targetPerDay}/day',
          ),
          AppInfoRow(
            label: 'Current Streak',
            value: '${habit.currentStreak}',
          ),
          AppInfoRow(
            label: 'Best Streak',
            value: '${habit.bestStreak}',
          ),
        ],
      ),
    );
  }
}
