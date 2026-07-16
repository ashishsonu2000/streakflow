import 'package:flutter/material.dart';

import '../../../../../core/ui/section/app_section_header.dart';
import '../../../domain/models/today_habit_view_model.dart';

import 'today_habit_empty.dart';
import 'today_habit_tile.dart';

class TodayHabitsSection extends StatelessWidget {
  const TodayHabitsSection({
    super.key,
    required this.habits,
    this.onHabitTap,
    this.onHabitComplete,
    this.onViewAll,
  });

  final List<TodayHabitViewModel> habits;

  final ValueChanged<TodayHabitViewModel>? onHabitTap;
  final ValueChanged<TodayHabitViewModel>? onHabitComplete;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            //------------------------------------------------
            // Header
            //------------------------------------------------

            Row(
              children: [
                Expanded(
                    child: AppSectionHeader(
                  title: "Today's Habits",
                  subtitle:
                      "${habits.where((e) => !e.completed).length} Remaining",
                  actionText: "View All",
                  onAction: () {},
                )),
              ],
            ),

            const SizedBox(height: 24),

            //------------------------------------------------
            // Empty State
            //------------------------------------------------

            if (habits.isEmpty)
              const TodayHabitEmpty()
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: habits.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 28,
                ),
                itemBuilder: (_, index) {
                  final habit = habits[index];

                  return TodayHabitTile(
                    habit: habit,
                    onTap: () => onHabitTap?.call(habit),
                    onComplete: () => onHabitComplete?.call(habit),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
