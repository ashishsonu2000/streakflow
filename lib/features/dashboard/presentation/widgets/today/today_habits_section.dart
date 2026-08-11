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

    final total = habits.length;
    final completed = habits.where((habit) => habit.completed).length;
    final remaining = total - completed;

    final progress = total == 0
        ? 0.0
        : (completed / total).clamp(0.0, 1.0);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(
              alpha: 0.65,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(
                alpha: 0.035,
              ),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            22,
            20,
            18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================================================
              // HEADER
              // =========================================================

              Row(
                children: [
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

              const SizedBox(height: 18),

              // =========================================================
              // DAILY PROGRESS SUMMARY
              // =========================================================

              if (total > 0)
                _DailyProgressCard(
                  completed: completed,
                  total: total,
                  remaining: remaining,
                  progress: progress,
                ),

              const SizedBox(height: 14),

              // =========================================================
              // HABITS
              // =========================================================

              if (habits.isEmpty)
                const TodayHabitEmpty()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: habits.length,
                  separatorBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                    ),
                    child: Divider(
                      height: 1,
                      color: theme.colorScheme.outlineVariant
                          .withValues(alpha: 0.55),
                    ),
                  ),
                  itemBuilder: (_, index) {
                    final habit = habits[index];

                    return TodayHabitTile(
                      habit: habit,
                      onTap: () {
                        onHabitTap?.call(habit);
                      },
                      onComplete: () {
                        onHabitComplete?.call(habit);
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

  String _subtitle({
    required int total,
    required int remaining,
  }) {
    if (total == 0) {
      return 'No habits scheduled';
    }

    if (remaining == 0) {
      return 'All done';
    }

    return '$remaining ${remaining == 1 ? 'Remaining' : 'Remaining'}';
  }
}

// =====================================================================
// DAILY PROGRESS CARD
// =====================================================================

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
    return Container(
      padding: const EdgeInsets.fromLTRB(
        14,
        12,
        14,
        12,
      ),
      decoration: BoxDecoration(
        // =============================================================
        // LIGHT PREMIUM BACKGROUND
        // =============================================================

        color: const Color(0xFFF1F0FA),
        borderRadius: BorderRadius.circular(17),

        border: Border.all(
          color: const Color(0xFFE6E3F2),
        ),
      ),
      child: Column(
        children: [
          // ===========================================================
          // SUMMARY ROW
          // ===========================================================

          Row(
            children: [
              // -------------------------------------------------------
              // FLAG
              // -------------------------------------------------------

              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFE4E1F8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.flag_rounded,
                  size: 18,
                  color: Color(0xFF5B55D6),
                ),
              ),

              const SizedBox(width: 10),

              // -------------------------------------------------------
              // TEXT
              // -------------------------------------------------------

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$completed of $total completed',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF4F46B8),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      '$remaining '
                          '${remaining == 1 ? 'habit' : 'habits'} '
                          'remaining today',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF77738B),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // -------------------------------------------------------
              // PERCENTAGE
              // -------------------------------------------------------

              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: Color(0xFF4F46B8),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          // ===========================================================
          // PROGRESS BAR
          // ===========================================================

          SizedBox(
            height: 6,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Stack(
                children: [
                  // ---------------------------------------------------
                  // TRACK
                  // ---------------------------------------------------

                  Positioned.fill(
                    child: Container(
                      color: const Color(0xFFDCD9EC),
                    ),
                  ),

                  // ---------------------------------------------------
                  // PROGRESS
                  // ---------------------------------------------------

                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFF5148E8),
                            Color(0xFF6366F1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF5148E8)
                                .withValues(alpha: 0.20),
                            blurRadius: 5,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}