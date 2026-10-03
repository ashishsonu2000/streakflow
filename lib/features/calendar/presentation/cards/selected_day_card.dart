import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../habits/presentation/pages/habit_detail_page.dart';
import '../../domain/models/day_habit_view_model.dart';
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
    final calendarAsync = ref.watch(
      calendarProvider,
    );

    return calendarAsync.when(
      loading: () =>
      const SizedBox.shrink(),

      error: (_, __) =>
      const SizedBox.shrink(),

      data: (calendar) {
        final day =
            calendar.selectedDay;

        if (day == null) {
          return const SizedBox.shrink();
        }

        final theme =
        Theme.of(context);

        final colors =
            theme.colorScheme;

        final isDark =
            theme.brightness ==
                Brightness.dark;

        final progress =
        day.totalHabits == 0
            ? 0.0
            : (day.completedHabits /
            day.totalHabits)
            .clamp(0.0, 1.0);

        return Container(
          margin:
          const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            16,
          ),

          padding:
          const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: isDark
                ? colors.surfaceContainerLow
                : const Color(0xFFF9FBFE),

            borderRadius:
            BorderRadius.circular(20),

            border: Border.all(
              color: isDark
                  ? colors.outlineVariant
                  .withValues(
                alpha: 0.75,
              )
                  : const Color(0xFFBDD4F2),
              width: 1,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(
                  alpha:
                  isDark ? 0.18 : 0.045,
                ),
                blurRadius: 14,
                offset:
                const Offset(0, 4),
              ),
            ],
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
                  _IconContainer(
                    icon:
                    Icons
                        .calendar_month_rounded,
                    color:
                    colors.primary,
                    background: isDark
                        ? colors.primary
                        .withValues(
                      alpha: 0.14,
                    )
                        : const Color(
                      0xFFEFF6FF,
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: Text(
                      DateFormat
                          .yMMMMEEEEd()
                          .format(
                        day.date,
                      ),

                      maxLines: 2,

                      overflow:
                      TextOverflow
                          .ellipsis,

                      style: theme
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        color:
                        colors.onSurface,
                        fontSize: 17,
                        fontWeight:
                        FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 18,
              ),

              // =====================================================
              // PROGRESS
              // =====================================================

              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius
                          .circular(
                        999,
                      ),

                      child:
                      LinearProgressIndicator(
                        value:
                        progress,

                        minHeight: 9,

                        backgroundColor:
                        isDark
                            ? colors
                            .surfaceContainerHighest
                            : const Color(
                          0xFFE2E8F0,
                        ),

                        valueColor:
                        AlwaysStoppedAnimation<
                            Color>(
                          colors.primary,
                        ),
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
                        .titleSmall
                        ?.copyWith(
                      color:
                      colors.onSurface,
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 7,
              ),

              Text(
                '${day.completedHabits} of '
                    '${day.totalHabits} '
                    'habits completed',

                style: theme
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  color:
                  colors.onSurfaceVariant,
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w500,
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              // =====================================================
              // STATISTICS
              // =====================================================

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _StatPill(
                    icon:
                    Icons
                        .check_circle_rounded,
                    label:
                    '${day.completedHabits} Completed',
                    color:
                    const Color(
                        0xFF16A34A),
                    background:
                    isDark
                        ? const Color(
                      0xFF0D3322,
                    )
                        : const Color(
                      0xFFECFDF5,
                    ),
                  ),

                  _StatPill(
                    icon:
                    Icons.star_rounded,
                    label:
                    '${day.totalXP} XP',
                    color:
                    const Color(
                        0xFFD97706),
                    background:
                    isDark
                        ? const Color(
                      0xFF3A2810,
                    )
                        : const Color(
                      0xFFFFF7ED,
                    ),
                  ),

                  _StatPill(
                    icon:
                    Icons.timer_rounded,
                    label:
                    '${day.totalDuration} min',
                    color:
                    const Color(
                        0xFF2563EB),
                    background:
                    isDark
                        ? const Color(
                      0xFF102A4C,
                    )
                        : const Color(
                      0xFFEFF6FF,
                    ),
                  ),

                  if (day.dominantMood !=
                      null)
                    _StatPill(
                      icon: Icons
                          .sentiment_satisfied_alt_rounded,
                      label:
                      day.dominantMood!
                          .name,
                      color:
                      const Color(
                          0xFF7C3AED),
                      background:
                      isDark
                          ? const Color(
                        0xFF29184A,
                      )
                          : const Color(
                        0xFFF3E8FF,
                      ),
                    ),
                ],
              ),

              const SizedBox(
                height: 22,
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
                  color:
                  colors.onSurface,
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              if (day.habits.isEmpty)
                const _EmptyDayState()
              else
                ...day.habits.map(
                      (habit) => Padding(
                    padding:
                    const EdgeInsets.only(
                      bottom: 8,
                    ),

                    child:
                    _HabitActivityTile(
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
        );
      },
    );
  }
}

// =====================================================================
// ICON CONTAINER
// =====================================================================

class _IconContainer
    extends StatelessWidget {
  const _IconContainer({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      width: 42,
      height: 42,

      decoration: BoxDecoration(
        color: background,
        borderRadius:
        BorderRadius.circular(13),
      ),

      child: Icon(
        icon,
        size: 21,
        color: color,
      ),
    );
  }
}

// =====================================================================
// STAT PILL
// =====================================================================

class _StatPill
    extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),

      decoration: BoxDecoration(
        color: background,
        borderRadius:
        BorderRadius.circular(999),
      ),

      child: Row(
        mainAxisSize:
        MainAxisSize.min,

        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),

          const SizedBox(
            width: 5,
          ),

          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight:
              FontWeight.w600,
            ).copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// EMPTY STATE
