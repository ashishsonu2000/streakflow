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
    const blue = Color(0xFF2563EB);
    const navy = Color(0xFF172554);

    final isSelected = day.isSelected;
    final isToday = day.isToday;
    final isCurrentMonth = day.isCurrentMonth;

    final textColor = !isCurrentMonth
        ? const Color(0xFF94A3B8)
        : isSelected
        ? Colors.white
        : navy;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            // =====================================================
            // BACKGROUND
            // =====================================================

            color: isSelected
                ? blue
                : Colors.transparent,

            borderRadius:
            BorderRadius.circular(10),

            // =====================================================
            // TODAY
            // =====================================================

            border: isToday
                ? Border.all(
              color: isSelected
                  ? Colors.white
                  : blue,
              width: 1.5,
            )
                : null,
          ),

          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              // ===================================================
              // DAY NUMBER
              // ===================================================

              Text(
                '${day.date.day}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  color: textColor,
                  fontWeight:
                  isSelected || isToday
                      ? FontWeight.w800
                      : FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              // ===================================================
              // ACTIVITY DOT
              // ===================================================

              _ActivityDot(
                intensity: day.intensity,
                visible:
                isCurrentMonth &&
                    day.hasActivity,
                selected: isSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityDot extends StatelessWidget {
  const _ActivityDot({
    required this.intensity,
    required this.visible,
    required this.selected,
  });

  final int intensity;
  final bool visible;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox(
        width: 5,
        height: 5,
      );
    }

    final Color color;

    switch (intensity) {
      case 1:
        color = Colors.green.shade300;
        break;

      case 2:
        color = Colors.green.shade400;
        break;

      case 3:
        color = Colors.green.shade500;
        break;

      case 4:
        color = Colors.green.shade700;
        break;

      default:
        color = Colors.green.shade500;
    }

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 180,
      ),
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: selected
            ? Colors.white.withValues(
          alpha: 0.85,
        )
            : color,
        shape: BoxShape.circle,
      ),
    );
  }
}