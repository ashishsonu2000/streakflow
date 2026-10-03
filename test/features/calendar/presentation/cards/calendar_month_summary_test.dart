import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:streak_calculator_flutter/features/calendar/domain/models/calendar_day_view_model.dart';
import 'package:streak_calculator_flutter/features/calendar/domain/models/calendar_view_model.dart';
import 'package:streak_calculator_flutter/features/calendar/presentation/cards/calendar_month_summary.dart';

void main() {
  group('CalendarMonthSummary', () {
    // ===============================================================
    // BASIC RENDERING
    // ===============================================================

    testWidgets(
      'renders all three summary labels',
          (tester) async {
        final calendar = _calendar(
          days: [
            _day(
              date: DateTime(2026, 8, 1),
              completedHabits: 1,
              totalHabits: 2,
            ),
          ],
        );

        await tester.pumpWidget(
          _testApp(
            CalendarMonthSummary(
              calendar: calendar,
            ),
          ),
        );

        expect(
          find.text('Active days'),
          findsOneWidget,
        );

        expect(
          find.text('Completions'),
          findsOneWidget,
        );

        expect(
          find.text('Completion'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // ACTIVE DAYS
    // ===============================================================

    testWidgets(
      'counts days with activity as active days',
          (tester) async {
        final calendar = _calendar(
          days: [
            _day(
              date: DateTime(2026, 8, 1),
              completedHabits: 1,
              totalHabits: 2,
            ),
            _day(
              date: DateTime(2026, 8, 2),
              completedHabits: 0,
              totalHabits: 2,
            ),
            _day(
              date: DateTime(2026, 8, 3),
              completedHabits: 2,
              totalHabits: 2,
            ),
          ],
        );

        await tester.pumpWidget(
          _testApp(
            CalendarMonthSummary(
              calendar: calendar,
            ),
          ),
        );

        expect(
          find.text('2'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // COMPLETIONS
    // ===============================================================

    testWidgets(
      'calculates completed habits and total possible completions',
          (tester) async {
        final calendar = _calendar(
          days: [
            _day(
              date: DateTime(2026, 8, 1),
              completedHabits: 1,
              totalHabits: 3,
            ),
            _day(
              date: DateTime(2026, 8, 2),
              completedHabits: 2,
              totalHabits: 4,
            ),
            _day(
              date: DateTime(2026, 8, 3),
              completedHabits: 0,
              totalHabits: 2,
            ),
          ],
        );

        await tester.pumpWidget(
          _testApp(
            CalendarMonthSummary(
              calendar: calendar,
            ),
          ),
        );

        // 1 + 2 + 0 = 3
        // 3 + 4 + 2 = 9
        expect(
          find.text('3 / 9'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // COMPLETION RATE
    // ===============================================================

    testWidgets(
      'calculates completion percentage correctly',
          (tester) async {
        final calendar = _calendar(
          days: [
            _day(
              date: DateTime(2026, 8, 1),
              completedHabits: 3,
              totalHabits: 4,
            ),
            _day(
              date: DateTime(2026, 8, 2),
              completedHabits: 2,
              totalHabits: 4,
            ),
          ],
        );

        await tester.pumpWidget(
          _testApp(
            CalendarMonthSummary(
              calendar: calendar,
            ),
          ),
        );

        // 5 / 8 = 62.5%, rounded = 63%.
        expect(
          find.text('63%'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // ZERO COMPLETIONS
    // ===============================================================

    testWidgets(
      'shows zero completion when there are no possible completions',
          (tester) async {
        final calendar = _calendar(
          days: [
            _day(
              date: DateTime(2026, 8, 1),
              completedHabits: 0,
              totalHabits: 0,
            ),
            _day(
              date: DateTime(2026, 8, 2),
              completedHabits: 0,
              totalHabits: 0,
            ),
          ],
        );

        await tester.pumpWidget(
          _testApp(
            CalendarMonthSummary(
              calendar: calendar,
            ),
          ),
        );

        expect(
          find.text('0'),
          findsOneWidget,
        );

        expect(
          find.text('0 / 0'),
          findsOneWidget,
        );

        expect(
          find.text('0%'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // ONLY CURRENT MONTH
    // ===============================================================

    testWidgets(
      'ignores days outside the current month',
          (tester) async {
        final calendar = _calendar(
          days: [
            // Current month.
            _day(
              date: DateTime(2026, 8, 10),
              isCurrentMonth: true,
              completedHabits: 2,
              totalHabits: 4,
            ),

            // Previous month.
            _day(
              date: DateTime(2026, 7, 31),
              isCurrentMonth: false,
              completedHabits: 10,
              totalHabits: 10,
            ),

            // Next month.
            _day(
              date: DateTime(2026, 9, 1),
              isCurrentMonth: false,
              completedHabits: 10,
              totalHabits: 10,
            ),
          ],
        );

        await tester.pumpWidget(
          _testApp(
            CalendarMonthSummary(
              calendar: calendar,
            ),
          ),
        );

        // Only August:
        // completed = 2
        // total = 4
        // completion = 50%
        expect(
          find.text('2 / 4'),
          findsOneWidget,
        );

        expect(
          find.text('50%'),
          findsOneWidget,
        );

        expect(
          find.text('1'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // PARTIAL COMPLETION
    // ===============================================================

    testWidgets(
      'handles partially completed month',
          (tester) async {
        final calendar = _calendar(
          days: [
            _day(
              date: DateTime(2026, 8, 1),
              completedHabits: 1,
              totalHabits: 2,
            ),
            _day(
              date: DateTime(2026, 8, 2),
              completedHabits: 1,
              totalHabits: 2,
            ),
            _day(
              date: DateTime(2026, 8, 3),
              completedHabits: 0,
              totalHabits: 2,
            ),
            _day(
              date: DateTime(2026, 8, 4),
              completedHabits: 0,
              totalHabits: 2,
            ),
          ],
        );

        await tester.pumpWidget(
          _testApp(
            CalendarMonthSummary(
              calendar: calendar,
            ),
          ),
        );

        expect(
          find.text('2 / 8'),
          findsOneWidget,
        );

        expect(
          find.text('25%'),
          findsOneWidget,
        );

        expect(
          find.text('2'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // PERFECT COMPLETION
    // ===============================================================

    testWidgets(
      'shows 100 percent when all possible completions are complete',
          (tester) async {
        final calendar = _calendar(
          days: [
            _day(
              date: DateTime(2026, 8, 1),
              completedHabits: 3,
              totalHabits: 3,
            ),
            _day(
              date: DateTime(2026, 8, 2),
              completedHabits: 2,
              totalHabits: 2,
            ),
          ],
        );

        await tester.pumpWidget(
          _testApp(
            CalendarMonthSummary(
              calendar: calendar,
            ),
          ),
        );

        expect(
          find.text('5 / 5'),
          findsOneWidget,
        );

        expect(
          find.text('100%'),
          findsOneWidget,
        );

        expect(
          find.text('2'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // ICONS
    // ===============================================================

    testWidgets(
      'renders the three summary icons',
          (tester) async {
        final calendar = _calendar(
          days: [
            _day(
              date: DateTime(2026, 8, 1),
            ),
          ],
        );

        await tester.pumpWidget(
          _testApp(
            CalendarMonthSummary(
              calendar: calendar,
            ),
          ),
        );

        expect(
          find.byIcon(
            Icons.check_circle_outline_rounded,
          ),
          findsOneWidget,
        );

        expect(
          find.byIcon(
            Icons.task_alt_rounded,
          ),
          findsOneWidget,
        );

        expect(
          find.byIcon(
            Icons.insights_rounded,
          ),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // CARD COUNT
    // ===============================================================

    testWidgets(
      'renders three summary cards',
          (tester) async {
        final calendar = _calendar(
          days: [
            _day(
              date: DateTime(2026, 8, 1),
            ),
          ],
        );

        await tester.pumpWidget(
          _testApp(
            CalendarMonthSummary(
              calendar: calendar,
            ),
          ),
        );

        final containers =
        tester.widgetList<Container>(
          find.byType(Container),
        );

        expect(
          containers.length,
          greaterThanOrEqualTo(3),
        );
      },
    );
  });
}

// =====================================================================
// TEST APP
// =====================================================================

Widget _testApp(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF2563EB),
    ),
    home: Scaffold(
      body: SingleChildScrollView(
        child: child,
      ),
    ),
  );
}

// =====================================================================
// CALENDAR VIEW MODEL FACTORY
// =====================================================================
//
// NOTE:
// CalendarViewModel's exact constructor was not supplied in the
// conversation. This helper assumes it accepts a required `days`
// parameter. If your constructor has additional required parameters,
// paste CalendarViewModel and I will adjust this helper exactly.

CalendarViewModel _calendar({
  required List<CalendarDayViewModel> days,
  DateTime? focusedMonth,
  DateTime? selectedDate,
  String? monthName,
}) {
  final month = focusedMonth ?? DateTime(2026, 8);

  return CalendarViewModel(
    days: days,
    focusedMonth: month,
    selectedDate:
    selectedDate ?? DateTime(2026, 8, 15),
    monthName:
    monthName ?? 'August 2026',
  );
}

// =====================================================================
// DAY FACTORY
// =====================================================================

CalendarDayViewModel _day({
  required DateTime date,
  bool isCurrentMonth = true,
  bool isToday = false,
  bool isSelected = false,
  int completedHabits = 0,
  int totalHabits = 0,
  int intensity = 0,
  int totalXP = 0,
  int totalDuration = 0,
  DateTime? firstCompletion,
  DateTime? lastCompletion,
}) {
  return CalendarDayViewModel(
    date: date,
    isCurrentMonth: isCurrentMonth,
    isToday: isToday,
    isSelected: isSelected,
    completedHabits: completedHabits,
    totalHabits: totalHabits,
    intensity: intensity,
    totalXP: totalXP,
    totalDuration: totalDuration,
    firstCompletion: firstCompletion,
    lastCompletion: lastCompletion,
    dominantMood: null,
    habits: const [],
  );
}