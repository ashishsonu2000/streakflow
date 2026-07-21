import '../../../habits/domain/enums/completion_status.dart';
import '../../../habits/data/entities/habit_log_entity.dart';
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

    final today = DateTime.now();

    return List.generate(
      42,
      (index) {
        final date = startDate.add(
          Duration(days: index),
        );

        //------------------------------------------
        // Logs for this date
        //------------------------------------------

        final dayLogs = logs
            .where(
              (log) => _sameDay(log.date, date),
            )
            .toList();

        //------------------------------------------
        // Completed Count
        //------------------------------------------

        final completed = dayLogs
            .where(
              (log) => log.status == CompletionStatus.completed,
            )
            .length;

        //------------------------------------------
        // XP
        //------------------------------------------

        final totalXP = dayLogs.fold<int>(
          0,
          (sum, log) => sum + log.xpEarned,
        );

        //------------------------------------------
        // Duration
        //------------------------------------------

        final totalDuration = dayLogs.fold<int>(
          0,
          (sum, log) => sum + log.durationMinutes,
        );

        //------------------------------------------
        // First / Last Completion
        //------------------------------------------

        final completedLogs = dayLogs
            .where(
              (log) => log.completedAt != null,
            )
            .toList()
          ..sort(
            (a, b) => a.completedAt!.compareTo(
              b.completedAt!,
            ),
          );

        DateTime? firstCompletion;
        DateTime? lastCompletion;

        if (completedLogs.isNotEmpty) {
          firstCompletion = completedLogs.first.completedAt;

          lastCompletion = completedLogs.last.completedAt;
        }

        //------------------------------------------
        // Dominant Mood
        //------------------------------------------

        MoodType? dominantMood;

        if (dayLogs.isNotEmpty) {
          final moodCounter = <MoodType, int>{};

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
            dominantMood = moodCounter.entries
                .reduce(
                  (a, b) => a.value >= b.value ? a : b,
                )
                .key;
          }
        }

        //------------------------------------------
        // Calendar Day
        //------------------------------------------
        //------------------------------------------
// Habit Lookup
//------------------------------------------

        final habitLookup = <String, Habit>{
          for (final habit in habits) habit.id: habit,
        };

//------------------------------------------
// Day Habit View Models
//------------------------------------------

        final dayHabits = dayLogs.map((log) {
          final habit = habitLookup[log.habitId];

          return DayHabitViewModel(
            id: log.habitId,
            title: habit?.title ?? 'Unknown Habit',
            completed: log.status == CompletionStatus.completed,
            completedAt: log.completedAt,
            durationMinutes: log.durationMinutes,
            xpEarned: log.xpEarned,
            notes: log.notes,
            mood: log.mood,
          );
        }).toList();

//------------------------------------------
// Calendar Day
//------------------------------------------

        return CalendarDayViewModel(
          date: date,
          isCurrentMonth: date.month == focusedMonth.month &&
              date.year == focusedMonth.year,
          isToday: _sameDay(
            date,
            today,
          ),
          isSelected: _sameDay(
            date,
            selectedDate,
          ),
          completedHabits: completed,
          totalHabits: habits.length,
          intensity: _calculateIntensity(
            completed,
            habits.length,
          ),
          totalXP: totalXP,
          totalDuration: totalDuration,
          firstCompletion: firstCompletion,
          lastCompletion: lastCompletion,
          dominantMood: dominantMood,
          habits: dayHabits,
        );
      },
    );
  }

  //----------------------------------------------------------
  // Helpers
  //----------------------------------------------------------

  bool _sameDay(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int _calculateIntensity(
    int completed,
    int total,
  ) {
    if (total == 0 || completed == 0) {
      return 0;
    }

    final ratio = completed / total;

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
