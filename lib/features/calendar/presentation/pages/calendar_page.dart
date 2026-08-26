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

    return AppScaffold(
      title: 'Calendar',
      showAppBar: false,
      child: Container(
        color: const Color(0xFFF0F5FA),
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

                const SizedBox(height: 14),

                // =====================================================
                // MONTH SUMMARY
                // =====================================================

                calendarAsync.when(
                  loading: () {
                    return const SizedBox(
                      height: 120,
                      child: Center(
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color:
                          Color(0xFF2563EB),
                        ),
                      ),
                    );
                  },
                  error: (_, __) {
                    return const SizedBox.shrink();
                  },
                  data: (calendar) {
                    return CalendarMonthSummary(
                      calendar: calendar,
                    );
                  },
                ),

                const SizedBox(height: 14),

                // =====================================================
                // LEGEND
                // =====================================================

                const CalendarLegend(),

                const SizedBox(height: 8),

                // =====================================================
                // CALENDAR GRID
                // =====================================================

                const CalendarMonthGrid(),

                const SizedBox(height: 16),

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