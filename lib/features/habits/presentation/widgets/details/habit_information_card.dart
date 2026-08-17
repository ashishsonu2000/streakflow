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
            value: _format(habit.category.name),
          ),

          AppInfoRow(
            label: 'Frequency',
            value: _format(habit.frequency.name),
          ),

          AppInfoRow(
            label: 'Target',
            value: '${habit.targetPerDay}/day',
          ),

          AppInfoRow(
            label: 'Current Streak',
            value:
            '${habit.currentStreak} '
                '${habit.currentStreak == 1 ? 'day' : 'days'}',
          ),

          AppInfoRow(
            label: 'Best Streak',
            value:
            '${habit.bestStreak} '
                '${habit.bestStreak == 1 ? 'day' : 'days'}',
          ),
        ],
      ),
    );
  }

  String _format(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() +
        value.substring(1);
  }
}