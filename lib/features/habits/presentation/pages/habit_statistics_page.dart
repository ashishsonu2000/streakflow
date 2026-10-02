import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/habit_providers.dart';
import '../provider/habit_statistics_provider.dart';
import '../widgets/statistics/habit_stats_content.dart';
import '../widgets/statistics/habit_stats_header.dart';
import '../widgets/statistics/habit_stats_period_navigation.dart';
import '../widgets/statistics/habit_stats_states.dart';
import '../widgets/statistics/habit_stats_view_selector.dart';

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
          return HabitStatsErrorState(
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
            return const HabitStatsEmptyState(
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

                HabitStatsHeader(
                  title: widget.habitTitle,
                  startDate: habit.startDate,
                ),

                const SizedBox(height: 14),

                // =================================================
                // VIEW SELECTOR
                // =================================================

                HabitStatsViewSelector(
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
                  HabitStatsPeriodNavigation(
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
                    return const HabitStatsLoadingCard();
                  },
                  error: (error, stack) {
                    return HabitStatsErrorCard(
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
                      return const HabitStatsEmptyState(
                        title: 'No statistics available',
                        message:
                        'Complete this habit to generate statistics.',
                      );
                    }

                    return HabitStatsContent(
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
