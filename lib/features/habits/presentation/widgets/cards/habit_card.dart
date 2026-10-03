import 'package:flutter/material.dart';

import '../../../../../core/ui/spacing/app_spacing.dart';

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
    required this.onMenuSelected,
  });

  final Habit habit;

  final VoidCallback onTap;
  final VoidCallback onComplete;
  final VoidCallback onUndo;
  final ValueChanged<HabitMenuAction> onMenuSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final completed = habit.completedToday;
    final isDark = theme.brightness == Brightness.dark;

    // ===============================================================
    // THEME-AWARE CARD COLORS
    // ===============================================================

    final List<Color> backgroundGradient;

    final Color borderColor;

    final Color shadowColor;

    if (isDark) {
      if (completed) {
        backgroundGradient = [
          colors.surfaceContainerLow,
          Color.alphaBlend(
            colors.primary.withValues(
              alpha: 0.07,
            ),
            colors.surfaceContainerLow,
          ),
        ];

        borderColor = colors.primary.withValues(
          alpha: 0.38,
        );
      } else {
        backgroundGradient = [
          colors.surfaceContainerLow,
          colors.surface,
        ];

        borderColor = colors.outlineVariant;
      }

      shadowColor = Colors.black.withValues(
        alpha: 0.28,
      );
    } else {
      if (completed) {
        backgroundGradient = const [
          Color(0xFFF8FAFC),
          Color(0xFFF0FDF4),
        ];

        borderColor = const Color(0xFFBBF7D0);
      } else {
        backgroundGradient = const [
          Color(0xFFFFFFFF),
          Color(0xFFF8FAFC),
        ];

        borderColor = const Color(0xFFBFDBFE);
      }

      shadowColor = const Color(0xFF172554).withValues(
        alpha: 0.055,
      );
    }

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 220,
      ),
      curve: Curves.easeOutCubic,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          20,
        ),

        // ===========================================================
        // THEME-AWARE CARD BACKGROUND
        // ===========================================================

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: backgroundGradient,
        ),

        // ===========================================================
        // THEME-AWARE BORDER
        // ===========================================================

        border: Border.all(
          color: borderColor,
          width: 1.1,
        ),

        // ===========================================================
        // THEME-AWARE SHADOW
        // ===========================================================

        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: isDark ? 18 : 14,
            offset: const Offset(
              0,
              6,
            ),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: onTap,

          borderRadius: BorderRadius.circular(
            20,
          ),

          splashColor: colors.primary.withValues(
            alpha: 0.08,
          ),

          highlightColor: colors.primary.withValues(
            alpha: 0.04,
          ),

          child: Padding(
            padding: const EdgeInsets.all(
              16,
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                // =====================================================
                // HEADER
                // =====================================================

                HabitCardHeader(
                  habit: habit,
                  onMenuSelected: onMenuSelected,
                ),

                const Gap.vertical(
                  AppSpacing.lg,
                ),

                // =====================================================
                // METADATA
                // =====================================================

                HabitCardMetadata(
                  habit: habit,
                ),

                const Gap.vertical(
                  AppSpacing.lg,
                ),

                // =====================================================
                // PROGRESS
                // =====================================================

                HabitCardProgress(
                  habit: habit,
                ),

                const Gap.vertical(
                  AppSpacing.lg,
                ),

                // =====================================================
                // STATS
                // =====================================================

                HabitCardFooter(
                  habit: habit,
                ),

                const Gap.vertical(
                  AppSpacing.xl,
                ),

                // =====================================================
                // ACTIONS
                // =====================================================

                HabitCardActions(
                  habit: habit,
                  onComplete: onComplete,
                  onUndo: onUndo,
                  onDetails: onTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}