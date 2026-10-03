import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/calendar_provider.dart';

class CalendarHeader extends ConsumerWidget {
  const CalendarHeader({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final calendarAsync = ref.watch(
      calendarProvider,
    );

    return calendarAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          8,
        ),
        child: SizedBox(
          height: 48,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),

      error: (error, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          error.toString(),
        ),
      ),

      data: (calendar) {
        final notifier =
        ref.read(calendarProvider.notifier);



        return Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            8,
          ),
          child: Row(
            children: [
              // =====================================================
              // PREVIOUS MONTH
              // =====================================================

              IconButton(
                tooltip: 'Previous month',
                onPressed: () {
                  notifier.previousMonth();
                },
                icon: const Icon(
                  Icons.chevron_left_rounded,
                ),
              ),

              // =====================================================
              // MONTH
              // =====================================================

              Expanded(
                child: Center(
                  child: Text(
                    calendar.monthName,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ),
              ),

              // =====================================================
              // TODAY
              // =====================================================

              TextButton.icon(
                onPressed: () {
                  notifier.jumpToToday();
                },
                icon: const Icon(
                  Icons.today_outlined,
                  size: 18,
                ),
                label: const Text(
                  'Today',
                ),
              ),

              // =====================================================
              // NEXT MONTH
              // =====================================================

              IconButton(
                tooltip: 'Next month',
                onPressed: () {
                  notifier.nextMonth();
                },
                icon: const Icon(
                  Icons.chevron_right_rounded,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}