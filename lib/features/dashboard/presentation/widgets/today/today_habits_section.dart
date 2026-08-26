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
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),

          // =========================================================
          // COOL BLUE-GRAY SURFACE
          // =========================================================

          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC),
              Color(0xFFEEF4FA),
            ],
          ),

          // =========================================================
          // NAVY / BLUE BORDER
          // =========================================================

          border: Border.all(
            color: const Color(0xFF2563EB).withValues(
              alpha: 0.24,
            ),
            width: 1.2,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            22,
            20,
            18,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // =====================================================
              // HEADER
              // =====================================================

              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.today_rounded,
                      size: 21,
                      color: Color(0xFF2563EB),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: AppSectionHeader(
                      title: "Today's Habits",
                      subtitle: _subtitle(
                        total: total,
                        remaining: remaining,
                      ),
                      actionText:
                      onViewAll != null
                          ? 'View All'
                          : null,
                      onAction: onViewAll,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

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
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 2,
                      ),
                      child: Divider(
                        height: 1,
                        color: theme
                            .colorScheme
                            .outlineVariant
                            .withValues(
                          alpha: 0.45,
                        ),
                      ),
                    );
                  },
                  itemBuilder: (_, index) {
                    final habit = habits[index];

                    return TodayHabitTile(
                      habit: habit,

                      // Details
                      onTap: () {
                        onHabitTap?.call(habit);
                      },

                      // Complete / Undo
                      onToggle: () {
                        onHabitToggle?.call(habit);
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
      return 'All done 🎉';
    }

    return '$remaining '
        '${remaining == 1 ? 'habit' : 'habits'} '
        'remaining';
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
        13,
        14,
        13,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF0F7FF),
            Color(0xFFF8FAFF),
          ],
        ),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFDCE8F8),
        ),
      ),
      child: Column(
        children: [
          // =========================================================
          // PROGRESS HEADER
          // =========================================================

          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB)
                      .withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.flag_rounded,
                  size: 19,
                  color: Color(0xFF2563EB),
                ),
              ),

              const SizedBox(width: 10),

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
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w700,
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
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // =====================================================
              // PERCENTAGE
              // =====================================================

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius:
                  BorderRadius.circular(999),
                ),
                child: Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // =========================================================
          // PROGRESS BAR
          // =========================================================

          SizedBox(
            height: 7,
            width: double.infinity,
            child: ClipRRect(
              borderRadius:
              BorderRadius.circular(999),
              child: Stack(
                children: [
                  // Background
                  Positioned.fill(
                    child: Container(
                      color: const Color(
                        0xFFDCE7F5,
                      ),
                    ),
                  ),

                  // Progress
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      decoration:
                      const BoxDecoration(
                        gradient:
                        LinearGradient(
                          begin: Alignment
                              .centerLeft,
                          end: Alignment
                              .centerRight,
                          colors: [
                            Color(0xFF1D4ED8),
                            Color(0xFF3B82F6),
                          ],
                        ),
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