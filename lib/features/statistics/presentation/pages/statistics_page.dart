import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_scaffold.dart';

import '../provider/statistics_provider.dart';
import '../widgets/common/statistics_body.dart';

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({
    super.key,
  });

  @override
  ConsumerState<StatisticsPage> createState() =>
      _StatisticsPageState();
}

class _StatisticsPageState
    extends ConsumerState<StatisticsPage> {
  // =============================================================
  // VIEW
  // =============================================================

  /// 0 = Overview
  /// 1 = Week
  /// 2 = Month
  /// 3 = Year
  int _selectedView = 0;

  // =============================================================
  // SELECTED DATE
  // =============================================================

  DateTime _selectedDate = DateTime.now();

  // =============================================================
  // STATISTICS QUERY
  // =============================================================

  StatisticsQuery get _statisticsQuery {
    return StatisticsQuery(
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

    final statisticsAsync = ref.watch(
      statisticsProvider(
        _statisticsQuery,
      ),
    );

    return AppScaffold(
      title: 'Statistics',
      showAppBar: false,

      child: Container(
        // =========================================================
        // THEME-AWARE PAGE BACKGROUND
        // =========================================================

        color: colors.surface,

        child: SafeArea(
          bottom: false,

          child: RefreshIndicator(
            color: colors.primary,

            backgroundColor:
            colors.surfaceContainerLow,

            // =====================================================
            // REFRESH
            // =====================================================

            onRefresh: () async {
              final query =
                  _statisticsQuery;

              ref.invalidate(
                statisticsProvider(
                  query,
                ),
              );

              await ref.read(
                statisticsProvider(
                  query,
                ).future,
              );
            },

            // =====================================================
            // ASYNC STATE
            // =====================================================

            child: statisticsAsync.when(
              // ===================================================
              // LOADING
              // ===================================================

              loading: () {
                return ListView(
                  physics:
                  const AlwaysScrollableScrollPhysics(),

                  padding:
                  const EdgeInsets.fromLTRB(
                    16,
                    24,
                    16,
                    140,
                  ),

                  children: [
                    SizedBox(
                      height: 280,

                      child: Center(
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color:
                          colors.primary,
                        ),
                      ),
                    ),
                  ],
                );
              },

              // ===================================================
              // ERROR
              // ===================================================

              error: (
                  error,
                  stack,
                  ) {
                return ListView(
                  physics:
                  const AlwaysScrollableScrollPhysics(),

                  padding:
                  const EdgeInsets.fromLTRB(
                    16,
                    80,
                    16,
                    140,
                  ),

                  children: [
                    _StatisticsMessageCard(
                      icon:
                      Icons
                          .error_outline_rounded,

                      iconColor:
                      colors.error,

                      iconBackground:
                      colors.error.withValues(
                        alpha: theme.brightness ==
                            Brightness.dark
                            ? 0.14
                            : 0.08,
                      ),

                      title:
                      'Failed to load statistics',

                      message:
                      'Something went wrong while loading your statistics.',

                      action:
                      FilledButton.icon(
                        onPressed: () {
                          ref.invalidate(
                            statisticsProvider(
                              _statisticsQuery,
                            ),
                          );
                        },

                        style:
                        FilledButton.styleFrom(
                          backgroundColor:
                          colors.primary,

                          foregroundColor:
                          colors.onPrimary,

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                          ),
                        ),

                        icon: const Icon(
                          Icons
                              .refresh_rounded,
                        ),

                        label:
                        const Text(
                          'Retry',
                        ),
                      ),
                    ),
                  ],
                );
              },

              // ===================================================
              // DATA
              // ===================================================

              data: (statistics) {
                final hasStatistics =
                    statistics
                        .overview
                        .totalCompletions >
                        0;

                return ListView(
                  physics:
                  const AlwaysScrollableScrollPhysics(),

                  padding:
                  const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    140,
                  ),

                  children: [
                    // =============================================
                    // VIEW SELECTOR
                    // =============================================

                    _StatisticsViewSelector(
                      selectedIndex:
                      _selectedView,

                      onChanged: (index) {
                        setState(() {
                          _selectedView =
                              index;

                          _selectedDate =
                              DateTime.now();
                        });
                      },
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    // =============================================
                    // PERIOD NAVIGATION
                    // =============================================

                    if (_selectedView != 0)
                      _PeriodNavigation(
                        selectedView:
                        _selectedView,

                        selectedDate:
                        _selectedDate,

                        onPrevious: () {
                          _changePeriod(-1);
                        },

                        onNext: () {
                          _changePeriod(1);
                        },

                        onToday: () {
                          setState(() {
                            _selectedDate =
                                DateTime.now();
                          });
                        },
                      ),

                    if (_selectedView != 0)
                      const SizedBox(
                        height: 16,
                      ),

                    // =============================================
                    // NO STATISTICS
                    // =============================================

                    if (!hasStatistics)
                      _StatisticsMessageCard(
                        icon:
                        Icons
                            .insights_rounded,

                        iconColor:
                        colors.primary,

                        iconBackground:
                        colors.primary
                            .withValues(
                          alpha:
                          theme.brightness ==
                              Brightness.dark
                              ? 0.14
                              : 0.08,
                        ),

                        title:
                        'No statistics yet',

                        message:
                        'Complete a habit to generate your analytics and progress insights.',
                      )
                    else
                    // ===========================================
                    // EXISTING BODY
                    // ===========================================

                      StatisticsBody(
                        statistics:
                        statistics,
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // CHANGE PERIOD
  // =============================================================

  void _changePeriod(int offset) {
    setState(() {
      switch (_selectedView) {
      // ---------------------------------------------------------
      // WEEK
      // ---------------------------------------------------------

        case 1:
          _selectedDate =
              _selectedDate.add(
                Duration(
                  days: offset * 7,
                ),
              );
          break;

      // ---------------------------------------------------------
      // MONTH
      // ---------------------------------------------------------

        case 2:
          _selectedDate = DateTime(
            _selectedDate.year,
            _selectedDate.month + offset,
            1,
          );
          break;

      // ---------------------------------------------------------
      // YEAR
      // ---------------------------------------------------------

        case 3:
          _selectedDate = DateTime(
            _selectedDate.year + offset,
            1,
            1,
          );
          break;

        default:
          break;
      }
    });
  }

  // =============================================================
  // DATE ONLY
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
// VIEW SELECTOR
// =====================================================================

class _StatisticsViewSelector
    extends StatelessWidget {
  const _StatisticsViewSelector({
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    return SizedBox(
      width: double.infinity,

      child: SegmentedButton<int>(
        showSelectedIcon: false,

        segments: const [
          ButtonSegment<int>(
            value: 0,
            label: Text(
              'Overview',
            ),
          ),

          ButtonSegment<int>(
            value: 1,
            label: Text(
              'Week',
            ),
          ),

          ButtonSegment<int>(
            value: 2,
            label: Text(
              'Month',
            ),
          ),

          ButtonSegment<int>(
            value: 3,
            label: Text(
              'Year',
            ),
          ),
        ],

        selected: {
          selectedIndex,
        },

        onSelectionChanged:
            (selection) {
          if (selection.isEmpty) {
            return;
          }

          onChanged(
            selection.first,
          );
        },

        style:
        ButtonStyle(
          // -------------------------------------------------------
          // Selected segment
          // -------------------------------------------------------

          backgroundColor:
          WidgetStateProperty
              .resolveWith(
                (states) {
              if (states.contains(
                WidgetState.selected,
              )) {
                return colors.primary;
              }

              return colors.surfaceContainerLow;
            },
          ),

          foregroundColor:
          WidgetStateProperty
              .resolveWith(
                (states) {
              if (states.contains(
                WidgetState.selected,
              )) {
                return colors.onPrimary;
              }

              return colors.onSurface;
            },
          ),

          side:
          WidgetStateProperty.all(
            BorderSide(
              color:
              colors.outlineVariant,
            ),
          ),

          textStyle:
          WidgetStateProperty.all(
            const TextStyle(
              fontSize: 13,
              fontWeight:
              FontWeight.w600,
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

class _PeriodNavigation
    extends StatelessWidget {
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
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colors =
        theme.colorScheme;

    return Row(
      children: [
        // =========================================================
        // PREVIOUS
        // =========================================================

        IconButton(
          tooltip: 'Previous',

          onPressed: onPrevious,

          icon: const Icon(
            Icons.chevron_left_rounded,
          ),

          color:
          colors.onSurfaceVariant,
        ),

        // =========================================================
        // TITLE
        // =========================================================

        Expanded(
          child: Center(
            child: Text(
              _title(),

              textAlign:
              TextAlign.center,

              style: theme
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                color:
                colors.onSurface,
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ),
        ),

        // =========================================================
        // NEXT
        // =========================================================

        IconButton(
          tooltip: 'Next',

          onPressed: onNext,

          icon: const Icon(
            Icons.chevron_right_rounded,
          ),

          color:
          colors.onSurfaceVariant,
        ),

        // =========================================================
        // TODAY
        // =========================================================

        TextButton(
          onPressed: onToday,

          style:
          TextButton.styleFrom(
            foregroundColor:
            colors.primary,
          ),

          child: const Text(
            'Today',
          ),
        ),
      ],
    );
  }

  // =============================================================
  // TITLE
  // =============================================================

  String _title() {
    switch (selectedView) {
      case 1:
        return _weekTitle();

      case 2:
        return _monthTitle();

      case 3:
        return '${selectedDate.year}';

      default:
        return '';
    }
  }

  // =============================================================
  // WEEK TITLE
  // =============================================================

  String _weekTitle() {
    final date = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    final monday =
    date.subtract(
      Duration(
        days:
        date.weekday -
            DateTime.monday,
      ),
    );

    final sunday =
    monday.add(
      const Duration(
        days: 6,
      ),
    );

    return '${_shortDate(monday)} – '
        '${_shortDate(sunday)}';
  }

  // =============================================================
  // MONTH TITLE
  // =============================================================

  String _monthTitle() {
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
  }

  // =============================================================
  // SHORT DATE
  // =============================================================

  String _shortDate(
      DateTime date,
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

    return '${months[date.month - 1]} '
        '${date.day}';
  }
}

// =====================================================================
// MESSAGE CARD
// =====================================================================

class _StatisticsMessageCard
    extends StatelessWidget {
  const _StatisticsMessageCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String message;
  final Widget? action;

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
      padding:
      const EdgeInsets.all(24),

      decoration: BoxDecoration(
        // =========================================================
        // THEME-AWARE SURFACE
        // =========================================================

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
              : const Color(
            0xFFBDD4F2,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha:
              isDark ? 0.18 : 0.04,
            ),

            blurRadius: 14,

            offset:
            const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          // =========================================================
          // ICON
          // =========================================================

          Container(
            width: 58,
            height: 58,

            decoration:
            BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),

            child: Icon(
              icon,
              size: 28,
              color: iconColor,
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          // =========================================================
          // TITLE
          // =========================================================

          Text(
            title,

            textAlign:
            TextAlign.center,

            style: theme
                .textTheme
                .titleMedium
                ?.copyWith(
              color:
              colors.onSurface,

              fontSize: 18,

              fontWeight:
              FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          // =========================================================
          // MESSAGE
          // =========================================================

          Text(
            message,

            textAlign:
            TextAlign.center,

            style: theme
                .textTheme
                .bodyMedium
                ?.copyWith(
              color:
              colors.onSurfaceVariant,

              fontSize: 13,

              height: 1.45,
            ),
          ),

          // =========================================================
          // ACTION
          // =========================================================

          if (action != null) ...[
            const SizedBox(
              height: 20,
            ),

            action!,
          ],
        ],
      ),
    );
  }
}