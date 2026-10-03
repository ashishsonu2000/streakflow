import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/enums/habit_frequency.dart';
import '../provider/habit_form_provider.dart';

class HabitFrequencySelector extends ConsumerWidget {
  const HabitFrequencySelector({
    super.key,
  });

  static const List<String> _weekdayLabels = [
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
    'Su',
  ];

  static const List<String> _weekdayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final asyncState =
    ref.watch(habitFormProvider);

    return asyncState.when(
      loading: () =>
      const SizedBox.shrink(),

      error: (error, stackTrace) =>
      const SizedBox.shrink(),

      data: (state) {
        return Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // =================================================
            // FREQUENCY
            // =================================================

            Text(
              'Frequency',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: SegmentedButton<HabitFrequency>(
                showSelectedIcon: true,

                segments: [
                  ButtonSegment<HabitFrequency>(
                    value:
                    HabitFrequency.daily,
                    label: const Text(
                      'Daily',
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                    ),
                  ),

                  ButtonSegment<HabitFrequency>(
                    value:
                    HabitFrequency.weekly,
                    label: const Text(
                      'Week',
                      maxLines: 1,
                    ),
                  ),

                  ButtonSegment<HabitFrequency>(
                    value:
                    HabitFrequency.monthly,
                    label: const Text(
                      'Month',
                      maxLines: 1,
                    ),
                  ),

                  ButtonSegment<HabitFrequency>(
                    value:
                    HabitFrequency.custom,
                    label: const Text(
                      'Custom',
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                    ),
                  ),
                ],

                selected: {
                  state.frequency,
                },

                onSelectionChanged:
                    (selection) {
                  if (selection.isEmpty) {
                    return;
                  }

                  ref
                      .read(
                    habitFormProvider
                        .notifier,
                  )
                      .setFrequency(
                    selection.first,
                  );
                },
              ),
            ),

            // =================================================
            // WEEKLY SCHEDULE
            // =================================================

            if (state.frequency ==
                HabitFrequency.weekly) ...[
              const SizedBox(height: 16),

              _buildWeeklySelector(
                context,
                ref,
                state.weeklyDays,
              ),
            ],

            // =================================================
            // MONTHLY SCHEDULE
            // =================================================

            if (state.frequency ==
                HabitFrequency.monthly) ...[
              const SizedBox(height: 16),

              _buildMonthlySelector(
                context,
                ref,
                state.monthlyDay,
              ),
            ],
          ],
        );
      },
    );
  }

  // =========================================================
  // WEEKLY SELECTOR
  // =========================================================

  Widget _buildWeeklySelector(
      BuildContext context,
      WidgetRef ref,
      List<int> selectedDays,
      ) {
    final theme =
    Theme.of(context);

    final selected =
    selectedDays.toSet();

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color:
          const Color(0xFFD7E2F1),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            'Repeat on',
            style: theme
                .textTheme
                .titleSmall
                ?.copyWith(
              fontWeight:
              FontWeight.w600,
              color:
              const Color(0xFF172B4D),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children:
            List.generate(
              7,
                  (index) {
                final weekday =
                    index + 1;

                final isSelected =
                selected.contains(
                  weekday,
                );

                return Expanded(
                  child: Padding(
                    padding:
                    EdgeInsets.only(
                      right:
                      index == 6
                          ? 0
                          : 6,
                    ),
                    child: SizedBox(
                      height: 42,
                      child: Material(
                        color: isSelected
                            ? const Color(
                          0xFF172B4D,
                        )
                            : const Color(
                          0xFFF5F7FB,
                        ),
                        borderRadius:
                        BorderRadius
                            .circular(
                          12,
                        ),
                        child: InkWell(
                          borderRadius:
                          BorderRadius
                              .circular(
                            12,
                          ),
                          onTap: () {
                            ref
                                .read(
                              habitFormProvider
                                  .notifier,
                            )
                                .toggleWeeklyDay(
                              weekday,
                            );
                          },
                          child:
                          Center(
                            child:
                            Text(
                              _weekdayLabels[
                              index],
                              style:
                              TextStyle(
                                fontSize:
                                12,
                                fontWeight:
                                FontWeight
                                    .w600,
                                color:
                                isSelected
                                    ? Colors
                                    .white
                                    : const Color(
                                  0xFF34445C,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          Text(
            _weeklySummary(
              selectedDays,
            ),
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color:
              const Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // MONTHLY SELECTOR
  // =========================================================

  Widget _buildMonthlySelector(
      BuildContext context,
      WidgetRef ref,
      int selectedDay,
      ) {
    final theme =
    Theme.of(context);

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color:
          const Color(0xFFD7E2F1),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            'Repeat on',
            style: theme
                .textTheme
                .titleSmall
                ?.copyWith(
              fontWeight:
              FontWeight.w600,
              color:
              const Color(0xFF172B4D),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Choose the day of the month',
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color:
              const Color(0xFF718096),
            ),
          ),

          const SizedBox(height: 14),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              31,
                  (index) {
                final day =
                    index + 1;

                final isSelected =
                    day == selectedDay;

                return SizedBox(
                  width: 42,
                  height: 42,
                  child: Material(
                    color: isSelected
                        ? const Color(
                      0xFF172B4D,
                    )
                        : const Color(
                      0xFFF5F7FB,
                    ),
                    borderRadius:
                    BorderRadius
                        .circular(
                      12,
                    ),
                    child: InkWell(
                      borderRadius:
                      BorderRadius
                          .circular(
                        12,
                      ),
                      onTap: () {
                        ref
                            .read(
                          habitFormProvider
                              .notifier,
                        )
                            .setMonthlyDay(
                          day,
                        );
                      },
                      child: Center(
                        child: Text(
                          '$day',
                          style:
                          TextStyle(
                            fontSize:
                            12,
                            fontWeight:
                            FontWeight
                                .w600,
                            color:
                            isSelected
                                ? Colors
                                .white
                                : const Color(
                              0xFF34445C,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Text(
            _monthlySummary(
              selectedDay,
            ),
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color:
              const Color(0xFF718096),
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // WEEKLY SUMMARY
  // =========================================================

  String _weeklySummary(
      List<int> days,
      ) {
    if (days.isEmpty) {
      return 'Select at least one day.';
    }

    if (days.length == 7) {
      return 'Every day';
    }

    final sorted =
    List<int>.from(days)..sort();

    return sorted
        .where(
          (day) =>
      day >= 1 &&
          day <= 7,
    )
        .map(
          (day) =>
      _weekdayNames[day - 1],
    )
        .join(', ');
  }

  // =========================================================
  // MONTHLY SUMMARY
  // =========================================================

  String _monthlySummary(
      int day,
      ) {
    String suffix;

    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }

    return '$day$suffix day of every month';
  }
}