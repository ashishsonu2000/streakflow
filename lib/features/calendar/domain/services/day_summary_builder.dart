import 'package:flutter/foundation.dart';

import '../../../habits/data/entities/habit_log_entity.dart';
import '../../../habits/domain/enums/completion_status.dart';
import '../../../habits/domain/enums/mood_type.dart';
import '../../../habits/domain/models/habit.dart';

import '../models/calendar_day_view_model.dart';
import '../models/day_habit_view_model.dart';

class DaySummaryBuilder {
  const DaySummaryBuilder();

  List<CalendarDayViewModel> build({
    required DateTime focusedMonth,
    required DateTime selectedDate,
    required List<Habit> habits,
    required List<HabitLogEntity> logs,
  }) {
    final firstDay = DateTime(
      focusedMonth.year,
      focusedMonth.month,
      1,
    );

    final startDate = firstDay.subtract(
      Duration(days: firstDay.weekday - 1),
    );

    final today = _dateOnly(
      DateTime.now(),
    );

    // =========================================================
    // Habit Lookup
    // =========================================================

    final habitLookup = <String, Habit>{
      for (final habit in habits)
        habit.id: habit,
    };

    // =========================================================
    // DEBUG - Verify calendar receives date range
    // =========================================================

    debugPrint(
      '========== CALENDAR HABIT RANGES ==========',
    );

    for (final habit in habits) {
      debugPrint(
        '${habit.title} | '
            'Start: ${habit.startDate} | '
            'End: ${habit.endDate ?? "Ongoing"}',
      );
    }

    debugPrint(
      '===========================================',
    );

    // =========================================================
    // Calendar Days
    // =========================================================

    return List.generate(
      42,
          (index) {
        final date = _dateOnly(
          startDate.add(
            Duration(days: index),
          ),
        );

        // =====================================================
        // Active Habits
        // =====================================================

        final activeHabits = habits.where(
              (habit) {
            final active =
            _isHabitActive(
              habit,
              date,
            );

            debugPrint(
              'Calendar ${_formatDate(date)} | '
                  '${habit.title} | '
                  'start=${_formatDate(habit.startDate)} | '
                  'end=${habit.endDate == null ? "Ongoing" : _formatDate(habit.endDate!)} | '
                  'active=$active',
            );

            return active;
          },
        ).toList();

        // =====================================================
        // Logs For This Date
        // =====================================================

        final dayLogs = logs.where(
              (log) {
            if (!_sameDay(
              log.date,
              date,
            )) {
              return false;
            }

            final habit =
            habitLookup[log.habitId];

            if (habit == null) {
              return false;
            }

            return _isHabitActive(
              habit,
              date,
            );
          },
        ).toList();

        // =====================================================
        // Completed Habits
        // =====================================================

        final completedHabitIds =
        dayLogs
            .where(
              (log) =>
          log.status ==
              CompletionStatus.completed,
        )
            .map(
              (log) => log.habitId,
        )
            .toSet();

        final completed =
            completedHabitIds.length;

        // =====================================================
        // XP
        // =====================================================

        final totalXP =
        dayLogs.fold<int>(
          0,
              (sum, log) =>
          sum + log.xpEarned,
        );

        // =====================================================
        // Duration
        // =====================================================

        final totalDuration =
        dayLogs.fold<int>(
          0,
              (sum, log) =>
          sum + log.durationMinutes,
        );

        // =====================================================
        // First / Last Completion
        // =====================================================

        final completedLogs =
        dayLogs
            .where(
              (log) =>
          log.status ==
              CompletionStatus.completed &&
              log.completedAt != null,
        )
            .toList()
          ..sort(
                (a, b) =>
                a.completedAt!.compareTo(
                  b.completedAt!,
                ),
          );

        DateTime? firstCompletion;
        DateTime? lastCompletion;

        if (completedLogs.isNotEmpty) {
          firstCompletion =
              completedLogs.first.completedAt;

          lastCompletion =
              completedLogs.last.completedAt;
        }

        // =====================================================
        // Dominant Mood
        // =====================================================

        MoodType? dominantMood;

        if (dayLogs.isNotEmpty) {
          final moodCounter =
          <MoodType, int>{};

          for (final log in dayLogs) {
            if (log.mood != null) {
              moodCounter.update(
                log.mood!,
                    (value) => value + 1,
                ifAbsent: () => 1,
              );
            }
          }

          if (moodCounter.isNotEmpty) {
            dominantMood =
                moodCounter.entries
                    .reduce(
                      (a, b) =>
                  a.value >= b.value
                      ? a
                      : b,
                )
                    .key;
          }
        }

        // =====================================================
        // Day Habits
        // =====================================================

        final dayHabits =
        activeHabits.map(
              (habit) {
            HabitLogEntity? habitLog;

            for (final log in dayLogs) {
              if (log.habitId ==
                  habit.id) {
                habitLog = log;
                break;
              }
            }

            final completed =
                habitLog?.status ==
                    CompletionStatus.completed;

            return DayHabitViewModel(
              id: habit.id,
              title: habit.title,
              completed: completed,
              completedAt:
              habitLog?.completedAt,
              durationMinutes:
              habitLog?.durationMinutes ?? 0,
              xpEarned:
              habitLog?.xpEarned ?? 0,
              notes:
              habitLog?.notes ?? '',
              mood:
              habitLog?.mood,
            );
          },
        ).toList();

        // =====================================================
        // Calendar Day
        // =====================================================

        return CalendarDayViewModel(
          date: date,

          isCurrentMonth:
          date.month ==
              focusedMonth.month &&
              date.year ==
                  focusedMonth.year,

          isToday:
          _sameDay(
            date,
            today,
          ),

          isSelected:
          _sameDay(
            date,
            selectedDate,
          ),

          completedHabits:
          completed,

          totalHabits:
          activeHabits.length,

          intensity:
          _calculateIntensity(
            completed,
            activeHabits.length,
          ),

          totalXP:
          totalXP,

          totalDuration:
          totalDuration,

          firstCompletion:
          firstCompletion,

          lastCompletion:
          lastCompletion,

          dominantMood:
          dominantMood,

          habits:
          dayHabits,
        );
      },
    );
  }

