import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:streak_calculator_flutter/features/habits/domain/enums/completion_status.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_category.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_log.dart';

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

import 'package:streak_calculator_flutter/core/models/completion_trend.dart';

import 'package:streak_calculator_flutter/features/statistics/domain/models/yearly_statistics.dart';

import 'package:streak_calculator_flutter/features/statistics/presentation/provider/statistics_provider.dart';
import 'package:streak_calculator_flutter/features/statistics/presentation/widgets/common/statistics_body.dart';
import 'package:streak_calculator_flutter/features/statistics/presentation/pages/statistics_page.dart';

void main() {
  group('StatisticsPage', () {
    // ===============================================================
    // LOADING
    // ===============================================================

    testWidgets(
      'shows loading indicator while statistics are loading',
          (tester) async {
        final completer = Completer<StatisticsSummary>();

        await tester.pumpWidget(
          _testApp(
            const StatisticsPage(),
            overrideBuilder: () => completer.future,
          ),
        );

        await tester.pump();

        expect(
          find.byType(CircularProgressIndicator),
          findsOneWidget,
        );

        expect(
          find.text('Failed to load statistics'),
          findsNothing,
        );

        expect(
          find.text('No statistics yet'),
          findsNothing,
        );

        expect(
          find.byType(StatisticsBody),
          findsNothing,
        );
      },
    );

    // ===============================================================
    // ERROR
    // ===============================================================

    testWidgets(
      'shows error state when statistics fail to load',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const StatisticsPage(),
            overrideBuilder: () async {
              throw Exception('Test statistics error');
            },
          ),
        );

        await tester.pump();

        expect(
          find.text('Failed to load statistics'),
          findsOneWidget,
        );

        expect(
          find.text(
            'Something went wrong while loading your statistics.',
          ),
          findsOneWidget,
        );

        expect(
          find.byIcon(
            Icons.error_outline_rounded,
          ),
          findsOneWidget,
        );

        expect(
          find.text('Retry'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // EMPTY
    // ===============================================================

    testWidgets(
      'shows empty state when there are no completions',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const StatisticsPage(),
            overrideBuilder: () async {
              return _statistics(
                totalCompletions: 0,
              );
            },
          ),
        );

        await tester.pump();

        expect(
          find.text('No statistics yet'),
          findsOneWidget,
        );

        expect(
          find.text(
            'Complete a habit to generate your analytics and progress insights.',
          ),
          findsOneWidget,
        );

        expect(
          find.byIcon(
            Icons.insights_rounded,
          ),
          findsOneWidget,
        );

        expect(
          find.byType(StatisticsBody),
          findsNothing,
        );
      },
    );

    // ===============================================================
    // DATA
    // ===============================================================

    testWidgets(
      'renders StatisticsBody when statistics are available',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const StatisticsPage(),
            overrideBuilder: () async {
              return _statistics();
            },
          ),
        );

        await tester.pump();

        final statisticsBody = find.byType(StatisticsBody);

        expect(
          statisticsBody,
          findsOneWidget,
        );

        // Scope the Overview assertion to StatisticsBody.
        //
        // StatisticsPage may have another "Overview" text, such as
        // an app-bar/page heading. The important assertion here is
        // that StatisticsBody renders its Overview section.
        expect(
          find.descendant(
            of: statisticsBody,
            matching: find.text('Overview'),
          ),
          findsOneWidget,
        );

        expect(
          find.text('This Week'),
          findsOneWidget,
        );

        expect(
          find.text('This Month'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // DATA WITH PERFORMANCE
    // ===============================================================

    testWidgets(
      'renders performance data',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const StatisticsPage(),
            overrideBuilder: () async {
              return _statistics(
                performance: [
                  _performance(
                    title: 'Exercise',
                  ),
                ],
              );
            },
          ),
        );

        await tester.pump();

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
    // DATA WITH ACTIVITY
    // ===============================================================

    testWidgets(
      'renders recent activity data',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const StatisticsPage(),
            overrideBuilder: () async {
              return _statistics(
                logs: [
                  _log(),
                ],
              );
            },
          ),
        );

        await tester.pump();

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
    // DATA WITH INSIGHTS
    // ===============================================================

    testWidgets(
      'renders insights',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const StatisticsPage(),
            overrideBuilder: () async {
              return _statistics(
                insights: [
                  const Insight(
                    title: 'Great Progress',
                    description: 'Keep going.',
                    icon: 'insights',
                  ),
                ],
              );
            },
          ),
        );

        await tester.pump();

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
    // WEEKLY CHART
    // ===============================================================

    testWidgets(
      'renders weekly progress section',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const StatisticsPage(),
            overrideBuilder: () async {
              return _statistics();
            },
          ),
        );

        await tester.pump();

        expect(
          find.text('Weekly Progress'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // MONTHLY CHART
    // ===============================================================

    testWidgets(
      'renders monthly progress section',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const StatisticsPage(),
            overrideBuilder: () async {
              return _statistics();
            },
          ),
        );

        await tester.pump();

        expect(
          find.text('Monthly Progress'),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // RETRY BUTTON
    // ===============================================================

    testWidgets(
      'retry button is present in error state',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const StatisticsPage(),
            overrideBuilder: () async {
              throw Exception('Failure');
            },
          ),
        );

        await tester.pump();

        final retryButton = find.widgetWithText(
          FilledButton,
          'Retry',
        );

        expect(
          retryButton,
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // REFRESH INDICATOR
    // ===============================================================

    testWidgets(
      'renders RefreshIndicator',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const StatisticsPage(),
            overrideBuilder: () async {
              return _statistics();
            },
          ),
        );

        await tester.pump();

        expect(
          find.byType(RefreshIndicator),
          findsOneWidget,
        );
      },
    );

    // ===============================================================
    // SAFE SCROLLING
    // ===============================================================

    testWidgets(
      'statistics page can be scrolled',
          (tester) async {
        await tester.pumpWidget(
          _testApp(
            const StatisticsPage(),
            overrideBuilder: () async {
              return _statistics(
                performance: [
                  _performance(
                    title: 'Exercise',
                  ),
                  _performance(
                    title: 'Reading',
                  ),
                  _performance(
                    title: 'Meditation',
                  ),
                ],
                logs: [
                  _log(
                    id: 'log-1',
                  ),
                  _log(
                    id: 'log-2',
                  ),
                ],
                insights: [
                  const Insight(
                    title: 'Consistency',
                    description: 'Excellent work.',
                    icon: 'insights',
                  ),
                ],
              );
            },
          ),
        );

        await tester.pump();

        expect(
          find.byType(ListView),
          findsOneWidget,
        );

        await tester.drag(
          find.byType(ListView),
          const Offset(0, -400),
        );

        await tester.pump();

        expect(
          find.byType(StatisticsBody),
          findsOneWidget,
        );
      },
    );
  });
}

