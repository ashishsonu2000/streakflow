import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../habits/presentation/pages/habit_detail_page.dart';
import '../providers/calendar_provider.dart';

class SelectedDayCard extends ConsumerWidget {
  const SelectedDayCard({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final calendar = ref.watch(
      calendarProvider,
    );

    return calendar.when(
      loading: () => const SizedBox.shrink(),

      error: (_, __) => const SizedBox.shrink(),

      data: (calendar) {
        final day = calendar.selectedDay;

        if (day == null) {
          return const SizedBox.shrink();
        }

        final progress = day.totalHabits == 0
            ? 0.0
            : day.completedHabits /
            day.totalHabits;

        final theme = Theme.of(context);

        return Card(
          margin: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            16,
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                // =====================================================
                // HEADER
                // =====================================================

                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color:
                      theme.colorScheme.primary,
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Expanded(
                      child: Text(
                        DateFormat.yMMMMEEEEd()
                            .format(day.date),
                        style: theme
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                // =====================================================
                // PROGRESS
                // =====================================================

                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                        child:
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Text(
                      '${(progress * 100).round()}%',
                      style: theme
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(
                  '${day.completedHabits} of '
                      '${day.totalHabits} '
                      'habits completed',
                  style:
                  theme.textTheme.bodyMedium,
                ),

                const SizedBox(
                  height: 24,
                ),

                // =====================================================
                // STATISTICS
                // =====================================================

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _StatChip(
                      icon:
                      Icons.check_circle,
                      label:
                      '${day.completedHabits} Completed',
                    ),

                    _StatChip(
                      icon: Icons.star,
                      label:
                      '${day.totalXP} XP',
                    ),

                    _StatChip(
                      icon: Icons.timer,
                      label:
                      '${day.totalDuration} min',
                    ),

                    if (day.dominantMood != null)
                      _StatChip(
                        icon: Icons
                            .sentiment_satisfied_alt,
                        label:
                        day.dominantMood!.name,
                      ),
                  ],
                ),

                const SizedBox(
                  height: 28,
                ),

                // =====================================================
                // HABITS
                // =====================================================

                Text(
                  'Habits',
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                if (day.habits.isEmpty)
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Center(
                      child: Text(
                        'No activity on this day',
                        style: theme
                            .textTheme
                            .bodyMedium,
                      ),
                    ),
                  )
                else
                  ...day.habits.map(
                        (habit) => Padding(
                      padding:
                      const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: _HabitActivityTile(
                        habit: habit,
                        onTap: () {
                          Navigator.of(
                            context,
                          ).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  HabitDetailPage(
                                    habitId:
                                    habit.id,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ===================================================================
// HABIT ACTIVITY TILE
// ===================================================================

class _HabitActivityTile
    extends StatelessWidget {
  const _HabitActivityTile({
    required this.habit,
    required this.onTap,
  });

  final dynamic habit;
  final VoidCallback onTap;

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme = Theme.of(context);

    final completed =
        habit.completed == true;

    return Card(
      elevation: 0,
      color: theme
          .colorScheme
          .surfaceContainerHighest,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(12),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          child: Row(
            children: [
              // =====================================================
              // STATUS
              // =====================================================

              CircleAvatar(
                radius: 20,
                backgroundColor: completed
                    ? Colors.green.shade100
                    : Colors.grey.shade300,
                child: Icon(
                  completed
                      ? Icons.check
                      : Icons.close,
                  color: completed
                      ? Colors.green
                      : Colors.grey,
                  size: 20,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              // =====================================================
              // TITLE + DETAILS
              // =====================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: theme
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    if (habit.notes
                        .isNotEmpty) ...[
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        habit.notes,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: theme
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          color: theme
                              .colorScheme
                              .outline,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              // =====================================================
              // XP
              // =====================================================

              if (completed)
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.end,
                  children: [
                    Text(
                      '+${habit.xpEarned}',
                      style: theme
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    Text(
                      'XP',
                      style: theme
                          .textTheme
                          .labelSmall
                          ?.copyWith(
                        color: theme
                            .colorScheme
                            .outline,
                      ),
                    ),
                  ],
                ),

              const SizedBox(
                width: 4,
              ),

              Icon(
                Icons.chevron_right_rounded,
                color:
                theme.colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// STAT CHIP
// ===================================================================

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(
      BuildContext context,
      ) {
    return Chip(
      avatar: Icon(
        icon,
        size: 18,
      ),
      label: Text(label),
    );
  }
}