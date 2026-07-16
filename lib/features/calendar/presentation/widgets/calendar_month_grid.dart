import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/calendar_provider.dart';
import 'calendar_day_tile.dart';
import 'calendar_week_header.dart';

class CalendarMonthGrid extends ConsumerWidget {
  const CalendarMonthGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarAsync = ref.watch(calendarProvider);

    return calendarAsync.when(
      loading: () => const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Expanded(
        child: Center(
          child: Text(error.toString()),
        ),
      ),
      data: (calendar) {
        return Column(
          children: [
            const CalendarWeekHeader(),
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: calendar.days.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: .90,
                ),
                itemBuilder: (_, index) {
                  return CalendarDayTile(
                    day: calendar.days[index],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