  // ===========================================================
  // Habit Active Check
  // ===========================================================

  bool _isHabitActive(
      Habit habit,
      DateTime date,
      ) {
    final day =
    _dateOnly(date);

    final start =
    _dateOnly(
      habit.startDate,
    );

    // Before start.
    if (day.isBefore(start)) {
      return false;
    }

    // After end.
    final end = habit.endDate;

    if (end != null) {
      final normalizedEnd =
      _dateOnly(end);

      if (day.isAfter(
        normalizedEnd,
      )) {
        return false;
      }
    }

    return true;
  }

  // ===========================================================
  // Date Only
  // ===========================================================

  DateTime _dateOnly(
      DateTime date,
      ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  // ===========================================================
  // Date Debug
  // ===========================================================

  String _formatDate(
      DateTime date,
      ) {
    final d =
    date.day.toString().padLeft(
      2,
      '0',
    );

    final m =
    date.month.toString().padLeft(
      2,
      '0',
    );

    return '$d/$m/${date.year}';
  }

  // ===========================================================
  // Same Day
  // ===========================================================

  bool _sameDay(
      DateTime a,
      DateTime b,
      ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  // ===========================================================
  // Intensity
  // ===========================================================

  int _calculateIntensity(
      int completed,
      int total,
      ) {
    if (total == 0 ||
        completed == 0) {
      return 0;
    }

    final ratio =
        completed / total;

    if (ratio >= 1.0) {
      return 4;
    }

    if (ratio >= .75) {
      return 3;
    }

    if (ratio >= .50) {
      return 2;
    }

    return 1;
  }
}