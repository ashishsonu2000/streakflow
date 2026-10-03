import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:streak_calculator_flutter/features/statistics/domain/models/weekday_statistics.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/weekly_statistics.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/weekly_trend.dart';
import 'package:streak_calculator_flutter/features/statistics/presentation/widgets/weekly/weekly_summary_card.dart';

void main() {
  group('WeeklySummaryCard', () {
    // ===============================================================
    // BASIC RENDERING
    // ===============================================================

    testWidgets(
      'renders This Week title',
          (tester) async {
        final weekly = _weekly();

        await tester.pumpWidget(
          _testApp(
            WeeklySummaryCard(
              weekly: weekly,
            ),
          ),
        );

        expect(
          find.text('This Week'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders all metric labels',
          (tester) async {
        final weekly = _weekly();

        await tester.pumpWidget(
          _testApp(
            WeeklySummaryCard(
              weekly: weekly,
            ),
          ),
        );

        expect(
          find.text('Completion'),
          findsOneWidget,
        );

        expect(
          find.text('Completed'),
          findsOneWidget,
        );

        expect(
          find.text('XP'),
          findsOneWidget,
        );

        expect(
          find.text('Duration'),
          findsOneWidget,
        );

        expect(
          find.text('Active Days'),
          findsOneWidget,
        );

        expect(
          find.text('Trend'),
          findsOneWidget,
        );

        expect(
          find.text('Best Day'),
          findsOneWidget,
        );

        expect(
          find.text('Needs Attention'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // COMPLETION
    // ===============================================================

    testWidgets(
      'displays completion percentage',
          (tester) async {
        final weekly = _weekly(
          completionRate: 0.75,
        );

        await tester.pumpWidget(
          _testApp(
            WeeklySummaryCard(
              weekly: weekly,
            ),
          ),
        );

        expect(
          find.text('75%'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'rounds completion percentage to zero decimal places',
          (tester) async {
        final weekly = _weekly(
          completionRate: 0.756,
        );

        await tester.pumpWidget(
          _testApp(
            WeeklySummaryCard(
              weekly: weekly,
            ),
          ),
        );

        expect(
          find.text('76%'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // COMPLETED
    // ===============================================================

    testWidgets(
      'displays completed versus target',
          (tester) async {
        final weekly = _weekly(
          totalCompleted: 17,
          totalTarget: 21,
        );

        await tester.pumpWidget(
          _testApp(
            WeeklySummaryCard(
              weekly: weekly,
            ),
          ),
        );

        expect(
          find.text('17/21'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // XP
    // ===============================================================

    testWidgets(
      'displays total XP',
          (tester) async {
        final weekly = _weekly(
          totalXP: 125,
        );

        await tester.pumpWidget(
          _testApp(
            WeeklySummaryCard(
              weekly: weekly,
            ),
          ),
        );

        expect(
          find.text('125'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // DURATION
    // ===============================================================

    testWidgets(
      'displays duration in minutes',
          (tester) async {
        final weekly = _weekly(
          totalDurationMinutes: 240,
        );

        await tester.pumpWidget(
          _testApp(
            WeeklySummaryCard(
              weekly: weekly,
            ),
          ),
        );

        expect(
          find.text('240 min'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // ACTIVE DAYS
    // ===============================================================

    testWidgets(
      'displays active days out of seven',
          (tester) async {
        final weekly = _weekly(
          activeDays: 5,
        );

        await tester.pumpWidget(
          _testApp(
            WeeklySummaryCard(
              weekly: weekly,
            ),
          ),
        );

        expect(
          find.text('5/7'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // TREND - IMPROVING
    // ===============================================================

    testWidgets(
      'displays improving trend percentage',
          (tester) async {
        final weekly = _weekly(
          trend: WeeklyTrend.improving,
          weeklyChangePercentage: 12.5,
        );

        await tester.pumpWidget(
          _testApp(
            WeeklySummaryCard(
              weekly: weekly,
            ),
          ),
        );

        expect(
          find.text('12.5%'),
          findsOneWidget,
        );

        expect(
          find.byIcon(
            Icons.trending_up_rounded,
          ),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // TREND - DECLINING
    // ===============================================================

    testWidgets(
      'displays declining trend percentage',
          (tester) async {
        final weekly = _weekly(
          trend: WeeklyTrend.declining,
          weeklyChangePercentage: -8.4,
        );

        await tester.pumpWidget(
          _testApp(
            WeeklySummaryCard(
              weekly: weekly,
            ),
          ),
        );

        expect(
          find.text('-8.4%'),
          findsOneWidget,
        );

        expect(
          find.byIcon(
            Icons.trending_down_rounded,
          ),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // TREND - STABLE
    // ===============================================================

    testWidgets(
      'displays stable trend percentage',
          (tester) async {
        final weekly = _weekly(
          trend: WeeklyTrend.stable,
          weeklyChangePercentage: 0.0,
        );

        await tester.pumpWidget(
          _testApp(
            WeeklySummaryCard(
              weekly: weekly,
            ),
          ),
        );

        expect(
          find.text('0.0%'),
          findsOneWidget,
        );

        expect(
          find.byIcon(
            Icons.trending_flat_rounded,
          ),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // BEST DAY
    // ===============================================================

    testWidgets(
      'displays best day weekday',
          (tester) async {
        final weekly = _weekly(
          bestDay: _weekday(
            DateTime(2026, 8, 17), // Monday
          ),
        );

        await tester.pumpWidget(
          _testApp(
            WeeklySummaryCard(
              weekly: weekly,
            ),
          ),
        );

        expect(
          find.text('Mon'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // WORST DAY
    // ===============================================================

    testWidgets(
      'displays needs attention weekday',
          (tester) async {
        final weekly = _weekly(
          worstDay: _weekday(
            DateTime(2026, 8, 21), // Friday
          ),
        );

        await tester.pumpWidget(
          _testApp(
            WeeklySummaryCard(
              weekly: weekly,
            ),
          ),
        );

        expect(
          find.text('Fri'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // WEEKDAY MAPPING
    // ===============================================================

    testWidgets(
      'maps all weekdays correctly',
          (tester) async {
        final weekly = _weekly(
          bestDay: _weekday(
            DateTime(2026, 8, 20), // Thursday
          ),
          worstDay: _weekday(
            DateTime(2026, 8, 23), // Sunday
          ),
        );

        await tester.pumpWidget(
          _testApp(
            WeeklySummaryCard(
              weekly: weekly,
            ),
          ),
        );

        expect(
          find.text('Thu'),
          findsOneWidget,
        );

        expect(
          find.text('Sun'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // ZERO VALUES
    // ===============================================================

    testWidgets(
      'renders zero values correctly',
          (tester) async {
        final weekly = _weekly(
          completionRate: 0,
          totalCompleted: 0,
          totalTarget: 0,
          totalXP: 0,
          totalDurationMinutes: 0,
          activeDays: 0,
          weeklyChangePercentage: 0,
        );

        await tester.pumpWidget(
          _testApp(
            WeeklySummaryCard(
              weekly: weekly,
            ),
          ),
        );

        expect(
          find.text('0%'),
          findsOneWidget,
        );

        expect(
          find.text('0/0'),
          findsOneWidget,
        );

        expect(
          find.text('0 min'),
          findsOneWidget,
        );

        expect(
          find.text('0/7'),
          findsOneWidget,
        );

        expect(
          find.text('0.0%'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // NEGATIVE TREND
    // ===============================================================

    testWidgets(
      'preserves negative trend percentage',
          (tester) async {
        final weekly = _weekly(
          weeklyChangePercentage: -25.7,
          trend: WeeklyTrend.declining,
        );

        await tester.pumpWidget(
          _testApp(
            WeeklySummaryCard(
              weekly: weekly,
            ),
          ),
        );

        expect(
          find.text('-25.7%'),
          findsOneWidget,
        );

        expect(
          find.byIcon(
            Icons.trending_down_rounded,
          ),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // HIGH COMPLETION
    // ===============================================================

    testWidgets(
      'renders 100 percent completion',
          (tester) async {
        final weekly = _weekly(
          completionRate: 1.0,
          totalCompleted: 21,
          totalTarget: 21,
          activeDays: 7,
        );

        await tester.pumpWidget(
          _testApp(
            WeeklySummaryCard(
              weekly: weekly,
            ),
          ),
        );

        expect(
          find.text('100%'),
          findsOneWidget,
        );

        expect(
          find.text('21/21'),
          findsOneWidget,
        );

        expect(
          find.text('7/7'),
          findsOneWidget,
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
// WEEKLY STATISTICS FACTORY
// =====================================================================

WeeklyStatistics _weekly({
  List<WeekdayStatistics>? days,
  double completionRate = 0.5,
  double previousWeekCompletionRate = 0.4,
  double weeklyChangePercentage = 10.0,
  WeeklyTrend trend = WeeklyTrend.improving,
  int totalCompleted = 10,
  int totalTarget = 20,
  int totalXP = 100,
  int totalDurationMinutes = 120,
  int activeDays = 5,
  WeekdayStatistics? bestDay,
  WeekdayStatistics? worstDay,
}) {
  final defaultDays = List.generate(
    7,
        (index) => _weekday(
      DateTime(2026, 8, 17 + index),
    ),
  );

  return WeeklyStatistics(
    days: days ?? defaultDays,
    completionRate: completionRate,
    previousWeekCompletionRate:
    previousWeekCompletionRate,
    weeklyChangePercentage:
    weeklyChangePercentage,
    trend: trend,
    totalCompleted: totalCompleted,
    totalTarget: totalTarget,
    totalXP: totalXP,
    totalDurationMinutes:
    totalDurationMinutes,
    activeDays: activeDays,
    bestDay: bestDay ??
        _weekday(
          DateTime(2026, 8, 17),
        ),
    worstDay: worstDay ??
        _weekday(
          DateTime(2026, 8, 18),
        ),
  );
}

// =====================================================================
// WEEKDAY FACTORY
// =====================================================================

WeekdayStatistics _weekday(
    DateTime date, {
      int completedHabits = 1,
      int targetHabits = 2,
      double completionRate = 0.5,
      int totalXP = 10,
      int totalDurationMinutes = 20,
      bool isPerfectDay = false,
    }) {
  return WeekdayStatistics(
    date: date,
    completedHabits: completedHabits,
    targetHabits: targetHabits,
    completionRate: completionRate,
    totalXP: totalXP,
    totalDurationMinutes: totalDurationMinutes,
    isPerfectDay: isPerfectDay,
  );
}