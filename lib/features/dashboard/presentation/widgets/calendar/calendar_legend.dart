import 'package:flutter/material.dart';

class CalendarLegend extends StatelessWidget {
  const CalendarLegend({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isDark =
        theme.brightness == Brightness.dark;

    final textStyle =
    theme.textTheme.bodySmall?.copyWith(
      color: colors.onSurfaceVariant,
      fontSize: 11,
      fontWeight: FontWeight.w500,
    );

    return Row(
      children: [
        Icon(
          Icons.circle,
          size: 10,
          color: isDark
              ? const Color(0xFF4ADE80)
              : Colors.green,
        ),

        const SizedBox(width: 4),

        Text(
          'Completed',
          style: textStyle,
        ),

        const SizedBox(width: 20),

        Icon(
          Icons.local_fire_department,
          size: 16,
          color: isDark
              ? const Color(0xFFFB923C)
              : Colors.orange,
        ),

        const SizedBox(width: 4),

        Text(
          'Today',
          style: textStyle,
        ),
      ],
    );
  }
}