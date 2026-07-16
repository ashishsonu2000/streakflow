import 'package:flutter/material.dart';

import '../../../../../core/ui/cards/app_card.dart';
import '../../../../../core/ui/progress/app_progress_bar.dart';
import '../../../domain/models/habit_card_view_model.dart';
import '../actions/habit_popup_menu.dart';
import 'habit_card_footer.dart';
import 'habit_card_header.dart';

import 'habit_stats.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.habit,
    this.onTap,
    this.onMenuSelected,
  });

  final HabitCardViewModel habit;

  final VoidCallback? onTap;

  final ValueChanged<HabitMenuAction>? onMenuSelected;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //------------------------------------------------------
          // Header
          //------------------------------------------------------

          HabitCardHeader(
            habit: habit,
          ),

          const SizedBox(height: 18),

          //------------------------------------------------------
          // Stats
          //------------------------------------------------------

          HabitStats(
            currentStreak: habit.currentStreak,
            xp: habit.xp,
          ),

          const SizedBox(height: 18),

          //------------------------------------------------------
          // Progress
          //------------------------------------------------------

          AppProgressBar(
            value: habit.progress,
            label: "Today's Progress",
          ),

          const SizedBox(height: 18),

          //------------------------------------------------------
          // Footer
          //------------------------------------------------------

          HabitCardFooter(
            xp: habit.xp,
            durationMinutes: habit.durationMinutes,
            onMenuSelected: onMenuSelected ?? (_) {},
          ),
        ],
      ),
    );
  }
}
