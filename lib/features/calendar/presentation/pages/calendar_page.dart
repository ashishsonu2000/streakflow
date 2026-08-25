import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_scaffold.dart';

import '../cards/selected_day_card.dart';
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

            const CalendarLegend(),

            const CalendarMonthGrid(),

            const SelectedDayCard(),
          ],
        ),
      ),
    );
  }
}