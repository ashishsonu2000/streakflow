import 'package:flutter/material.dart';

// =====================================================================
// PERIOD NAVIGATION
// =====================================================================

class HabitStatsPeriodNavigation extends StatelessWidget {
  const HabitStatsPeriodNavigation({
    super.key,
    required this.selectedView,
    required this.selectedDate,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  final int selectedView;
  final DateTime selectedDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: colors.outlineVariant
              .withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Previous',
            onPressed: onPrevious,
            visualDensity:
            VisualDensity.compact,
            icon: const Icon(
              Icons.chevron_left_rounded,
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                _title(),
                style: theme
                    .textTheme
                    .titleSmall
                    ?.copyWith(
                  color: colors.onSurface,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ),
          ),

          IconButton(
            tooltip: 'Next',
            onPressed: onNext,
            visualDensity:
            VisualDensity.compact,
            icon: const Icon(
              Icons.chevron_right_rounded,
            ),
          ),

          TextButton(
            onPressed: onToday,
            child: const Text('Today'),
          ),
        ],
      ),
    );
  }

  String _title() {
    switch (selectedView) {
      case 1:
        final monday =
        selectedDate.subtract(
          Duration(
            days: selectedDate.weekday - 1,
          ),
        );

        final sunday = monday.add(
          const Duration(days: 6),
        );

        return '${_shortDate(monday)} – '
            '${_shortDate(sunday)}';

      case 2:
        const months = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];

        return '${months[selectedDate.month - 1]} '
            '${selectedDate.year}';

      case 3:
        return '${selectedDate.year}';

      default:
        return '';
    }
  }

  String _shortDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}';
  }
}
