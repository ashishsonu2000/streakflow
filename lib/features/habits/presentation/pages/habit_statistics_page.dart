import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/habit_statistics.dart';
import '../provider/habit_providers.dart';
import '../provider/habit_statistics_provider.dart';

class HabitStatisticsPage extends ConsumerStatefulWidget {
  const HabitStatisticsPage({
    super.key,
    required this.habitId,
    required this.habitTitle,
  });

  final String habitId;
  final String habitTitle;

  @override
  ConsumerState<HabitStatisticsPage> createState() =>
      _HabitStatisticsPageState();
}

class _HabitStatisticsPageState
    extends ConsumerState<HabitStatisticsPage> {
  // =============================================================
  // VIEW
  // =============================================================

  /// 0 = Overview
  /// 1 = Week
  /// 2 = Month
  /// 3 = Year
  int _selectedView = 0;

  DateTime _selectedDate = DateTime.now();

  // =============================================================
  // QUERY
  // =============================================================

  HabitStatisticsQuery get _statisticsQuery {
    return HabitStatisticsQuery(
      habitId: widget.habitId,
      date: _dateOnly(_selectedDate),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final habitAsync = ref.watch(
      habitProvider(widget.habitId),
    );

    final statisticsAsync = ref.watch(
      habitStatisticsProvider(
        _statisticsQuery,
      ),
    );

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(
          widget.habitTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: habitAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stack) {
          return _ErrorState(
            error: error,
            onRetry: () {
              ref.invalidate(
                habitProvider(widget.habitId),
              );
              ref.invalidate(
                habitStatisticsProvider(
                  _statisticsQuery,
                ),
              );
            },
          );
        },
        data: (habit) {
          if (habit == null) {
            return const _EmptyState(
              title: 'Habit not found',
              message:
              'This habit could not be found.',
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics:
              const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                110,
              ),
              children: [
                // =================================================
                // HABIT HEADER
                // =================================================

                _HabitHeader(
                  title: widget.habitTitle,
                  startDate: habit.startDate,
                ),

                const SizedBox(height: 14),

                // =================================================
                // VIEW SELECTOR
                // =================================================

                _ViewSelector(
                  selectedIndex: _selectedView,
                  onChanged: (index) {
                    setState(() {
                      _selectedView = index;
                      _selectedDate = DateTime.now();
                    });
                  },
                ),

                const SizedBox(height: 12),

                // =================================================
                // PERIOD NAVIGATION
                // =================================================

                if (_selectedView != 0)
                  _PeriodNavigation(
                    selectedView: _selectedView,
                    selectedDate: _selectedDate,
                    onPrevious: () {
                      _changePeriod(-1);
                    },
                    onNext: () {
                      _changePeriod(1);
                    },
                    onToday: () {
                      setState(() {
                        _selectedDate = DateTime.now();
                      });
                    },
                  ),

                if (_selectedView != 0)
                  const SizedBox(height: 14),

                // =================================================
                // STATISTICS
                // =================================================

                statisticsAsync.when(
                  loading: () {
                    return const _LoadingCard();
                  },
                  error: (error, stack) {
                    return _StatisticsErrorCard(
                      error: error,
                      onRetry: () {
                        ref.invalidate(
                          habitStatisticsProvider(
                            _statisticsQuery,
                          ),
                        );
                      },
                    );
                  },
                  data: (statistics) {
                    if (statistics == null) {
                      return const _EmptyState(
                        title: 'No statistics available',
                        message:
                        'Complete this habit to generate statistics.',
                      );
                    }

                    return _StatisticsContent(
                      statistics: statistics,
                      selectedView: _selectedView,
                      selectedDate: _selectedDate,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // =============================================================
  // REFRESH
  // =============================================================

  Future<void> _refresh() async {
    final query = _statisticsQuery;

    ref.invalidate(
      habitProvider(widget.habitId),
    );

    ref.invalidate(
      habitStatisticsProvider(query),
    );

    await ref.read(
      habitStatisticsProvider(query).future,
    );
  }

  // =============================================================
  // PERIOD
  // =============================================================

  void _changePeriod(int offset) {
    setState(() {
      switch (_selectedView) {
        case 1:
          _selectedDate = _selectedDate.add(
            Duration(days: offset * 7),
          );
          break;

        case 2:
          _selectedDate = DateTime(
            _selectedDate.year,
            _selectedDate.month + offset,
            1,
          );
          break;

        case 3:
          _selectedDate = DateTime(
            _selectedDate.year + offset,
            1,
            1,
          );
          break;
      }
    });
  }

  // =============================================================
  // DATE
  // =============================================================

  DateTime _dateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }
}

// =====================================================================
// HABIT HEADER
// =====================================================================

class _HabitHeader extends StatelessWidget {
  const _HabitHeader({
    required this.title,
    required this.startDate,
  });

  final String title;
  final DateTime startDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark =
        theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [
            Color(0xFF0B1738),
            Color(0xFF132C68),
            Color(0xFF1B429F),
          ]
              : const [
            Color(0xFFE8E9FF),
            Color(0xFFDCE5FF),
          ],
        ),
        borderRadius:
        BorderRadius.circular(22),
        border: Border.all(
          color: colors.primary.withValues(
            alpha: isDark ? 0.35 : 0.16,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.20 : 0.025,
            ),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark
                  ? colors.primary.withValues(
                alpha: 0.18,
              )
                  : colors.primary.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: colors.primary.withValues(
                  alpha: 0.28,
                ),
              ),
            ),
            child: Icon(
              Icons.insights_rounded,
              color: colors.primary,
              size: 23,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    color: isDark
                        ? Colors.white
                        : colors.onPrimaryContainer,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Started ${_formatDate(startDate)}',
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: isDark
                        ? Colors.white.withValues(
                      alpha: 0.70,
                    )
                        : colors.onPrimaryContainer
                        .withValues(
                      alpha: 0.70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// VIEW SELECTOR
// =====================================================================

class _ViewSelector extends StatelessWidget {
  const _ViewSelector({
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: colors.outlineVariant
              .withValues(alpha: 0.65),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          _ViewButton(
            label: 'Overview',
            selected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          _ViewButton(
            label: 'Week',
            selected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
          _ViewButton(
            label: 'Month',
            selected: selectedIndex == 2,
            onTap: () => onChanged(2),
          ),
          _ViewButton(
            label: 'Year',
            selected: selectedIndex == 3,
            onTap: () => onChanged(3),
          ),
        ],
      ),
    );
  }
}

class _ViewButton extends StatelessWidget {
  const _ViewButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration:
          const Duration(milliseconds: 180),
          margin: const EdgeInsets.all(3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? colors.primary
                : Colors.transparent,
            borderRadius:
            BorderRadius.circular(11),
          ),
          child: Text(
            label,
            style: theme
                .textTheme
                .labelMedium
                ?.copyWith(
              color: selected
                  ? colors.onPrimary
                  : colors.onSurfaceVariant,
              fontWeight: selected
                  ? FontWeight.w700
                  : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// PERIOD NAVIGATION
// =====================================================================

class _PeriodNavigation extends StatelessWidget {
  const _PeriodNavigation({
    required this.selectedView,
    required this.selectedDate,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  final int selectedView;
  final DateTime selectedDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: colors.outlineVariant
              .withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Previous',
            onPressed: onPrevious,
            visualDensity:
            VisualDensity.compact,
            icon: const Icon(
              Icons.chevron_left_rounded,
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                _title(),
                style: theme
                    .textTheme
                    .titleSmall
                    ?.copyWith(
                  color: colors.onSurface,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ),
          ),

          IconButton(
            tooltip: 'Next',
            onPressed: onNext,
            visualDensity:
            VisualDensity.compact,
            icon: const Icon(
              Icons.chevron_right_rounded,
            ),
          ),

          TextButton(
            onPressed: onToday,
            child: const Text('Today'),
          ),
        ],
      ),
    );
  }

  String _title() {
    switch (selectedView) {
      case 1:
        final monday =
        selectedDate.subtract(
          Duration(
            days: selectedDate.weekday - 1,
          ),
        );

        final sunday = monday.add(
          const Duration(days: 6),
        );

        return '${_shortDate(monday)} – '
            '${_shortDate(sunday)}';

      case 2:
        const months = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];

        return '${months[selectedDate.month - 1]} '
            '${selectedDate.year}';

      case 3:
        return '${selectedDate.year}';

      default:
        return '';
    }
  }

  String _shortDate(DateTime date) {
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

    return '${months[date.month - 1]} ${date.day}';
  }
}

// =====================================================================
// STATISTICS CONTENT
// =====================================================================

class _StatisticsContent extends StatelessWidget {
  const _StatisticsContent({
    required this.statistics,
    required this.selectedView,
    required this.selectedDate,
  });

  final HabitStatistics statistics;
  final int selectedView;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    switch (selectedView) {
      case 1:
        return _WeekView(
          statistics: statistics,
        );

      case 2:
        return _MonthView(
          statistics: statistics,
        );

      case 3:
        return _YearView(
          statistics: statistics,
        );

      default:
        return _OverviewView(
          statistics: statistics,
        );
    }
  }
}

// =====================================================================
// OVERVIEW
// =====================================================================

class _OverviewView extends StatelessWidget {
  const _OverviewView({
    required this.statistics,
  });

  final HabitStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.stretch,
      children: [
        // =========================================================
        // TOP METRICS
        // =========================================================

        Row(
          children: [
            Expanded(
              child: _OverviewMetricCard(
                icon:
                Icons.local_fire_department_rounded,
                title: 'Current Streak',
                value:
                '${statistics.currentStreak}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OverviewMetricCard(
                icon:
                Icons.emoji_events_rounded,
                title: 'Best Streak',
                value:
                '${statistics.bestStreak}',
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _OverviewMetricCard(
                icon:
                Icons.check_circle_outline_rounded,
                title: 'Completed',
                value:
                '${statistics.totalCompleted}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OverviewMetricCard(
                icon:
                Icons.cancel_outlined,
                title: 'Missed',
                value:
                '${statistics.totalMissed}',
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _OverviewMetricCard(
                icon:
                Icons.calendar_month_rounded,
                title: 'Tracked Days',
                value:
                '${statistics.totalTrackedDays}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OverviewMetricCard(
                icon:
                Icons.event_available_rounded,
                title: 'Active Days',
                value:
                '${statistics.activeDays}',
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        _OverviewMetricCard(
          icon: Icons.bolt_rounded,
          title: 'Total XP',
          value: '${statistics.totalXP}',
        ),

        const SizedBox(height: 16),

        // =========================================================
        // PERFORMANCE
        // =========================================================

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
              theme.brightness ==
                  Brightness.dark
                  ? [
                colors.surfaceContainer,
                colors.surfaceContainerLow,
              ]
                  : [
                colors.surface,
                const Color(0xFFF7FAFF),
              ],
            ),
            borderRadius:
            BorderRadius.circular(20),
            border: Border.all(
              color: colors.outlineVariant
                  .withValues(
                alpha:
                theme.brightness ==
                    Brightness.dark
                    ? 0.70
                    : 0.65,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha:
                  theme.brightness ==
                      Brightness.dark
                      ? 0.15
                      : 0.025,
                ),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Performance',
                style: theme
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight:
                  FontWeight.w800,
                  color: colors.onSurface,
                ),
              ),

              const SizedBox(height: 20),

              _ProgressRow(
                label: 'Completion Rate',
                value:
                statistics.completionRate,
              ),

              const SizedBox(height: 20),

              _ProgressRow(
                label: 'Success Rate',
                value:
                statistics.successRate,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _OverviewInfo(
                      icon:
                      Icons.trending_up_rounded,
                      title: 'Average / Week',
                      value: statistics
                          .averagePerWeek
                          .toStringAsFixed(1),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _OverviewInfo(
                      icon:
                      Icons.timelapse_rounded,
                      title: 'Longest Gap',
                      value:
                      '${statistics.longestGap} days',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // =========================================================
        // WEEKLY SNAPSHOT
        // =========================================================

        _SectionCard(
          title: 'This Week',
          children: [
            ...statistics.weeklyProgress.map(
                  (day) {
                final completed =
                    day.completed;

                return Padding(
                  padding:
                  const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _formatDate(day.date),
                          style: theme
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            color:
                            colors.onSurface,
                          ),
                        ),
                      ),
                      Icon(
                        completed
                            ? Icons
                            .check_circle_rounded
                            : Icons
                            .radio_button_unchecked_rounded,
                        size: 22,
                        color: completed
                            ? Colors.green
                            : colors
                            .onSurfaceVariant,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

// =====================================================================
// OVERVIEW METRIC CARD
// =====================================================================

class _OverviewMetricCard
    extends StatelessWidget {
  const _OverviewMetricCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark =
        theme.brightness == Brightness.dark;

    return Container(
      height: 112,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
            colors.surfaceContainerHighest,
            colors.surfaceContainer,
          ]
              : [
            colors.surface,
            const Color(0xFFF7FAFF),
          ],
        ),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: colors.outlineVariant
              .withValues(
            alpha: isDark ? 0.70 : 0.65,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.14 : 0.025,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colors.primary.withValues(
                alpha: isDark ? 0.16 : 0.10,
              ),
              borderRadius:
              BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 19,
              color: colors.primary,
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: theme
                .textTheme
                .titleLarge
                ?.copyWith(
              color: colors.onSurface,
              fontWeight:
              FontWeight.w900,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            title,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color:
              colors.onSurfaceVariant,
              fontSize: 11,
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// PROGRESS ROW
// =====================================================================

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final safeValue = value.isFinite
        ? value.clamp(0.0, 100.0)
        : 0.0;

    final progress =
        safeValue.toDouble() / 100.0;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color: colors.onSurface,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),

            Text(
              '${safeValue.toStringAsFixed(1)}%',
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color: colors.primary,
                fontWeight:
                FontWeight.w800,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius:
          BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor:
            colors.surfaceContainerHighest,
            valueColor:
            AlwaysStoppedAnimation<Color>(
              colors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// OVERVIEW INFO
// =====================================================================

class _OverviewInfo extends StatelessWidget {
  const _OverviewInfo({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: colors.primary.withValues(
              alpha: 0.10,
            ),
            borderRadius:
            BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: colors.primary,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight:
                  FontWeight.w800,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
                style: theme
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  color:
                  colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// WEEK
// =====================================================================

class _WeekView extends StatelessWidget {
  const _WeekView({
    required this.statistics,
  });

  final HabitStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final scheduled = statistics
        .weeklyProgress
        .where(
          (day) => day.isWithinHabitRange,
    )
        .toList();

    final completed = scheduled
        .where(
          (day) => day.completed,
    )
        .length;

    return Column(
      children: [
        _PeriodSummaryCard(
          title: 'Weekly Progress',
          completed: completed,
          total: scheduled.length,
          icon:
          Icons.calendar_view_week_rounded,
        ),

        const SizedBox(height: 14),

        _WeeklyProgressCard(
          statistics: statistics,
        ),
      ],
    );
  }
}

// =====================================================================
// MONTH
// =====================================================================

class _MonthView extends StatelessWidget {
  const _MonthView({
    required this.statistics,
  });

  final HabitStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final scheduled = statistics
        .monthlyProgress
        .where(
          (day) => day.isWithinHabitRange,
    )
        .toList();

    final completed = scheduled
        .where(
          (day) => day.completed,
    )
        .length;

    return Column(
      children: [
        _PeriodSummaryCard(
          title: 'Monthly Progress',
          completed: completed,
          total: scheduled.length,
          icon: Icons.calendar_month_rounded,
        ),

        const SizedBox(height: 14),

        _MonthlyProgressCard(
          statistics: statistics,
        ),
      ],
    );
  }
}

// =====================================================================
// YEAR
// =====================================================================

class _YearView extends StatelessWidget {
  const _YearView({
    required this.statistics,
  });

  final HabitStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final scheduled = statistics
        .yearlyProgress
        .where(
          (day) => day.isWithinHabitRange,
    )
        .toList();

    final completed = scheduled
        .where(
          (day) => day.completed,
    )
        .length;

    return Column(
      children: [
        _PeriodSummaryCard(
          title: 'Yearly Progress',
          completed: completed,
          total: scheduled.length,
          icon:
          Icons.calendar_today_rounded,
        ),

        const SizedBox(height: 14),

        _YearlyProgressCard(
          statistics: statistics,
        ),
      ],
    );
  }
}

// =====================================================================
// WEEKLY PROGRESS
// =====================================================================

class _WeeklyProgressCard
    extends StatelessWidget {
  const _WeeklyProgressCard({
    required this.statistics,
  });

  final HabitStatistics statistics;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'This Week',
      children: [
        ...statistics.weeklyProgress.map(
              (day) {
            final theme =
            Theme.of(context);
            final colors =
                theme.colorScheme;

            return Padding(
              padding:
              const EdgeInsets.only(
                bottom: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _formatDate(day.date),
                      style: theme
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        color:
                        colors.onSurface,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),
                  ),

                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: day.completed
                          ? Colors.green
                          .withValues(
                        alpha: 0.10,
                      )
                          : colors
                          .surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      day.completed
                          ? Icons
                          .check_circle_rounded
                          : Icons
                          .radio_button_unchecked_rounded,
                      size: 20,
                      color: day.completed
                          ? Colors.green
                          : colors
                          .onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// =====================================================================
// MONTHLY PROGRESS
// =====================================================================

class _MonthlyProgressCard
    extends StatelessWidget {
  const _MonthlyProgressCard({
    required this.statistics,
  });

  final HabitStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final days =
        statistics.monthlyProgress;

    return _SectionCard(
      title: 'Month',
      children: [
        _ProgressRow(
          label: 'Completed Days',
          value: _percentage(
            days
                .where(
                  (day) => day.completed,
            )
                .length,
            days
                .where(
                  (day) =>
              day.isWithinHabitRange,
            )
                .length,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          '${days.length} calendar days',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// YEARLY PROGRESS
// =====================================================================

class _YearlyProgressCard
    extends StatelessWidget {
  const _YearlyProgressCard({
    required this.statistics,
  });

  final HabitStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final days =
        statistics.yearlyProgress;

    return _SectionCard(
      title: 'Year',
      children: [
        _ProgressRow(
          label: 'Completed Days',
          value: _percentage(
            days
                .where(
                  (day) => day.completed,
            )
                .length,
            days
                .where(
                  (day) =>
              day.isWithinHabitRange,
            )
                .length,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          '${days.length} calendar days',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// PERIOD SUMMARY
// =====================================================================

class _PeriodSummaryCard
    extends StatelessWidget {
  const _PeriodSummaryCard({
    required this.title,
    required this.completed,
    required this.total,
    required this.icon,
  });

  final String title;
  final int completed;
  final int total;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark =
        theme.brightness == Brightness.dark;

    final percentage = total == 0
        ? 0.0
        : completed / total * 100;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [
            Color(0xFF0B1738),
            Color(0xFF173574),
            Color(0xFF1E48A8),
          ]
              : [
            colors.primaryContainer,
            colors.primaryContainer
                .withValues(
              alpha: 0.72,
            ),
          ],
        ),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: colors.primary.withValues(
            alpha: isDark ? 0.35 : 0.15,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: isDark ? 0.12 : 0.45,
              ),
              borderRadius:
              BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              size: 24,
              color: isDark
                  ? Colors.white
                  : colors.onPrimaryContainer,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w800,
                    color: isDark
                        ? Colors.white
                        : colors
                        .onPrimaryContainer,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '$completed of $total scheduled days',
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: isDark
                        ? Colors.white
                        .withValues(
                      alpha: 0.72,
                    )
                        : colors
                        .onPrimaryContainer
                        .withValues(
                      alpha: 0.72,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: theme
                .textTheme
                .headlineSmall
                ?.copyWith(
              fontWeight:
              FontWeight.w900,
              color: isDark
                  ? Colors.white
                  : colors.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// SECTION CARD
// =====================================================================

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark =
        theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
            colors.surfaceContainer,
            colors.surfaceContainerLow,
          ]
              : [
            colors.surface,
            const Color(0xFFF7FAFF),
          ],
        ),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: colors.outlineVariant
              .withValues(
            alpha: isDark ? 0.70 : 0.65,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.15 : 0.025,
            ),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme
                .textTheme
                .titleMedium
                ?.copyWith(
              color: colors.onSurface,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          const SizedBox(height: 16),

          ...children,
        ],
      ),
    );
  }
}

// =====================================================================
// LOADING
// =====================================================================

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Loading statistics…',
            style: theme
                .textTheme
                .bodyMedium
                ?.copyWith(
              color:
              colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// STATISTICS ERROR
// =====================================================================

class _StatisticsErrorCard
    extends StatelessWidget {
  const _StatisticsErrorCard({
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 42,
            color: colors.onErrorContainer,
          ),

          const SizedBox(height: 12),

          Text(
            'Unable to load statistics',
            style: theme
                .textTheme
                .titleMedium
                ?.copyWith(
              fontWeight:
              FontWeight.w800,
              color:
              colors.onErrorContainer,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '$error',
            textAlign: TextAlign.center,
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color:
              colors.onErrorContainer,
            ),
          ),

          const SizedBox(height: 16),

          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// ERROR STATE
// =====================================================================

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: colors.error,
            ),

            const SizedBox(height: 16),

            Text(
              'Unable to load habit',
              style: theme
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight:
                FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '$error',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label:
              const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// EMPTY STATE
// =====================================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              Icons.insights_rounded,
              size: 58,
              color: colors.primary,
            ),

            const SizedBox(height: 16),

            Text(
              title,
              textAlign: TextAlign.center,
              style: theme
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight:
                FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color:
                colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// HELPERS
// =====================================================================

double _percentage(
    int completed,
    int total,
    ) {
  if (total <= 0) {
    return 0;
  }

  return completed / total * 100;
}

String _formatDate(DateTime date) {
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

  return '${months[date.month - 1]} '
      '${date.day}, ${date.year}';
}