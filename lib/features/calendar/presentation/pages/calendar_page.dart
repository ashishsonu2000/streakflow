import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_scaffold.dart';

import '../cards/calendar_month_summary.dart';
import '../cards/selected_day_card.dart';
import '../providers/calendar_provider.dart';
import '../widgets/calendar_header.dart';
import '../widgets/calendar_legend.dart';
import '../widgets/calendar_month_grid.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({
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

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AppScaffold(
      title: 'Calendar',
      showAppBar: false,
      child: Container(
        // ===========================================================
        // THEME-AWARE PAGE BACKGROUND
        // ===========================================================

        color: colors.surface,

        child: SafeArea(
          bottom: false,

          child: SingleChildScrollView(
            physics:
            const ClampingScrollPhysics(),

            padding: const EdgeInsets.fromLTRB(
              16,
              12,
              16,
              170,
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,

              children: [
                // =====================================================
                // HEADER
                // =====================================================

                const CalendarHeader(),

                const SizedBox(
                  height: 14,
                ),

                // =====================================================
                // MONTH SUMMARY
                // =====================================================

                calendarAsync.when(
                  loading: () {
                    return SizedBox(
                      height: 120,

                      child: Center(
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: colors.primary,
                        ),
                      ),
                    );
                  },

                  error: (error, stackTrace) {
                    return _CalendarError(
                      error: error,
                    );
                  },

                  data: (calendar) {
                    return CalendarMonthSummary(
                      calendar: calendar,
                    );
                  },
                ),

                const SizedBox(
                  height: 14,
                ),

                // =====================================================
                // LEGEND
                // =====================================================

                const CalendarLegend(),

                const SizedBox(
                  height: 8,
                ),

                // =====================================================
                // CALENDAR GRID
                // =====================================================

                const CalendarMonthGrid(),

                const SizedBox(
                  height: 16,
                ),

                // =====================================================
                // SELECTED DAY
                // =====================================================

                const SelectedDayCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// CALENDAR ERROR
// =====================================================================

class _CalendarError extends StatelessWidget {
  const _CalendarError({
    required this.error,
  });

  final Object error;

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      height: 120,

      padding: const EdgeInsets.all(
        16,
      ),

      decoration: BoxDecoration(
        color: colors.error.withValues(
          alpha: theme.brightness ==
              Brightness.dark
              ? 0.10
              : 0.06,
        ),

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color: colors.error.withValues(
            alpha: theme.brightness ==
                Brightness.dark
                ? 0.30
                : 0.20,
          ),
        ),
      ),

      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [
          Icon(
            Icons.error_outline_rounded,
            color: colors.error,
            size: 24,
          ),

          const SizedBox(
            height: 6,
          ),

          Text(
            'Unable to load calendar',
            style:
            theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}