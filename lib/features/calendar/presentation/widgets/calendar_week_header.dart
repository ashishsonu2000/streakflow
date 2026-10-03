import 'package:flutter/material.dart';

import 'calendar_day.dart';

class CalendarWeekHeader extends StatelessWidget {
  const CalendarWeekHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 42,
      child: Row(
        children: CalendarDay.days.map((day) {
          return Expanded(
            child: Center(
              child: Text(
                day.label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
