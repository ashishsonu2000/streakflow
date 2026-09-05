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
    final colors = theme.colorScheme;

    final isDark =
        theme.brightness == Brightness.dark;

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
          borderRadius: BorderRadius.circular(10),
          splashColor: colors.primary.withValues(
            alpha: 0.12,
          ),
          highlightColor: colors.primary.withValues(
            alpha: 0.06,
          ),
          child: AnimatedContainer(
            duration:
            const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              // =====================================================
              // BACKGROUND
              // =====================================================

              color: _backgroundColor(
                colors,
                isDark,
                isSelected,
                isToday,
                isOutsideMonth,
                hasActivity,
              ),

              borderRadius:
              BorderRadius.circular(10),

              // =====================================================
              // BORDER
              // =====================================================

              border: Border.all(
                color: _borderColor(
                  colors,
                  isDark,
                  isSelected,
                  isToday,
                  isOutsideMonth,
                ),
                width:
                isSelected || isToday
                    ? 1.3
                    : 0.7,
              ),

              // =====================================================
              // SELECTED SHADOW
              // =====================================================

              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: colors.primary
                      .withValues(
                    alpha: isDark
                        ? 0.28
                        : 0.18,
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
                // ===================================================
                // DATE
                // ===================================================

                Center(
                  child: Text(
                    '${day.date.day}',
                    style: theme
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color: _textColor(
                        colors,
                        isDark,
                        isSelected,
                        isToday,
                        isOutsideMonth,
                      ),
                      fontWeight:
                      isSelected || isToday
                          ? FontWeight.w800
                          : FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),

                // ===================================================
                // ACTIVITY DOT
                // ===================================================

                if (hasActivity &&
                    !isSelected)
                  Positioned(
                    bottom: 4,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration:
                        const BoxDecoration(
                          color:
                          Color(0xFF4ADE80),
                          shape:
                          BoxShape.circle,
                        ),
                      ),
                    ),
                  ),

                // ===================================================
                // SELECTED INDICATOR
                // ===================================================

                if (isSelected)
                  Positioned(
                    bottom: 4,
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

                // ===================================================
                // TODAY INDICATOR
                // ===================================================

                if (isToday &&
                    !isSelected)
                  Positioned(
                    bottom: 4,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: colors.primary,
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

  // ===============================================================
  // BACKGROUND COLOR
  // ===============================================================

  Color _backgroundColor(
      ColorScheme colors,
      bool isDark,
      bool isSelected,
      bool isToday,
      bool isOutsideMonth,
      bool hasActivity,
      ) {
    // -------------------------------------------------------------
    // SELECTED DAY
    // -------------------------------------------------------------

    if (isSelected) {
      return isDark
          ? colors.primary
          : const Color(0xFF2563EB);
    }

    // -------------------------------------------------------------
    // TODAY
    // -------------------------------------------------------------

    if (isToday) {
      return isDark
          ? colors.primaryContainer.withValues(
        alpha: 0.55,
      )
          : const Color(0xFFEFF6FF);
    }

    // -------------------------------------------------------------
    // OUTSIDE CURRENT MONTH
    // -------------------------------------------------------------

    if (isOutsideMonth) {
      return Colors.transparent;
    }

    // -------------------------------------------------------------
    // COMPLETED / ACTIVITY DAY
    // -------------------------------------------------------------

    if (hasActivity) {
      return isDark
          ? const Color(0xFF123B2A)
          : const Color(0xFFF0FDF4);
    }

    // -------------------------------------------------------------
    // NORMAL DAY
    // -------------------------------------------------------------

    return isDark
        ? colors.surfaceContainerHighest
        : const Color(0xFFF8FAFC);
  }

  // ===============================================================
  // BORDER COLOR
  // ===============================================================

  Color _borderColor(
      ColorScheme colors,
      bool isDark,
      bool isSelected,
      bool isToday,
      bool isOutsideMonth,
      ) {
    // -------------------------------------------------------------
    // SELECTED
    // -------------------------------------------------------------

    if (isSelected) {
      return isDark
          ? colors.primary
          : const Color(0xFF2563EB);
    }

    // -------------------------------------------------------------
    // TODAY
    // -------------------------------------------------------------

    if (isToday) {
      return isDark
          ? colors.primary.withValues(
        alpha: 0.70,
      )
          : const Color(0xFF93C5FD);
    }

    // -------------------------------------------------------------
    // OUTSIDE MONTH
    // -------------------------------------------------------------

    if (isOutsideMonth) {
      return Colors.transparent;
    }

    // -------------------------------------------------------------
    // NORMAL DAY
    // -------------------------------------------------------------

    return isDark
        ? colors.outlineVariant.withValues(
      alpha: 0.45,
    )
        : const Color(0xFFE2E8F0);
  }

  // ===============================================================
  // TEXT COLOR
  // ===============================================================

  Color _textColor(
      ColorScheme colors,
      bool isDark,
      bool isSelected,
      bool isToday,
      bool isOutsideMonth,
      ) {
    // -------------------------------------------------------------
    // SELECTED
    // -------------------------------------------------------------

    if (isSelected) {
      return Colors.white;
    }

    // -------------------------------------------------------------
    // TODAY
    // -------------------------------------------------------------

    if (isToday) {
      return isDark
          ? colors.onPrimaryContainer
          : const Color(0xFF1D4ED8);
    }

    // -------------------------------------------------------------
    // OUTSIDE MONTH
    // -------------------------------------------------------------

    if (isOutsideMonth) {
      return isDark
          ? colors.onSurfaceVariant.withValues(
        alpha: 0.45,
      )
          : const Color(0xFF94A3B8);
    }

    // -------------------------------------------------------------
    // NORMAL
    // -------------------------------------------------------------

    return isDark
        ? colors.onSurface
        : const Color(0xFF172554);
  }
}