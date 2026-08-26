import 'package:flutter/material.dart';

import '../../../../calendar/domain/models/calendar_day_view_model.dart';

import 'calendar_day_cell.dart';

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    super.key,
    required this.days,
    this.onDayTap,
  });

  final List<CalendarDayViewModel> days;

  final ValueChanged<CalendarDayViewModel>? onDayTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),
      itemCount: days.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemBuilder: (_, index) {
        final day = days[index];

        return CalendarDayCell(
          day: day,
          onTap: () {
            onDayTap?.call(day);
          },
        );
      },
    );
  }
}