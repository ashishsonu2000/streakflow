import 'package:flutter/material.dart';

import '../../../../../shared/ui/cards/app_section_card.dart';
import '../../../../../shared/widgets/row/app_info_row.dart';

import '../../../domain/enums/habit_frequency.dart';
import '../../../domain/models/habit.dart';

class HabitInformation extends StatelessWidget {
  const HabitInformation({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: 'Information',
      child: Column(
        children: [
          // =========================================================
          // CATEGORY
          // =========================================================

          AppInfoRow(
            label: 'Category',
            value: _format(
              habit.category.name,
            ),
          ),

          // =========================================================
          // FREQUENCY
          // =========================================================

          AppInfoRow(
            label: 'Frequency',
            value: _frequencyText(),
          ),

          // =========================================================
          // SCHEDULE
          // =========================================================

          AppInfoRow(
            label: 'Schedule',
            value: _scheduleText(),
          ),

          // =========================================================
          // TARGET
          // =========================================================

          AppInfoRow(
            label: 'Target',
            value: _targetText(),
          ),

          // =========================================================
          // REMINDER
          // =========================================================

          AppInfoRow(
            label: 'Reminder',
            value: _reminderText(),
          ),

          // =========================================================
          // START DATE
          // =========================================================

          AppInfoRow(
            label: 'Start Date',
            value: _formatDate(
              habit.startDate,
            ),
          ),

          // =========================================================
          // END DATE
          // =========================================================

          AppInfoRow(
            label: 'End Date',
            value: _formatDate(
              habit.endDate,
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // FREQUENCY TEXT
  // ===============================================================

  String _frequencyText() {
    switch (habit.frequency) {
      case HabitFrequency.daily:
        return 'Daily';

      case HabitFrequency.weekly:
        return 'Weekly';

      case HabitFrequency.monthly:
        return 'Monthly';

      case HabitFrequency.custom:
        return 'Custom';
    }
  }

  // ===============================================================
  // SCHEDULE TEXT
  // ===============================================================

  String _scheduleText() {
    switch (habit.frequency) {
    // -----------------------------------------------------------
    // Daily
    // -----------------------------------------------------------

      case HabitFrequency.daily:
        return 'Every day';

    // -----------------------------------------------------------
    // Weekly
    // -----------------------------------------------------------

      case HabitFrequency.weekly:
        if (habit.weeklyDays.isEmpty) {
          return 'Weekly';
        }

        final days = habit.weeklyDays
            .where(
              (day) =>
          day >= 1 &&
              day <= 7,
        )
            .map(
          _weekdayName,
        )
            .toList();

        if (days.isEmpty) {
          return 'Weekly';
        }

        return days.join(', ');

    // -----------------------------------------------------------
    // Monthly
    // -----------------------------------------------------------

      case HabitFrequency.monthly:
        if (habit.monthlyDay < 1 ||
            habit.monthlyDay > 31) {
          return 'Monthly';
        }

        return '${_ordinal(habit.monthlyDay)} of every month';

    // -----------------------------------------------------------
    // Custom
    // -----------------------------------------------------------

      case HabitFrequency.custom:
        return 'Custom schedule';
    }
  }

  // ===============================================================
  // TARGET TEXT
  // ===============================================================

  String _targetText() {
    switch (habit.frequency) {
      case HabitFrequency.daily:
        return '${habit.targetPerDay}/day';

      case HabitFrequency.weekly:
        return '${habit.targetPerDay}/occurrence';

      case HabitFrequency.monthly:
        return '${habit.targetPerDay}/occurrence';

      case HabitFrequency.custom:
        return '${habit.targetPerDay}/occurrence';
    }
  }

  // ===============================================================
  // WEEKDAY NAME
  // ===============================================================

  String _weekdayName(
      int weekday,
      ) {
    const names = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return names[weekday - 1];
  }

  // ===============================================================
  // ORDINAL
  // ===============================================================

  String _ordinal(
      int number,
      ) {
    if (number >= 11 &&
        number <= 13) {
      return '${number}th';
    }

    switch (number % 10) {
      case 1:
        return '${number}st';

      case 2:
        return '${number}nd';

      case 3:
        return '${number}rd';

      default:
        return '${number}th';
    }
  }

  // ===============================================================
  // REMINDER TEXT
  // ===============================================================

  String _reminderText() {
    if (!habit.reminderEnabled) {
      return 'Off';
    }

    final hour =
        habit.reminderHour;

    final minute =
        habit.reminderMinute;

    if (hour == null ||
        minute == null) {
      return 'On';
    }

    return _formatTime(
      hour,
      minute,
    );
  }

  // ===============================================================
  // TIME FORMAT
  // ===============================================================

  String _formatTime(
      int hour,
      int minute,
      ) {
    final period =
    hour >= 12
        ? 'PM'
        : 'AM';

    final displayHour =
    hour % 12 == 0
        ? 12
        : hour % 12;

    final displayMinute =
    minute
        .toString()
        .padLeft(2, '0');

    return '$displayHour:'
        '$displayMinute '
        '$period';
  }

  // ===============================================================
  // DATE FORMAT
  // ===============================================================

  String _formatDate(
      DateTime? date,
      ) {
    if (date == null) {
      return 'No end date';
    }

    final day =
    date.day
        .toString()
        .padLeft(2, '0');

    final month =
    date.month
        .toString()
        .padLeft(2, '0');

    final year =
    date.year.toString();

    return '$day/$month/$year';
  }

  // ===============================================================
  // ENUM FORMAT
  // ===============================================================

  String _format(
      String value,
      ) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() +
        value.substring(1);
  }
}