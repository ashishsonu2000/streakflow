import 'package:flutter/material.dart';

class CalendarWeekHeader extends StatelessWidget {
  const CalendarWeekHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const days = [
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ];

    return Row(
      children: days.map(
        (day) {
          return Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                child: Text(
                  day,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
