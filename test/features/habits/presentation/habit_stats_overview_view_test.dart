import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_day_statistics.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_statistics.dart';
import 'package:streak_calculator_flutter/features/habits/presentation/widgets/statistics/habit_stats_overview_view.dart';
import 'package:streak_calculator_flutter/features/habits/presentation/widgets/statistics/habit_stats_week_view.dart';

HabitStatistics _statistics({
  List<HabitDayStatistics> week = const [],
}) {
  return HabitStatistics(
    currentStreak: 0,
    bestStreak: 3,
    totalCompleted: 9,
    totalMissed: 5,
    totalTrackedDays: 14,
    activeDays: 9,
    totalXP: 45,
    completionRate: 0.6,
    successRate: 64.3,
    averagePerWeek: 2,
    longestGap: 4,
    weeklyProgress: week,
    monthlyProgress: const [],
    yearlyProgress: const [],
  );
}

// Mon done, Tue not scheduled, Wed scheduled but missed.
final _week = [
  HabitDayStatistics(
    date: DateTime(2026, 9, 28),
    completed: true,
    isWithinHabitRange: true,
  ),
  HabitDayStatistics(
    date: DateTime(2026, 9, 29),
    completed: false,
    isWithinHabitRange: false,
  ),
  HabitDayStatistics(
    date: DateTime(2026, 9, 30),
    completed: false,
    isWithinHabitRange: true,
  ),
];

/// The day-status icon with this screen-reader label.
Finder _dayIcon(String label) => find.byWidgetPredicate(
      (widget) => widget is Icon && widget.semanticLabel == label,
    );

Future<void> _pump(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: child),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'completion rate (a 0-1 fraction) is shown as a percentage',
    (tester) async {
      await _pump(
        tester,
        HabitStatsOverviewView(statistics: _statistics()),
      );

      expect(find.text('60.0%'), findsOneWidget);
      expect(find.text('64.3%'), findsOneWidget);
      expect(find.text('0.6%'), findsNothing);
    },
  );

  for (final view in <String, Widget Function(HabitStatistics)>{
    'Overview': (s) => HabitStatsOverviewView(statistics: s),
    'Week': (s) => HabitStatsWeekView(statistics: s),
  }.entries) {
    testWidgets(
      '${view.key}: days the habit is not scheduled are not shown as misses',
      (tester) async {
        await _pump(tester, view.value(_statistics(week: _week)));

        expect(_dayIcon('Completed'), findsOneWidget);
        expect(_dayIcon('Not scheduled'), findsOneWidget);
        expect(_dayIcon('Not completed'), findsOneWidget);
        expect(find.byIcon(Icons.remove_rounded), findsOneWidget);
      },
    );
  }
}
