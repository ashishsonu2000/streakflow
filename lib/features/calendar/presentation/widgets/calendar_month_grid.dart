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
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.all(24),
        child: Text(error.toString()),
      ),
      data: (calendar) {
        return Column(
          children: [
            const CalendarWeekHeader(),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: calendar.days.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemBuilder: (_, index) {
                return CalendarDayTile(
                  day: calendar.days[index],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