// =====================================================================

class _EmptyDayState
    extends StatelessWidget {
  const _EmptyDayState();

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    final isDark =
        theme.brightness ==
            Brightness.dark;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 12,
      ),

      decoration: BoxDecoration(
        color: isDark
            ? colors.surfaceContainerHighest
            .withValues(
          alpha: 0.55,
        )
            : const Color(
          0xFFF1F5F9,
        ),

        borderRadius:
        BorderRadius.circular(14),

        border: isDark
            ? Border.all(
          color: colors
              .outlineVariant
              .withValues(
            alpha: 0.45,
          ),
        )
            : null,
      ),

      child: Text(
        'No activity on this day',

        textAlign:
        TextAlign.center,

        style: theme
            .textTheme
            .bodySmall
            ?.copyWith(
          color:
          colors.onSurfaceVariant,
          fontSize: 13,
          fontWeight:
          FontWeight.w500,
        ),
      ),
    );
  }
}

// =====================================================================
// HABIT ACTIVITY TILE
// =====================================================================

class _HabitActivityTile
    extends StatelessWidget {
  const _HabitActivityTile({
    required this.habit,
    required this.onTap,
  });

  final DayHabitViewModel habit;
  final VoidCallback onTap;

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    final isDark =
        theme.brightness ==
            Brightness.dark;

    final completed =
        habit.completed == true;

    final statusColor = completed
        ? const Color(0xFF16A34A)
        : colors.onSurfaceVariant;

    final statusBackground = completed
        ? (isDark
        ? const Color(0xFF0D3322)
        : const Color(0xFFECFDF5))
        : (isDark
        ? colors.surfaceContainerHighest
        : const Color(0xFFF1F5F9));

    return Material(
      color:
      Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius:
        BorderRadius.circular(14),

        child: Container(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 11,
          ),

          decoration: BoxDecoration(
            color: isDark
                ? colors.surfaceContainerHighest
                .withValues(
              alpha: 0.48,
            )
                : const Color(
              0xFFF8FAFC,
            ),

            borderRadius:
            BorderRadius.circular(
              14,
            ),

            border: Border.all(
              color: isDark
                  ? colors.outlineVariant
                  .withValues(
                alpha: 0.65,
              )
                  : const Color(
                0xFFE2E8F0,
              ),
            ),
          ),

          child: Row(
            children: [
              // =======================================================
              // STATUS ICON
              // =======================================================

              Container(
                width: 36,
                height: 36,

                decoration:
                BoxDecoration(
                  color:
                  statusBackground,
                  shape:
                  BoxShape.circle,
                ),

                child: Icon(
                  completed
                      ? Icons.check_rounded
                      : Icons.close_rounded,

                  size: 19,

                  color:
                  statusColor,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              // =======================================================
              // TITLE / NOTES
              // =======================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [
                    Text(
                      habit.title,

                      maxLines: 1,

                      overflow:
                      TextOverflow
                          .ellipsis,

                      style: theme
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        color:
                        colors.onSurface,
                        fontSize: 14,
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
                        TextOverflow
                            .ellipsis,

                        style: theme
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          color: colors
                              .onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // =======================================================
              // XP
              // =======================================================

              if (completed) ...[
                const SizedBox(
                  width: 8,
                ),

                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .end,

                  children: [
                    Text(
                      '+${habit.xpEarned}',

                      style: theme
                          .textTheme
                          .labelLarge
                          ?.copyWith(
                        color:
                        const Color(
                          0xFF22C55E,
                        ),
                        fontSize: 13,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    Text(
                      'XP',

                      style: theme
                          .textTheme
                          .labelSmall
                          ?.copyWith(
                        color: colors
                            .onSurfaceVariant,
                        fontSize: 10,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(
                width: 4,
              ),

              Icon(
                Icons
                    .chevron_right_rounded,

                size: 21,

                color:
                colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}