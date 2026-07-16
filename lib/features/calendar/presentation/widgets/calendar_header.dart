import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/calendar_provider.dart';

class CalendarHeader extends ConsumerWidget {
  const CalendarHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendar = ref.watch(calendarProvider);

    return calendar.when(
      loading: () => const SizedBox(height: 72),
      error: (_, __) => const SizedBox(height: 72),
      data: (vm) {
        final month = vm.focusedMonth;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Previous Month',
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  ref.read(calendarProvider.notifier).previousMonth();
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    DateFormat.yMMMM().format(month),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.today),
                label: const Text("Today"),
                onPressed: () {
                  ref.read(calendarProvider.notifier).jumpToToday();
                },
              ),
              IconButton(
                tooltip: 'Next Month',
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  ref.read(calendarProvider.notifier).nextMonth();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
