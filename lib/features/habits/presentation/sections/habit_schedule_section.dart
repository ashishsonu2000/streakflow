import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../shared/ui/layouts/layouts.dart';

import '../widgets/habit_category_selector.dart';
import '../widgets/habit_duration_tile.dart';
import '../widgets/habit_frequency_selector.dart';
import '../widgets/habit_reminder_tile.dart';
import '../widgets/habit_target_selector.dart';

class HabitScheduleSection extends StatelessWidget {
  const HabitScheduleSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const AppSection(
      title: 'Schedule',
      subtitle:
      'Configure how this habit should be tracked.',
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          HabitCategorySelector(),

          SizedBox(
            height: AppSpacing.lg,
          ),

          HabitFrequencySelector(),

          SizedBox(
            height: AppSpacing.lg,
          ),

          HabitTargetSelector(),

          SizedBox(
            height: AppSpacing.lg,
          ),

          HabitDurationTile(),

          SizedBox(
            height: AppSpacing.lg,
          ),

          HabitReminderTile(),
        ],
      ),
    );
  }
}