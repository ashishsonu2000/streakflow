import '../../../habits/domain/models/habit.dart';
import '../../../habits/domain/models/habit_log.dart';

/// Builds spreadsheet-friendly CSV (RFC 4180) from habits and history.
///
/// Pure: no I/O, so it is unit tested directly.
abstract final class CsvExporter {
  static const habitsHeader = [
    'habit_id',
    'title',
    'description',
    'category',
    'frequency',
    'target_per_day',
    'status',
    'current_streak',
    'best_streak',
    'total_completed',
    'xp',
    'start_date',
    'end_date',
    'reminder',
    'created_at',
  ];

  static const historyHeader = [
    'date',
    'habit_id',
    'habit_title',
    'status',
    'completed_at',
    'duration_minutes',
    'xp_earned',
    'mood',
    'notes',
  ];

  static String habitsCsv(List<Habit> habits) {
    final rows = <List<Object?>>[
      habitsHeader,
      for (final h in habits)
        [
          h.id,
          h.title,
          h.description,
          h.category.name,
          h.frequency.name,
          h.targetPerDay,
          h.archived ? 'archived' : 'active',
          h.currentStreak,
          h.bestStreak,
          h.totalCompleted,
          h.xp,
          _date(h.startDate),
          _date(h.endDate),
          _reminders(h),
          _dateTime(h.createdAt),
        ],
    ];

    return _encode(rows);
  }

  /// History rows sorted by date (oldest first), with habit titles.
  static String historyCsv(List<HabitLog> logs, List<Habit> habits) {
    final titles = {for (final h in habits) h.id: h.title};

    final sorted = [...logs]..sort((a, b) {
        final byDate = a.date.compareTo(b.date);
        return byDate != 0 ? byDate : a.habitId.compareTo(b.habitId);
      });

    final rows = <List<Object?>>[
      historyHeader,
      for (final log in sorted)
        [
          _date(log.date),
          log.habitId,
          titles[log.habitId] ?? '',
          log.status.name,
          _dateTime(log.completedAt),
          log.durationMinutes,
          log.xpEarned,
          log.mood?.name ?? '',
          log.notes,
        ],
    ];

    return _encode(rows);
  }

  // ===================================================================
  // ENCODING
  // ===================================================================

  static String _encode(List<List<Object?>> rows) {
    // CRLF line endings per RFC 4180 (and what Excel expects).
    return '${rows.map((row) => row.map(_cell).join(',')).join('\r\n')}\r\n';
  }

  static String _cell(Object? value) {
    var text = value?.toString() ?? '';

    // Spreadsheet formula injection: never let user text start a
    // formula when the file is opened in Excel / Sheets.
    if (text.isNotEmpty && '=+-@\t\r'.contains(text[0]) && value is String) {
      text = "'$text";
    }

    final needsQuotes = text.contains(',') ||
        text.contains('"') ||
        text.contains('\n') ||
        text.contains('\r');

    return needsQuotes ? '"${text.replaceAll('"', '""')}"' : text;
  }

  static String _two(int n) => n.toString().padLeft(2, '0');

  /// "07:00" or "07:00; 12:30; 21:00" (primary first, then extras).
  static String _reminders(Habit h) {
    if (!h.reminderEnabled || h.reminderHour == null) {
      return '';
    }

    final times = [
      h.reminderHour! * 60 + (h.reminderMinute ?? 0),
      ...h.additionalReminderMinutes,
    ];

    return times.map((m) => '${_two(m ~/ 60)}:${_two(m % 60)}').join('; ');
  }

  static String _date(DateTime? d) =>
      d == null ? '' : '${d.year}-${_two(d.month)}-${_two(d.day)}';

  static String _dateTime(DateTime? d) => d == null
      ? ''
      : '${_date(d)} ${_two(d.hour)}:${_two(d.minute)}:${_two(d.second)}';
}
