import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/providers/calendar_provider.dart';

class CalendarHeader extends ConsumerWidget {
  const CalendarHeader({
    super.key,
  });

  static const _months = [
    '',
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarProvider);
    final notifier = ref.read(calendarProvider.notifier);

    final month = state.focusedMonth;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Previous Month',
            onPressed: notifier.previousMonth,
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: Center(
              child: Text(
                "${_months[month.month]} ${month.year}",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: notifier.jumpToToday,
            icon: const Icon(Icons.today, size: 18),
            label: const Text("Today"),
          ),
          IconButton(
            tooltip: 'Next Month',
            onPressed: notifier.nextMonth,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
