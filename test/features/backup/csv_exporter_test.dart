import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/backup/domain/services/csv_exporter.dart';
import 'package:streak_calculator_flutter/features/habits/domain/enums/completion_status.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_log.dart';

Habit _habit({
  String id = 'h1',
  String title = 'Read',
  String description = '',
  bool archived = false,
  bool reminder = false,
}) {
  return Habit(
    id: id,
    title: title,
    description: description,
    archived: archived,
    reminderEnabled: reminder,
    reminderHour: reminder ? 7 : null,
    reminderMinute: reminder ? 5 : null,
    createdAt: DateTime(2026, 9, 1, 8, 30),
    updatedAt: DateTime(2026, 9, 1, 8, 30),
    startDate: DateTime(2026, 9, 1),
  );
}

HabitLog _log(String habitId, DateTime date) => HabitLog(
      id: '$habitId-${date.day}',
      habitId: habitId,
      date: date,
      status: CompletionStatus.completed,
      completedAt: date.add(const Duration(hours: 9)),
      durationMinutes: 15,
      notes: '',
      xpEarned: 5,
    );

List<String> _lines(String csv) =>
    csv.split('\r\n').where((l) => l.isNotEmpty).toList();

void main() {
  group('habitsCsv', () {
    test('header plus one row per habit, active and archived', () {
      final csv = CsvExporter.habitsCsv([
        _habit(reminder: true),
        _habit(id: 'h2', title: 'Old', archived: true),
      ]);
      final lines = _lines(csv);

      expect(lines.first, CsvExporter.habitsHeader.join(','));
      expect(lines, hasLength(3));
      expect(lines[1], contains('h1,Read,'));
      expect(lines[1], contains(',active,'));
      expect(lines[1], contains(',07:05,'));
      expect(lines[1], contains('2026-09-01 08:30:00'));
      expect(lines[2], contains(',archived,'));
    });

    test('uses CRLF line endings', () {
      expect(CsvExporter.habitsCsv([_habit()]), endsWith('\r\n'));
      expect(CsvExporter.habitsCsv([_habit()]), contains('\r\n'));
    });

    test('quotes commas, quotes and newlines (RFC 4180)', () {
      final csv = CsvExporter.habitsCsv([
        _habit(title: 'Run, then "stretch"', description: 'line1\nline2'),
      ]);

      expect(csv, contains('"Run, then ""stretch"""'));
      expect(csv, contains('"line1\nline2"'));
    });

    test('neutralizes spreadsheet formula injection in user text', () {
      final csv = CsvExporter.habitsCsv([
        _habit(title: '=HYPERLINK("x")', description: '+cmd'),
      ]);

      expect(csv, contains("\"'=HYPERLINK(\"\"x\"\")\""));
      expect(csv, contains(",'+cmd,"));
    });

    test('empty list still has a header', () {
      expect(_lines(CsvExporter.habitsCsv([])), hasLength(1));
    });
  });

  group('historyCsv', () {
    test('sorted by date with habit titles', () {
      final habits = [_habit(), _habit(id: 'h2', title: 'Walk')];
      final csv = CsvExporter.historyCsv([
        _log('h2', DateTime(2026, 9, 3)),
        _log('h1', DateTime(2026, 9, 2)),
      ], habits);
      final lines = _lines(csv);

      expect(lines.first, CsvExporter.historyHeader.join(','));
      expect(lines[1], startsWith('2026-09-02,h1,Read,completed,'));
      expect(lines[2], startsWith('2026-09-03,h2,Walk,completed,'));
    });

    test('negative numbers are not treated as formulas', () {
      final log = HabitLog(
        id: 'x',
        habitId: 'h1',
        date: DateTime(2026, 9, 2),
        status: CompletionStatus.completed,
        completedAt: null,
        durationMinutes: 0,
        notes: '',
        xpEarned: -5,
      );

      expect(CsvExporter.historyCsv([log], [_habit()]), contains(',-5,'));
    });

    test('log for a deleted habit keeps an empty title', () {
      final csv = CsvExporter.historyCsv(
        [_log('gone', DateTime(2026, 9, 2))],
        [_habit()],
      );

      expect(_lines(csv)[1], startsWith('2026-09-02,gone,,completed,'));
    });
  });
}
