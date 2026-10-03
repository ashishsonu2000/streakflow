import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_statistics.dart';
import 'package:streak_calculator_flutter/features/habits/presentation/widgets/statistics/habit_stats_overview_view.dart';

void main() {
  testWidgets(
    'completion rate (a 0-1 fraction) is shown as a percentage',
    (tester) async {
      const statistics = HabitStatistics(
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
        weeklyProgress: [],
        monthlyProgress: [],
        yearlyProgress: [],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HabitStatsOverviewView(statistics: statistics),
            ),
          ),
        ),
      );

      expect(find.text('60.0%'), findsOneWidget);
      expect(find.text('64.3%'), findsOneWidget);
      expect(find.text('0.6%'), findsNothing);
    },
  );
}
