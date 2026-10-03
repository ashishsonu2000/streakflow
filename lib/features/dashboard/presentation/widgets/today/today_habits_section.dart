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
    this.onHabitToggle,
    this.onViewAll,
  });

  final List<TodayHabitViewModel> habits;

  final ValueChanged<TodayHabitViewModel>? onHabitTap;

  final ValueChanged<TodayHabitViewModel>? onHabitToggle;

  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isDark = theme.brightness == Brightness.dark;

    final total = habits.length;

    final completed = habits
        .where(
          (habit) => habit.completed,
    )
        .length;

    final remaining = total - completed;

    final progress = total == 0
        ? 0.0
        : (completed / total).clamp(
      0.0,
      1.0,
    );

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(24),

          border: Border.all(
            color: colors.outlineVariant.withValues(
              alpha: isDark ? 0.70 : 0.65,
            ),
          ),

          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.20)
                  : colors.primary.withValues(alpha: 0.035),
              blurRadius: isDark ? 16 : 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            18,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =====================================================
              // HEADER
              // =====================================================

              Row(
                children: [
                  // -------------------------------------------------
                  // SECTION ICON
                  // -------------------------------------------------

                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark
                          ? colors.primaryContainer.withValues(
                        alpha: 0.65,
                      )
                          : const Color(0xFFEFF6FF),

                      borderRadius:
                      BorderRadius.circular(12),

                      border: Border.all(
                        color: isDark
                            ? colors.primary.withValues(
                          alpha: 0.25,
                        )
                            : const Color(0xFFDCE8F8),
                      ),
                    ),

                    child: Icon(
                      Icons.today_rounded,
                      size: 21,
                      color: isDark
                          ? colors.primary
                          : const Color(0xFF2563EB),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // -------------------------------------------------
                  // TITLE
                  // -------------------------------------------------

                  Expanded(
                    child: AppSectionHeader(
                      title: "Today's Habits",
                      subtitle: _subtitle(
                        total: total,
                        remaining: remaining,
                      ),
                      actionText: onViewAll != null
                          ? 'View All'
                          : null,
                      onAction: onViewAll,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // =====================================================
              // DAILY PROGRESS
              // =====================================================

              if (total > 0)
                _DailyProgressCard(
                  completed: completed,
                  total: total,
                  remaining: remaining,
                  progress: progress,
                ),

              if (total > 0)
                const SizedBox(height: 14),

              // =====================================================
              // HABITS
              // =====================================================

              if (habits.isEmpty)
                const TodayHabitEmpty()
              else
                ListView.separated(
                  shrinkWrap: true,

                  physics:
                  const NeverScrollableScrollPhysics(),

                  itemCount: habits.length,

                  separatorBuilder: (_, __) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                      ),

                      child: Divider(
                        height: 1,

                        color: colors.outlineVariant
                            .withValues(
                          alpha: isDark ? 0.45 : 0.55,
                        ),
                      ),
                    );
                  },

                  itemBuilder: (_, index) {
                    final habit = habits[index];

                    return TodayHabitTile(
                      habit: habit,

                      // =================================================
                      // OPEN DETAILS
                      // =================================================

                      onTap: () {
                        onHabitTap?.call(
                          habit,
                        );
                      },

                      // =================================================
                      // COMPLETE / UNDO
                      // =================================================

                      onToggle: () {
                        onHabitToggle?.call(
                          habit,
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // SUBTITLE
  // ===============================================================

  String _subtitle({
    required int total,
    required int remaining,
  }) {
    if (total == 0) {
      return 'No habits scheduled';
    }

    if (remaining == 0) {
      return 'All done 🎉';
    }

    return '$remaining '
        '${remaining == 1 ? 'habit' : 'habits'} '
        'remaining';
  }
}

// ===================================================================
// DAILY PROGRESS CARD
// ===================================================================

class _DailyProgressCard extends StatelessWidget {
  const _DailyProgressCard({
    required this.completed,
    required this.total,
    required this.remaining,
    required this.progress,
  });

  final int completed;
  final int total;
  final int remaining;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isDark =
        theme.brightness == Brightness.dark;

    final progressColor = isDark
        ? colors.primary
        : const Color(0xFF2563EB);

    return Container(
      padding: const EdgeInsets.fromLTRB(
        14,
        12,
        14,
        12,
      ),

      decoration: BoxDecoration(
        // ===========================================================
        // BACKGROUND
        // ===========================================================

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
            colors.surfaceContainerHighest.withValues(
              alpha: 0.75,
            ),
            colors.surfaceContainerLow.withValues(
              alpha: 0.90,
            ),
          ]
              : const [
            Color(0xFFF0F7FF),
            Color(0xFFF8FAFF),
          ],
        ),

        borderRadius:
        BorderRadius.circular(17),

        border: Border.all(
          color: isDark
              ? colors.outlineVariant.withValues(
            alpha: 0.65,
          )
              : const Color(0xFFDCE8F8),
        ),
      ),

      child: Column(
        children: [
          // =========================================================
          // SUMMARY ROW
          // =========================================================

          Row(
            children: [
              // -----------------------------------------------------
              // FLAG
              // -----------------------------------------------------

              Container(
                width: 36,
                height: 36,

                decoration: BoxDecoration(
                  color: isDark
                      ? colors.primaryContainer.withValues(
                    alpha: 0.65,
                  )
                      : const Color(0xFFE4E1F8),

                  shape: BoxShape.circle,
                ),

                child: Icon(
                  Icons.flag_rounded,
                  size: 18,
                  color: isDark
                      ? colors.primary
                      : const Color(0xFF5B55D6),
                ),
              ),

              const SizedBox(width: 10),

              // -----------------------------------------------------
              // TEXT
              // -----------------------------------------------------

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Text(
                      '$completed of $total completed',

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? colors.onSurface
                            : const Color(0xFF4F46B8),

                        fontSize: 14,

                        fontWeight:
                        FontWeight.w700,

                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      remaining == 0
                          ? 'Everything is complete!'
                          : '$remaining '
                          '${remaining == 1 ? 'habit' : 'habits'} '
                          'remaining today',

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                        colors.onSurfaceVariant,

                        fontSize: 11,

                        fontWeight:
                        FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // -----------------------------------------------------
              // PERCENTAGE
              // -----------------------------------------------------

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius:
                  BorderRadius.circular(999),
                ),

                child: Text(
                  '${(progress * 100).round()}%',

                  style:
                  theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =========================================================
          // PROGRESS BAR
          // =========================================================

          ClipRRect(
            borderRadius:
            BorderRadius.circular(999),

            child: LinearProgressIndicator(
              value: progress,

              minHeight: 5,

              backgroundColor: isDark
                  ? colors.surfaceContainerHighest
                  : const Color(0xFFDCE8F8),

              valueColor:
              AlwaysStoppedAnimation<Color>(
                progressColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}