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

    final isSelected = day.isSelected;
    final isToday = day.isToday;
    final isOutsideMonth = !day.isCurrentMonth;

    final hasActivity =
        day.completedHabits > 0;

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
          BorderRadius.circular(12),
          child: AnimatedContainer(
            duration:
            const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: _backgroundColor(
                theme,
                isSelected,
                isToday,
                isOutsideMonth,
                hasActivity,
              ),
              borderRadius:
              BorderRadius.circular(12),
              border: Border.all(
                color: _borderColor(
                  theme,
                  isSelected,
                  isToday,
                  isOutsideMonth,
                ),
                width:
                isSelected || isToday
                    ? 1.4
                    : 0.8,
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: theme
                      .colorScheme
                      .primary
                      .withValues(
                    alpha: 0.18,
                  ),
                  blurRadius: 8,
                  offset:
                  const Offset(0, 3),
                ),
              ]
                  : null,
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    '${day.date.day}',
                    style: theme
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color: _textColor(
                        theme,
                        isSelected,
                        isToday,
                        isOutsideMonth,
                      ),
                      fontWeight:
                      isSelected ||
                          isToday
                          ? FontWeight.w800
                          : FontWeight.w500,
                    ),
                  ),
                ),

                // ===================================================
                // ACTIVITY DOT
                // ===================================================

                if (hasActivity &&
                    !isSelected)
                  Positioned(
                    bottom: 5,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration:
                        const BoxDecoration(
                          color:
                          Color(0xFF22C55E),
                          shape:
                          BoxShape.circle,
                        ),
                      ),
                    ),
                  ),

                // ===================================================
                // SELECTED / TODAY INDICATOR
                // ===================================================

                if (isSelected)
                  Positioned(
                    bottom: 5,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration:
                        const BoxDecoration(
                          color: Colors.white,
                          shape:
                          BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _backgroundColor(
      ThemeData theme,
      bool isSelected,
      bool isToday,
      bool isOutsideMonth,
      bool hasActivity,
      ) {
    if (isSelected) {
      return const Color(0xFF2563EB);
    }

    if (isToday) {
      return const Color(0xFFEFF6FF);
    }

    if (isOutsideMonth) {
      return Colors.transparent;
    }

    if (hasActivity) {
      return const Color(0xFFF0FDF4);
    }

    return const Color(0xFFF8FAFC);
  }

  Color _borderColor(
      ThemeData theme,
      bool isSelected,
      bool isToday,
      bool isOutsideMonth,
      ) {
    if (isSelected) {
      return const Color(0xFF2563EB);
    }

    if (isToday) {
      return const Color(0xFF93C5FD);
    }

    if (isOutsideMonth) {
      return Colors.transparent;
    }

    return const Color(0xFFE2E8F0);
  }

  Color _textColor(
      ThemeData theme,
      bool isSelected,
      bool isToday,
      bool isOutsideMonth,
      ) {
    if (isSelected) {
      return Colors.white;
    }

    if (isToday) {
      return const Color(0xFF1D4ED8);
    }

    if (isOutsideMonth) {
      return const Color(0xFF94A3B8);
    }

    return const Color(0xFF172554);
  }
}