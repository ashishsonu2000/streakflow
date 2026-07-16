import 'package:flutter/material.dart';

import '../../../../calendar/domain/models/calendar_day_view_model.dart';

class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    super.key,
    required this.day,
    this.onTap,
  });

  final CalendarDayViewModel day;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final background = _backgroundColor(theme);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
            border: day.isSelected
                ? Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Center(
            child: Text(
              "${day.date.day}",
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: day.isToday ? FontWeight.bold : FontWeight.normal,
                color: _textColor(theme),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _backgroundColor(ThemeData theme) {
    if (!day.isCurrentMonth) {
      return Colors.transparent;
    }

    if (day.isToday) {
      return theme.colorScheme.primary;
    }

    if (!day.hasActivity) {
      return theme.colorScheme.surfaceContainerHighest;
    }

    switch (day.intensity) {
      case 1:
        return Colors.green.shade100;
      case 2:
        return Colors.green.shade200;
      case 3:
        return Colors.green.shade300;
      case 4:
        return Colors.green.shade400;
      default:
        return Colors.green.shade600;
    }
  }

  Color _textColor(ThemeData theme) {
    if (day.isToday) {
      return Colors.white;
    }

    if (!day.isCurrentMonth) {
      return Colors.grey;
    }

    return theme.colorScheme.onSurface;
  }
}