// =====================================================================
// TEST APP
// =====================================================================

Widget _testApp(
    Widget child, {
      Future<StatisticsSummary> Function()? overrideBuilder,
    }) {
  return ProviderScope(
    overrides: [
      statisticsProvider(
        const StatisticsQuery(),
      ).overrideWith(
            (ref) async {
          if (overrideBuilder != null) {
            return overrideBuilder();
          }

          return _statistics();
        },
      ),
    ],
    child: MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2563EB),
      ),
      home: child,
    ),
  );
}

// =====================================================================
// YEARLY
// =====================================================================

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
// STATISTICS FACTORY
// =====================================================================

StatisticsSummary _statistics({
  int totalCompletions = 25,
  List<HabitPerformance> performance = const [],
  List<HabitLog> logs = const [],
  List<Insight> insights = const [],
}) {
  return StatisticsSummary(
    overview: OverviewStatistics(
      completionRate: 0.75,
      currentStreak: 5,
      bestStreak: 10,
      totalHabits: 5,
      totalCompletions: totalCompletions,
      totalXP: 250,
      totalDurationMinutes: 375,
      perfectDays: 12,
    ),
    weekly: _weekly(),
    monthly: _monthly(),
    trends: _trends(),
    performance: performance,
    insights: insights,
    logs: logs,
    categoryDistribution: _categoryDistribution(),
    xpTrend: _xpTrend(),
    yearly: yearly,
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
      date: DateTime(
        2026,
        8,
        1,
      ),
      completionRate: 0.50,
    ),
    CompletionTrend(
      date: DateTime(
        2026,
        8,
        8,
      ),
      completionRate: 0.60,
    ),
    CompletionTrend(
      date: DateTime(
        2026,
        8,
        15,
      ),
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
    date: DateTime(
      2026,
      8,
      20,
    ),
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

// =====================================================================
// XP TREND
// =====================================================================

List<XPTrend> _xpTrend() {
  return [
    XPTrend(
      date: DateTime(
        2026,
        8,
        1,
      ),
      xp: 50,
      cumulativeXp: 50,
    ),
    XPTrend(
      date: DateTime(
        2026,
        8,
        8,
      ),
      xp: 75,
      cumulativeXp: 125,
    ),
    XPTrend(
      date: DateTime(
        2026,
        8,
        15,
      ),
      xp: 100,
      cumulativeXp: 225,
    ),
  ];
}