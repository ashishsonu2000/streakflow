import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:streak_calculator_flutter/core/models/completion_trend.dart';

import 'package:streak_calculator_flutter/features/habits/domain/enums/completion_status.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_log.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_category.dart';

import 'package:streak_calculator_flutter/features/statistics/domain/models/category_distribution.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/habit_performance.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/insight.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/monthly_statistics.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/overview_statistics.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/statistics_summary.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/weekly_statistics.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/weekly_trend.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/weekday_statistics.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/xp_trend.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/yearly_statistics.dart';

import 'package:streak_calculator_flutter/features/statistics/presentation/widgets/activity/statistics_activity_section.dart';
import 'package:streak_calculator_flutter/features/statistics/presentation/widgets/common/statistics_body.dart';
import 'package:streak_calculator_flutter/features/statistics/presentation/widgets/performance/performance_section.dart';

void main() {
  group('StatisticsBody', () {
    // ===============================================================
    // OVERVIEW
    // ===============================================================

    testWidgets(
      'renders overview section',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            StatisticsBody(
              statistics: _statistics(),
            ),
          ),
        );

        expect(
          find.text('Overview'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // WEEKLY SUMMARY
    // ===============================================================

    testWidgets(
      'renders weekly summary',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            StatisticsBody(
              statistics: _statistics(),
            ),
          ),
        );

        expect(
          find.text('This Week'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // WEEKLY CHART
    // ===============================================================

    testWidgets(
      'renders weekly progress chart',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            StatisticsBody(
              statistics: _statistics(),
            ),
          ),
        );

        expect(
          find.text('Weekly Progress'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // MONTHLY SUMMARY
    // ===============================================================

    testWidgets(
      'renders monthly summary',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            StatisticsBody(
              statistics: _statistics(),
            ),
          ),
        );

        expect(
          find.text('This Month'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // MONTHLY CHART
    // ===============================================================

    testWidgets(
      'renders monthly progress chart',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            StatisticsBody(
              statistics: _statistics(),
            ),
          ),
        );

        expect(
          find.text('Monthly Progress'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // PERFORMANCE
    // ===============================================================

    testWidgets(
      'renders performance section',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            StatisticsBody(
              statistics: _statistics(
                performance: [
                  _performance(
                    title: 'Exercise',
                  ),
                ],
              ),
            ),
          ),
        );

        expect(
          find.byType(PerformanceSection),
          findsOneWidget,
        );

        expect(
          find.text('Habit Performance'),
          findsOneWidget,
        );

        expect(
          find.text('Exercise'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // ACTIVITY
    // ===============================================================

    testWidgets(
      'renders recent activity section',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            StatisticsBody(
              statistics: _statistics(
                logs: [
                  _log(),
                ],
              ),
            ),
          ),
        );

        expect(
          find.byType(
            StatisticsActivitySection,
          ),
          findsOneWidget,
        );

        expect(
          find.text('Recent Activity'),
          findsOneWidget,
        );

        expect(
          find.text('20 Aug 2026'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // INSIGHTS
    // ===============================================================

    testWidgets(
      'renders insights when available',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            StatisticsBody(
              statistics: _statistics(
                insights: [
                  const Insight(
                    title: 'Great Progress',
                    description: 'Keep going.',
                    icon: 'insights',
                  ),
                ],
              ),
            ),
          ),
        );

        expect(
          find.text('Insights'),
          findsOneWidget,
        );

        expect(
          find.text('Great Progress'),
          findsOneWidget,
        );

        expect(
          find.text('Keep going.'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // EMPTY PERFORMANCE
    // ===============================================================

    testWidgets(
      'renders empty performance state',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            StatisticsBody(
              statistics: _statistics(
                performance: [],
              ),
            ),
          ),
        );

        expect(
          find.byType(PerformanceSection),
          findsOneWidget,
        );

        expect(
          find.text('No performance data yet'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // EMPTY ACTIVITY
    // ===============================================================

    testWidgets(
      'renders empty activity state',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            StatisticsBody(
              statistics: _statistics(
                logs: [],
              ),
            ),
          ),
        );

        expect(
          find.byType(
            StatisticsActivitySection,
          ),
          findsOneWidget,
        );

        expect(
          find.text('No activity yet'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // NO INSIGHTS
    // ===============================================================

    testWidgets(
      'does not render insights section when empty',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            StatisticsBody(
              statistics: _statistics(
                insights: [],
              ),
            ),
          ),
        );

        expect(
          find.text('Insights'),
          findsNothing,
        );
      },
    );

    // ===============================================================
    // MULTIPLE PERFORMANCE ITEMS
    // ===============================================================

    testWidgets(
      'renders multiple performance items',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            StatisticsBody(
              statistics: _statistics(
                performance: [
                  _performance(
                    habitId: 'habit-1',
                    title: 'Exercise',
                  ),
                  _performance(
                    habitId: 'habit-2',
                    title: 'Reading',
                  ),
                ],
              ),
            ),
          ),
        );

        expect(
          find.text('Exercise'),
          findsOneWidget,
        );

        expect(
          find.text('Reading'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // MULTIPLE INSIGHTS
    // ===============================================================

    testWidgets(
      'renders multiple insights',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            StatisticsBody(
              statistics: _statistics(
                insights: [
                  const Insight(
                    title: 'Insight One',
                    description: 'First message.',
                    icon: 'insights',
                  ),
                  const Insight(
                    title: 'Insight Two',
                    description: 'Second message.',
                    icon: 'insights',
                  ),
                ],
              ),
            ),
          ),
        );

        expect(
          find.text('Insight One'),
          findsOneWidget,
        );

        expect(
          find.text('Insight Two'),
          findsOneWidget,
        );

        expect(
          find.text('First message.'),
          findsOneWidget,
        );

        expect(
          find.text('Second message.'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // COMPLETE COMPOSITION
    // ===============================================================

    testWidgets(
      'renders complete statistics composition',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            StatisticsBody(
              statistics: _statistics(
                performance: [
                  _performance(
                    title: 'Exercise',
                  ),
                ],
                logs: [
                  _log(),
                ],
                insights: [
                  const Insight(
                    title: 'Consistency',
                    description: 'Excellent work.',
                    icon: 'insights',
                  ),
                ],
              ),
            ),
          ),
        );

        expect(
          find.text('Overview'),
          findsOneWidget,
        );

        expect(
          find.text('This Week'),
          findsOneWidget,
        );

        expect(
          find.text('Weekly Progress'),
          findsOneWidget,
        );

        expect(
          find.text('This Month'),
          findsOneWidget,
        );

        expect(
          find.text('Monthly Progress'),
          findsOneWidget,
        );

        expect(
          find.text('Habit Performance'),
          findsOneWidget,
        );

        expect(
          find.text('Recent Activity'),
          findsOneWidget,
        );

        expect(
          find.text('Insights'),
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
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    ),
  );
}

// =====================================================================
// STATISTICS FACTORY
// =====================================================================

StatisticsSummary _statistics({
  List<HabitPerformance> performance =
  const [],
  List<HabitLog> logs = const [],
  List<Insight> insights = const [],
}) {
  return StatisticsSummary(
    overview: _overview(),
    weekly: _weekly(),
    monthly: _monthly(),
    trends: _trends(),
    performance: performance,
    insights: insights,
    logs: logs,
    categoryDistribution:
    _categoryDistribution(),
    xpTrend: _xpTrend(),
    yearly: yearly,
  );
}

// =====================================================================
// OVERVIEW
// =====================================================================

OverviewStatistics _overview() {
  return const OverviewStatistics(
    completionRate: 0.75,
    currentStreak: 5,
    bestStreak: 10,
    totalHabits: 5,
    totalCompletions: 25,
    totalXP: 250,
    totalDurationMinutes: 375,
    perfectDays: 12,
  );
}

// =====================================================================
// WEEKLY
// =====================================================================

WeeklyStatistics _weekly() {
  final days = List.generate(
    7,
        (index) {
      final date = DateTime(
        2026,
        8,
        17 + index,
      );

      return WeekdayStatistics(
        date: date,
        completedHabits: 3,
        targetHabits: 5,
        completionRate: 0.6,
        totalXP: 30,
        totalDurationMinutes: 45,
        isPerfectDay: false,
      );
    },
  );

  return WeeklyStatistics(
    days: days,
    completionRate: 0.6,
    previousWeekCompletionRate: 0.5,
    weeklyChangePercentage: 20,
    trend: WeeklyTrend.improving,
    totalCompleted: 21,
    totalTarget: 35,
    totalXP: 210,
    totalDurationMinutes: 315,
    activeDays: 7,
    bestDay: days[2],
    worstDay: days[5],
  );
}

// =====================================================================
// MONTHLY
// =====================================================================

MonthlyStatistics _monthly() {
  return const MonthlyStatistics(
    monthlyCompletionRate: 0.75,
    totalCompleted: 75,
    totalXP: 750,
    totalDurationMinutes: 1125,
    perfectDays: 12,
  );
}

// =====================================================================
// COMPLETION TRENDS
// =====================================================================

List<CompletionTrend> _trends() {
  return [
    CompletionTrend(
      date: DateTime(2026, 8, 1),
      completionRate: 0.50,
    ),
    CompletionTrend(
      date: DateTime(2026, 8, 8),
      completionRate: 0.60,
    ),
    CompletionTrend(
      date: DateTime(2026, 8, 15),
      completionRate: 0.75,
    ),
  ];
}

// =====================================================================
// PERFORMANCE
// =====================================================================

HabitPerformance _performance({
  String habitId = 'habit-1',
  String title = 'Test Habit',
  double completionRate = 0.8,
  int currentStreak = 5,
  int bestStreak = 10,
  int totalCompleted = 20,
  int totalXP = 200,
}) {
  return HabitPerformance(
    habitId: habitId,
    title: title,
    completionRate: completionRate,
    currentStreak: currentStreak,
    bestStreak: bestStreak,
    totalCompleted: totalCompleted,
    totalXP: totalXP,
  );
}

// =====================================================================
// LOG
// =====================================================================

HabitLog _log({
  String id = 'log-1',
  String habitId = 'habit-1',
}) {
  return HabitLog(
    id: id,
    habitId: habitId,
    date: DateTime(2026, 8, 20),
    status: CompletionStatus.completed,
    completedAt: DateTime(
      2026,
      8,
      20,
      9,
      30,
    ),
    durationMinutes: 15,
    notes: '',
    xpEarned: 25,
  );
}

// =====================================================================
// CATEGORY DISTRIBUTION
// =====================================================================

List<CategoryDistribution> _categoryDistribution() {
  return const [
    CategoryDistribution(
      category: HabitCategory.health,
      count: 2,
      percentage: 0.40,
    ),
    CategoryDistribution(
      category: HabitCategory.fitness,
      count: 2,
      percentage: 0.40,
    ),
    CategoryDistribution(
      category: HabitCategory.study,
      count: 1,
      percentage: 0.20,
    ),
  ];
}
const yearly = YearlyStatistics(
  year: 2026,
  completionRate: 0.0,
  totalScheduled: 0,
  totalCompleted: 0,
  totalMissed: 0,
  totalXP: 0,
  totalDurationMinutes: 0,
  perfectDays: 0,
  months: [],
);
// =====================================================================
// XP TREND
// =====================================================================

List<XPTrend> _xpTrend() {
  return [
    XPTrend(
      date: DateTime(2026, 8, 1),
      xp: 50,
      cumulativeXp: 50,
    ),
    XPTrend(
      date: DateTime(2026, 8, 8),
      xp: 75,
      cumulativeXp: 125,
    ),
    XPTrend(
      date: DateTime(2026, 8, 15),
      xp: 100,
      cumulativeXp: 225,
    ),
  ];
}