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
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          bottom: 120,
        ),
        child: Column(
          children: [
            const CalendarHeader(),

            calendarAsync.when(
              loading: () => const SizedBox.shrink(),

              error: (_, __) =>
              const SizedBox.shrink(),

              data: (calendar) {
                return CalendarMonthSummary(
                  calendar: calendar,
                );
              },
            ),

            const CalendarLegend(),

            const CalendarMonthGrid(),

            const SelectedDayCard(),
          ],
        ),
      ),
    );
  }
}