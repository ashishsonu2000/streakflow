import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/habit_day_statistics.dart';
import '../../domain/models/habit_month_statistics.dart';
import '../../domain/models/habit_year_day_statistics.dart';
import '../provider/habit_statistics_provider.dart';

class HabitStatisticsPage extends ConsumerWidget {
  const HabitStatisticsPage({
    super.key,
    required this.habitId,
    required this.habitTitle,
  });

  final String habitId;
  final String habitTitle;

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final statisticsAsync =
    ref.watch(habitStatisticsProvider(habitId));

    return Scaffold(
      appBar: AppBar(
        title: Text(habitTitle),
      ),
      body: statisticsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Unable to load statistics',
                ),
                const SizedBox(height: 8),
                Text(
                  '$error',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    ref.invalidate(
                      habitStatisticsProvider(habitId),
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (statistics) {
          if (statistics == null) {
            return const Center(
              child: Text(
                'Habit not found',
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(
                habitStatisticsProvider(habitId),
              );

              await ref.read(
                habitStatisticsProvider(habitId).future,
              );
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _StreakSection(
                  currentStreak:
                  statistics.currentStreak,
                  bestStreak:
                  statistics.bestStreak,
                ),

                const SizedBox(height: 16),

                _ProgressSection(
                  completionRate:
                  statistics.completionRate,
                  successRate:
                  statistics.successRate,
                ),

                const SizedBox(height: 16),

                _ActivitySection(
                  totalCompleted:
                  statistics.totalCompleted,
                  totalMissed:
                  statistics.totalMissed,
                  totalTrackedDays:
                  statistics.totalTrackedDays,
                  activeDays:
                  statistics.activeDays,
                ),

                const SizedBox(height: 16),

                _PerformanceSection(
                  averagePerWeek:
                  statistics.averagePerWeek,
                  longestGap:
                  statistics.longestGap,
                ),

                const SizedBox(height: 16),
                _WeeklyProgressSection(
                  days: statistics.weeklyProgress,
                ),
                const SizedBox(height: 16),
                _MonthlyProgressSection(
                  days: statistics.monthlyProgress,
                ),
                const SizedBox(height: 16),
                _YearlyHeatmapSection(
                  days: statistics.yearlyProgress,
                ),

                const SizedBox(height: 16),
                _XpSection(
                  totalXP: statistics.totalXP,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// =========================================================
// Streak Section
// =========================================================

class _StreakSection extends StatelessWidget {
  const _StreakSection({
    required this.currentStreak,
    required this.bestStreak,
  });

  final int currentStreak;
  final int bestStreak;

  @override
  Widget build(BuildContext context) {
    return _StatisticsCard(
      title: 'Streak',
      icon: Icons.local_fire_department,
      child: Row(
        children: [
          Expanded(
            child: _BigMetric(
              icon: Icons.local_fire_department,
              label: 'Current Streak',
              value: '$currentStreak',
              suffix: 'days',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _BigMetric(
              icon: Icons.emoji_events_outlined,
              label: 'Best Streak',
              value: '$bestStreak',
              suffix: 'days',
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// Progress Section
// =========================================================

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.completionRate,
    required this.successRate,
  });

  final double completionRate;
  final double successRate;

  @override
  Widget build(BuildContext context) {
    return _StatisticsCard(
      title: 'Progress',
      icon: Icons.trending_up,
      child: Column(
        children: [
          _ProgressMetric(
            label: 'Completion Rate',
            value: completionRate,
          ),
          const SizedBox(height: 20),
          _ProgressMetric(
            label: 'Success Rate',
            value: successRate,
          ),
        ],
      ),
    );
  }
}

// =========================================================
// Activity Section
// =========================================================

class _ActivitySection extends StatelessWidget {
  const _ActivitySection({
    required this.totalCompleted,
    required this.totalMissed,
    required this.totalTrackedDays,
    required this.activeDays,
  });

  final int totalCompleted;
  final int totalMissed;
  final int totalTrackedDays;
  final int activeDays;

  @override
  Widget build(BuildContext context) {
    return _StatisticsCard(
      title: 'Activity',
      icon: Icons.check_circle_outline,
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 20,
        crossAxisSpacing: 12,
        childAspectRatio: 2.2,
        children: [
          _SmallMetric(
            label: 'Completed',
            value: '$totalCompleted',
          ),
          _SmallMetric(
            label: 'Missed',
            value: '$totalMissed',
          ),
          _SmallMetric(
            label: 'Tracked Days',
            value: '$totalTrackedDays',
          ),
          _SmallMetric(
            label: 'Active Days',
            value: '$activeDays',
          ),
        ],
      ),
    );
  }
}

// =========================================================
// Performance Section
// =========================================================

class _PerformanceSection extends StatelessWidget {
  const _PerformanceSection({
    required this.averagePerWeek,
    required this.longestGap,
  });

  final double averagePerWeek;
  final int longestGap;

  @override
  Widget build(BuildContext context) {
    return _StatisticsCard(
      title: 'Performance',
      icon: Icons.analytics_outlined,
      child: Row(
        children: [
          Expanded(
            child: _SmallMetric(
              label: 'Average / Week',
              value: averagePerWeek.toStringAsFixed(1),
            ),
          ),
          Expanded(
            child: _SmallMetric(
              label: 'Longest Gap',
              value: '$longestGap days',
            ),
          ),
        ],
      ),
    );
  }
}


class _MonthlyProgressSection extends StatelessWidget {
  const _MonthlyProgressSection({
    required this.days,
  });

  final List<HabitMonthStatistics> days;

  @override
  Widget build(BuildContext context) {
    final activeDays = days
        .where((day) => day.isWithinHabitRange)
        .toList();

    final completedDays = activeDays
        .where((day) => day.completed)
        .length;

    final percentage = activeDays.isEmpty
        ? 0.0
        : completedDays / activeDays.length * 100;

    return _StatisticsCard(
      title: 'Monthly Progress',
      icon: Icons.calendar_month_outlined,
      child: Column(
        children: [
          Row(
            children: [
              _MonthMetric(
                label: 'Completed',
                value: '$completedDays',
              ),
              _MonthMetric(
                label: 'Active',
                value: '${activeDays.length}',
              ),
              _MonthMetric(
                label: 'Progress',
                value:
                '${percentage.toStringAsFixed(0)}%',
              ),
            ],
          ),

          const SizedBox(height: 20),

          _MonthCalendar(
            days: days,
          ),
        ],
      ),
    );
  }
}

class _MonthMetric extends StatelessWidget {
  const _MonthMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall,
          ),
        ],
      ),
    );
  }
}

class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({
    required this.days,
  });

  final List<HabitMonthStatistics> days;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return const SizedBox.shrink();
    }

    final firstWeekday =
        days.first.date.weekday;

    final leading =
        firstWeekday - DateTime.monday;

    final items = <Widget>[];

    for (var i = 0; i < leading; i++) {
      items.add(
        const SizedBox.shrink(),
      );
    }

    for (final day in days) {
      items.add(
        _MonthDay(
          day: day,
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: items,
    );
  }
}

class _MonthDay extends StatelessWidget {
  const _MonthDay({
    required this.day,
  });

  final HabitMonthStatistics day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isToday = _sameDay(
      day.date,
      DateTime.now(),
    );

    Color? background;

    if (day.isWithinHabitRange) {
      background = day.completed
          ? theme.colorScheme.primary
          : theme.colorScheme
          .surfaceContainerHighest;
    }

    return Container(
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: isToday
            ? Border.all(
          color:
          theme.colorScheme.primary,
          width: 2,
        )
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.date.day}',
        style: theme.textTheme.labelSmall,
      ),
    );
  }

  bool _sameDay(
      DateTime a,
      DateTime b,
      ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}


class _WeeklyProgressSection extends StatelessWidget {
  const _WeeklyProgressSection({
    required this.days,
  });

  final List<HabitDayStatistics> days;

  @override
  Widget build(BuildContext context) {
    final completed = days
        .where((day) => day.completed)
        .length;

    final percentage = days.isEmpty
        ? 0.0
        : completed / days.length * 100;

    return _StatisticsCard(
      title: 'Weekly Progress',
      icon: Icons.calendar_view_week_outlined,
      child: Column(
        children: [
          Row(
            children: days.map((day) {
              return Expanded(
                child: _WeekDay(
                  day: day,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completed / ${days.length} completed',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium,
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          LinearProgressIndicator(
            value: (percentage / 100)
                .clamp(0.0, 1.0),
            minHeight: 8,
            borderRadius:
            BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}


class _WeekDay extends StatelessWidget {
  const _WeekDay({
    required this.day,
  });

  final HabitDayStatistics day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final weekday = switch (day.date.weekday) {
      DateTime.monday => 'M',
      DateTime.tuesday => 'T',
      DateTime.wednesday => 'W',
      DateTime.thursday => 'T',
      DateTime.friday => 'F',
      DateTime.saturday => 'S',
      DateTime.sunday => 'S',
      _ => '',
    };

    final isToday = _sameDay(
      day.date,
      DateTime.now(),
    );

    return Column(
      children: [
        Text(
          weekday,
          style: theme.textTheme.labelMedium,
        ),

        const SizedBox(height: 8),

        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: day.completed
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            border: isToday
                ? Border.all(
              color: theme.colorScheme.primary,
              width: 2,
            )
                : null,
          ),
          child: Icon(
            day.completed
                ? Icons.check_rounded
                : Icons.remove_rounded,
            size: 20,
            color: day.completed
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.outline,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          '${day.date.day}',
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }

  bool _sameDay(
      DateTime a,
      DateTime b,
      ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}

// =========================================================
// Yearly Activity
// =========================================================

class _YearlyHeatmapSection extends StatelessWidget {
  const _YearlyHeatmapSection({
    required this.days,
  });

  final List<HabitYearDayStatistics> days;

  @override
  Widget build(BuildContext context) {
    final activeDays = days
        .where(
          (day) => day.isWithinHabitRange,
    )
        .toList();

    final completedDays = activeDays
        .where(
          (day) => day.completed,
    )
        .length;

    return _StatisticsCard(
      title: 'Year Activity',
      icon: Icons.grid_view_rounded,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            completedDays == 1
                ? '1 completed day'
                : '$completedDays completed days',
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),

          const SizedBox(height: 16),

          _YearHeatmap(
            days: days,
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.end,
            children: [
              Text(
                'Less',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall,
              ),

              const SizedBox(width: 5),

              _HeatmapLegend(
                level: 0,
              ),

              const SizedBox(width: 3),

              _HeatmapLegend(
                level: 1,
              ),

              const SizedBox(width: 3),

              _HeatmapLegend(
                level: 2,
              ),

              const SizedBox(width: 3),

              _HeatmapLegend(
                level: 3,
              ),

              const SizedBox(width: 5),

              Text(
                'More',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =========================================================
// Year Heatmap
// =========================================================

// =========================================================
// Year Heatmap
// =========================================================

// =========================================================
// Year Heatmap
// =========================================================

// =========================================================
// Year Heatmap
// =========================================================

class _YearHeatmap extends StatelessWidget {
  const _YearHeatmap({
    required this.days,
  });

  final List<HabitYearDayStatistics> days;

  static const double cellGap = 2;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const weekCount = 53;

        final cellSize =
            (constraints.maxWidth -
                (cellGap * (weekCount - 1))) /
                weekCount;

        final safeCellSize =
        cellSize.clamp(3.0, 7.0);

        final dayMap =
        <DateTime, HabitYearDayStatistics>{
          for (final day in days)
            _dateOnly(day.date): day,
        };

        final firstDate =
        _dateOnly(days.first.date);

        final lastDate =
        _dateOnly(days.last.date);

        final gridStart =
        firstDate.subtract(
          Duration(
            days:
            firstDate.weekday -
                DateTime.monday,
          ),
        );

        final totalDays =
            lastDate
                .difference(gridStart)
                .inDays +
                1;

        final actualWeekCount =
        (totalDays / 7).ceil();

        return Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // =====================================================
            // MONTH LABELS
            // =====================================================

            SizedBox(
              height: 18,
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: _monthLabels(
                  context,
                ),
              ),
            ),

            const SizedBox(height: 4),

            // =====================================================
            // YEAR GRID
            // =====================================================

            SizedBox(
              height:
              (safeCellSize * 7) +
                  (cellGap * 6),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: List.generate(
                  actualWeekCount,
                      (weekIndex) {
                    final weekStart =
                    gridStart.add(
                      Duration(
                        days:
                        weekIndex * 7,
                      ),
                    );

                    return Padding(
                      padding: EdgeInsets.only(
                        right:
                        weekIndex ==
                            actualWeekCount -
                                1
                            ? 0
                            : cellGap,
                      ),
                      child: Column(
                        children:
                        List.generate(
                          7,
                              (dayIndex) {
                            final date =
                            weekStart.add(
                              Duration(
                                days:
                                dayIndex,
                              ),
                            );

                            final day =
                            dayMap[date];

                            return Padding(
                              padding:
                              EdgeInsets.only(
                                bottom:
                                dayIndex == 6
                                    ? 0
                                    : cellGap,
                              ),
                              child:
                              _HeatmapDay(
                                day: day,
                                size:
                                safeCellSize,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _monthLabels(
      BuildContext context,
      ) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months
        .map(
          (month) => Text(
        month,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(
          fontSize: 8,
          color: Theme.of(context)
              .colorScheme
              .outline,
        ),
      ),
    )
        .toList();
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }
}

// =========================================================
// Heatmap Day
// =========================================================

// =========================================================
// Heatmap Day
// =========================================================

// =========================================================
// Heatmap Day
// =========================================================

// =========================================================
// Heatmap Day
// =========================================================

class _HeatmapDay extends StatelessWidget {
  const _HeatmapDay({
    required this.day,
    required this.size,
  });

  final HabitYearDayStatistics? day;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (day == null) {
      return SizedBox(
        width: size,
        height: size,
      );
    }

    if (!day!.isWithinHabitRange) {
      return SizedBox(
        width: size,
        height: size,
      );
    }

    final background = day!.completed
        ? theme.colorScheme.primary
        : theme.colorScheme
        .surfaceContainerHighest;

    return Tooltip(
      message: _tooltipText(day!),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background,
          borderRadius:
          BorderRadius.circular(1.5),
        ),
      ),
    );
  }

  String _tooltipText(
      HabitYearDayStatistics day,
      ) {
    final date = day.date;

    final formatted =
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';

    return day.completed
        ? '$formatted • Completed'
        : '$formatted • Not completed';
  }
}

// =========================================================
// Heatmap Legend
// =========================================================

class _HeatmapLegend extends StatelessWidget {
  const _HeatmapLegend({
    required this.level,
  });

  final int level;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color color;

    switch (level) {
      case 1:
        color = theme.colorScheme.primary
            .withValues(alpha: 0.35);
        break;

      case 2:
        color = theme.colorScheme.primary
            .withValues(alpha: 0.65);
        break;

      case 3:
        color = theme.colorScheme.primary;
        break;

      default:
        color = theme.colorScheme
            .surfaceContainerHighest;
    }

    return Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(
        color: color,
        borderRadius:
        BorderRadius.circular(3),
      ),
    );
  }
}
// =========================================================
// XP Section
// =========================================================

class _XpSection extends StatelessWidget {
  const _XpSection({
    required this.totalXP,
  });

  final int totalXP;

  @override
  Widget build(BuildContext context) {
    return _StatisticsCard(
      title: 'Experience',
      icon: Icons.bolt,
      child: Row(
        children: [
          const Icon(
            Icons.bolt,
            size: 42,
          ),
          const SizedBox(width: 16),
          Text(
            '$totalXP XP',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// Statistics Card
// =========================================================

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

// =========================================================
// Big Metric
// =========================================================

class _BigMetric extends StatelessWidget {
  const _BigMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.suffix,
  });

  final IconData icon;
  final String label;
  final String value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          icon,
          size: 30,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.displaySmall
              ?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          suffix,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

// =========================================================
// Small Metric
// =========================================================

class _SmallMetric extends StatelessWidget {
  const _SmallMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge
              ?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

// =========================================================
// Progress Metric
// =========================================================

class _ProgressMetric extends StatelessWidget {
  const _ProgressMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final normalized =
    (value / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              '${value.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: normalized,
          minHeight: 8,
          borderRadius:
          BorderRadius.circular(8),
        ),
      ],
    );
  }
}