import 'package:flutter/material.dart';

import '../../../../../core/ui/spacing/app_spacing.dart';
import '../../../../../shared/ui/cards/app_card.dart';
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
    required this.onUndo,
    required this.onStatistics,
    required this.onMenuSelected,
  });

  final Habit habit;

  /// Tapping the card opens the existing Habit Details page.
  final VoidCallback onTap;

  /// Complete today's habit.
  final VoidCallback onComplete;

  /// Undo today's completion.
  final VoidCallback onUndo;

  /// Opens the Habit Statistics page.
  final VoidCallback onStatistics;

  /// Popup menu actions.
  final ValueChanged<HabitMenuAction> onMenuSelected;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // =========================================================
            // HEADER
            // =========================================================

            HabitCardHeader(
              habit: habit,
              onMenuSelected: onMenuSelected,
            ),

            const Gap.vertical(
              AppSpacing.lg,
            ),

            // =========================================================
            // METADATA
            // =========================================================

            HabitCardMetadata(
              habit: habit,
            ),

            const Gap.vertical(
              AppSpacing.lg,
            ),

            // =========================================================
            // PROGRESS
            // =========================================================

            HabitCardProgress(
              habit: habit,
            ),

            const Gap.vertical(
              AppSpacing.lg,
            ),

            // =========================================================
            // STATS
            // =========================================================

            HabitCardFooter(
              habit: habit,
            ),

            const Gap.vertical(
              AppSpacing.xl,
            ),

            // =========================================================
            // ACTIONS
            // =========================================================

            HabitCardActions(
              habit: habit,
              onComplete: onComplete,
              onUndo: onUndo,
              onDetails: onStatistics,
            ),
          ],
        ),
      ),
    );
  }
}