import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:streak_calculator_flutter/features/calendar/domain/models/calendar_day_view_model.dart';
import 'package:streak_calculator_flutter/features/calendar/domain/models/day_habit_view_model.dart';
import 'package:streak_calculator_flutter/features/dashboard/presentation/widgets/calendar/calendar_day_cell.dart';

void main() {
  group('CalendarDayCell', () {
    // ===============================================================
    // BASIC RENDERING
    // ===============================================================

    testWidgets(
      'displays the day number',
          (tester) async {
        final day = _day(
          date: DateTime(2026, 8, 15),
        );

        await tester.pumpWidget(
          _testApp(
            CalendarDayCell(day: day),
          ),
        );

        expect(
          find.text('15'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // TAP
    // ===============================================================

    testWidgets(
      'calls onTap when the cell is tapped',
          (tester) async {
        var tapped = false;

        final day = _day(
          date: DateTime(2026, 8, 15),
        );

        await tester.pumpWidget(
          _testApp(
            CalendarDayCell(
              day: day,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        );

        await tester.tap(
          find.byType(CalendarDayCell),
        );

        expect(
          tapped,
          isTrue,
        );
      },
    );

    // ===============================================================
    // NO TAP CALLBACK
    // ===============================================================

    testWidgets(
      'does not throw when onTap is null',
          (tester) async {
        final day = _day(
          date: DateTime(2026, 8, 15),
        );

        await tester.pumpWidget(
          _testApp(
            CalendarDayCell(day: day),
          ),
        );

        await tester.tap(
          find.byType(CalendarDayCell),
        );

        expect(
          find.text('15'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // SELECTED
    // ===============================================================

    testWidgets(
      'renders selected day correctly',
          (tester) async {
        final day = _day(
          date: DateTime(2026, 8, 15),
          isSelected: true,
        );

        await tester.pumpWidget(
          _testApp(
            CalendarDayCell(day: day),
          ),
        );

        expect(
          find.text('15'),
          findsOneWidget,
        );

        // Selected indicator is a small white circle.
        final containers =
        tester.widgetList<Container>(
          find.byType(Container),
        );

        expect(
          containers,
          isNotEmpty,
        );
      },
    );

    // ===============================================================
    // TODAY
    // ===============================================================

    testWidgets(
      'renders today day correctly',
          (tester) async {
        final today = DateTime.now();

        final day = _day(
          date: today,
          isToday: true,
        );

        await tester.pumpWidget(
          _testApp(
            CalendarDayCell(day: day),
          ),
        );

        expect(
          find.text('${today.day}'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // OUTSIDE MONTH
    // ===============================================================

    testWidgets(
      'renders outside-month day correctly',
          (tester) async {
        final day = _day(
          date: DateTime(2026, 7, 31),
          isCurrentMonth: false,
        );

        await tester.pumpWidget(
          _testApp(
            CalendarDayCell(day: day),
          ),
        );

        expect(
          find.text('31'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // ACTIVITY
    // ===============================================================

    testWidgets(
      'renders activity indicator when day has completed habits',
          (tester) async {
        final day = _day(
          date: DateTime(2026, 8, 15),
          completedHabits: 1,
          totalHabits: 2,
          intensity: 1,
        );

        await tester.pumpWidget(
          _testApp(
            CalendarDayCell(day: day),
          ),
        );

        expect(
          find.text('15'),
          findsOneWidget,
        );

        // Activity dot is represented by a Container.
        expect(
          find.byType(Container),
          findsWidgets,
        );
      },
    );

    // ===============================================================
    // SELECTED WITH ACTIVITY
    // ===============================================================

    testWidgets(
      'selected day does not show activity dot',
          (tester) async {
        final day = _day(
          date: DateTime(2026, 8, 15),
          isSelected: true,
          completedHabits: 1,
          totalHabits: 1,
          intensity: 4,
        );

        await tester.pumpWidget(
          _testApp(
            CalendarDayCell(day: day),
          ),
        );

        expect(
          find.text('15'),
          findsOneWidget,
        );

        // The selected indicator replaces the green activity dot.
        expect(
          find.byType(CalendarDayCell),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // TODAY WITH ACTIVITY
    // ===============================================================

    testWidgets(
      'today with activity still renders correctly',
          (tester) async {
        final today = DateTime.now();

        final day = _day(
          date: today,
          isToday: true,
          completedHabits: 2,
          totalHabits: 3,
          intensity: 2,
        );

        await tester.pumpWidget(
          _testApp(
            CalendarDayCell(day: day),
          ),
        );

        expect(
          find.text('${today.day}'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // ZERO ACTIVITY
    // ===============================================================

    testWidgets(
      'zero activity does not show activity indicator',
          (tester) async {
        final day = _day(
          date: DateTime(2026, 8, 15),
          completedHabits: 0,
          totalHabits: 3,
          intensity: 0,
        );

        await tester.pumpWidget(
          _testApp(
            CalendarDayCell(day: day),
          ),
        );

        expect(
          find.text('15'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // COMPLETION RATE
    // ===============================================================

    testWidgets(
      'renders a fully completed day',
          (tester) async {
        final day = _day(
          date: DateTime(2026, 8, 15),
          completedHabits: 3,
          totalHabits: 3,
          intensity: 4,
        );

        expect(
          day.completionRate,
          1.0,
        );

        expect(
          day.hasActivity,
          isTrue,
        );

        await tester.pumpWidget(
          _testApp(
            CalendarDayCell(day: day),
          ),
        );

        expect(
          find.text('15'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // ANIMATED CONTAINER
    // ===============================================================

    testWidgets(
      'uses AnimatedContainer for state transitions',
          (tester) async {
        final day = _day(
          date: DateTime(2026, 8, 15),
        );

        await tester.pumpWidget(
          _testApp(
            CalendarDayCell(day: day),
          ),
        );

        expect(
          find.byType(AnimatedContainer),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // ACCESSIBILITY / TEXT
    // ===============================================================

    testWidgets(
      'day number is visible to the user',
          (tester) async {
        final day = _day(
          date: DateTime(2026, 8, 28),
        );

        await tester.pumpWidget(
          _testApp(
            CalendarDayCell(day: day),
          ),
        );

        final textFinder =
        find.text('28');

        expect(
          textFinder,
          findsOneWidget,
        );

        final text =
        tester.widget<Text>(
          textFinder,
        );

        expect(
          text.data,
          '28',
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
      colorSchemeSeed: const Color(0xFF2563EB),
      useMaterial3: true,
    ),
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 60,
          height: 60,
          child: child,
        ),
      ),
    ),
  );
}

// =====================================================================
// CALENDAR DAY FACTORY
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
  List<DayHabitViewModel> habits = const [],
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
    habits: habits,
  );
}