import 'package:flutter/material.dart';

import '../../../../calendar/domain/models/calendar_view_model.dart';

import 'calendar_grid.dart';
import 'calendar_header.dart';
import 'calendar_legend.dart';
import 'calendar_weekdays.dart';

class MiniCalendar extends StatelessWidget {
  const MiniCalendar({
    super.key,
    required this.calendar,
    this.onTap,
  });

  final CalendarViewModel calendar;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalendarHeader(
              month: calendar.monthName,
              onTap: onTap,
            ),
            const SizedBox(height: 20),
            const CalendarWeekdays(),
            const SizedBox(height: 8),
            CalendarGrid(
              days: calendar.days,
              onDayTap: (day) {
                debugPrint(day.date.toString());
              },
            ),
            const SizedBox(height: 16),
            const CalendarLegend(),
          ],
        ),
      ),
    );
  }
}
