import 'package:flutter/material.dart';

class CalendarWeekdays extends StatelessWidget {
  const CalendarWeekdays({
    super.key,
  });

  static const days = [
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
    'Su',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isDark =
        theme.brightness == Brightness.dark;

    return Row(
      children: days.map(
            (day) {
          return Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                ),
                child: Text(
                  day,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? colors.onSurfaceVariant
                        : const Color(0xFF475569),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}