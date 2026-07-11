import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/providers/calendar_provider.dart';
import 'calendar_day_tile.dart';
import 'calendar_week_header.dart';

class CalendarMonthGrid extends ConsumerWidget {
  const CalendarMonthGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarProvider);

    if (state.isLoading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.days.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text("No calendar data"),
        ),
      );
    }

    return Column(
      children: [
        const CalendarWeekHeader(),
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            itemCount: state.days.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: .95,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              return CalendarDayTile(
                day: state.days[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
