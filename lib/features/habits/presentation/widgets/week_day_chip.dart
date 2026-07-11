import 'package:flutter/material.dart';

class WeekDayChip extends StatelessWidget {
  const WeekDayChip({
    super.key,
    required this.day,
    required this.completed,
    required this.isToday,
  });

  final String day;
  final bool completed;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final background = completed
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceContainerHighest;

    final foreground = completed
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurfaceVariant;

    return AnimatedScale(
      duration: const Duration(milliseconds: 350),
      scale: completed ? 1.05 : 1,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
              border: Border.all(
                color: isToday ? theme.colorScheme.primary : Colors.transparent,
                width: 3,
              ),
            ),
            child: Center(
              child: completed
                  ? Icon(
                      Icons.check,
                      color: foreground,
                    )
                  : Text(
                      day,
                      style: TextStyle(
                        color: foreground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            day,
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
