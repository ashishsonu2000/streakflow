import 'package:flutter/material.dart';

import '../../../../../shared/ui/cards/app_section_card.dart';
import '../../../../../shared/widgets/row/app_info_row.dart';

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
            value: _format(
              habit.frequency.name,
            ),
          ),

          // =========================================================
          // TARGET
          // =========================================================

          AppInfoRow(
            label: 'Target',
            value: '${habit.targetPerDay}/day',
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
  // REMINDER TEXT
  // ===============================================================

  String _reminderText() {
    if (!habit.reminderEnabled) {
      return 'Off';
    }

    final hour = habit.reminderHour;
    final minute = habit.reminderMinute;

    if (hour == null || minute == null) {
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
    final period = hour >= 12
        ? 'PM'
        : 'AM';

    final displayHour = hour % 12 == 0
        ? 12
        : hour % 12;

    final displayMinute =
    minute.toString().padLeft(2, '0');

    return '$displayHour:$displayMinute $period';
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
    date.day.toString().padLeft(2, '0');

    final month =
    date.month.toString().padLeft(2, '0');

    final year =
    date.year.toString();

    return '$day/$month/$year';
  }

  // ===============================================================
  // ENUM FORMAT
  // ===============================================================

  String _format(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() +
        value.substring(1);
  }
}