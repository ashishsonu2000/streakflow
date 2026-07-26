import 'package:flutter/material.dart';

import '../../../../../core/ui/spacing/app_spacing.dart';

import '../../../../../core/widgets/app_card.dart';
import '../../../domain/models/habit.dart';

import '../actions/habit_popup_menu.dart';
import 'habit_card_actions.dart';
import 'habit_card_footer.dart';
import 'habit_card_header.dart';
import 'habit_card_metadata.dart';
import 'habit_card_progress.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onComplete,
    required this.onMenuSelected,
  });

  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onComplete;
  final ValueChanged<HabitMenuAction> onMenuSelected;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HabitCardHeader(
            habit: habit,
            onMenuSelected: onMenuSelected,
          ),
          const Gap.vertical(AppSpacing.lg),
          HabitCardMetadata(habit: habit),
          const Gap.vertical(AppSpacing.lg),
          HabitCardProgress(habit: habit),
          const Gap.vertical(AppSpacing.lg),
          HabitCardFooter(habit: habit),
          const Gap.vertical(AppSpacing.xl),
          HabitCardActions(
            habit: habit,
            onComplete: onComplete,
            onDetails: onTap,
          ),
        ],
      ),
    );
  }
}
