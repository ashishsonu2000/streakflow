import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/habit_performance.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/monthly_statistics.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/overview_statistics.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/statistics_summary.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/weekday_statistics.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/weekly_statistics.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/weekly_trend.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/models/yearly_statistics.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/premium/advanced_insights_calculator.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/premium/productivity_score_calculator.dart';
import 'package:streak_calculator_flutter/features/statistics/domain/premium/report_builder.dart';

// Week of Mon 2026-09-28 … Sun 2026-10-04.
final _monday = DateTime(2026, 9, 28);

WeekdayStatistics _day(int offset, {int done = 0, int target = 2}) {
  return WeekdayStatistics(
    date: _monday.add(Duration(days: offset)),
    completedHabits: done,
    targetHabits: target,
    completionRate: target == 0 ? 0 : done / target,
    totalXP: done * 5,
    totalDurationMinutes: 0,
    isPerfectDay: target > 0 && done == target,
  );
}

StatisticsSummary _summary({
  List<WeekdayStatistics>? days,
  double weekRate = 0,
  double lastWeekRate = 0,
  int totalTarget = 14,
  int currentStreak = 0,
  int perfectDaysThisMonth = 0,
  List<HabitPerformance> performance = const [],
}) {
  final weekDays = days ?? List.generate(7, (i) => _day(i));
  final best = weekDays.reduce(
      (a, b) => b.completionRate > a.completionRate ? b : a);

  return StatisticsSummary(
    overview: OverviewStatistics(
      completionRate: weekRate,
      currentStreak: currentStreak,
      bestStreak: currentStreak,
      totalHabits: 2,
      totalCompletions: 10,
      totalXP: 50,
      totalDurationMinutes: 0,
      perfectDays: perfectDaysThisMonth,
    ),
    weekly: WeeklyStatistics(
      days: weekDays,
      completionRate: weekRate,
      previousWeekCompletionRate: lastWeekRate,
      weeklyChangePercentage: (weekRate - lastWeekRate) * 100,
      trend: WeeklyTrend.stable,
      totalCompleted: (weekRate * totalTarget).round(),
      totalTarget: totalTarget,
      totalXP: 40,
      totalDurationMinutes: 0,
      activeDays: weekDays.where((d) => d.completedHabits > 0).length,
      bestDay: best,
      worstDay: weekDays.first,
    ),
    monthly: MonthlyStatistics(
      monthlyCompletionRate: 0.5,
      totalCompleted: 20,
      totalXP: 100,
      totalDurationMinutes: 0,
      perfectDays: perfectDaysThisMonth,
      totalScheduled: 40,
      previousMonthCompletionRate: 0.4,
    ),
    yearly: const YearlyStatistics(
      year: 2026,
      completionRate: 0,
      totalScheduled: 0,
      totalCompleted: 0,
      totalMissed: 0,
      totalXP: 0,
      totalDurationMinutes: 0,
      perfectDays: 0,
      months: [],
    ),
    trends: const [],
    performance: performance,
    insights: const [],
    logs: const [],
    categoryDistribution: const [],
    xpTrend: const [],
  );
}

HabitPerformance _perf(String title, double rate, {int completed = 5}) =>
    HabitPerformance(
      habitId: title,
      title: title,
      completionRate: rate,
      currentStreak: 1,
      bestStreak: 3,
      totalCompleted: completed,
      totalXP: 10,
    );

void main() {
  // ===================================================================
  // PRODUCTIVITY SCORE
  // ===================================================================

  group('ProductivityScoreCalculator', () {
    test('no activity: 0, Getting started', () {
      final score = ProductivityScoreCalculator.calculate(
        _summary(),
        today: _monday.add(const Duration(days: 6)),
      );

      expect(score.score, 0);
      expect(score.label, 'Getting started');
    });

    test('perfect week with a 14-day streak: 100, Excellent', () {
      final score = ProductivityScoreCalculator.calculate(
        _summary(
          days: List.generate(7, (i) => _day(i, done: 2)),
          weekRate: 1,
          currentStreak: 30,
        ),
        today: _monday.add(const Duration(days: 6)),
      );

      expect(score.completionPoints, 50);
      expect(score.consistencyPoints, 30);
      expect(score.streakPoints, 20);
      expect(score.score, 100);
      expect(score.label, 'Excellent');
    });

    test('mid-week: only elapsed scheduled days count for consistency', () {
      // Wednesday; Mon–Wed each have a completion; Thu–Sun in future.
      final score = ProductivityScoreCalculator.calculate(
        _summary(
          days: [
            _day(0, done: 1),
            _day(1, done: 1),
            _day(2, done: 1),
            for (var i = 3; i < 7; i++) _day(i),
          ],
          weekRate: 0.5,
          currentStreak: 7,
        ),
        today: _monday.add(const Duration(days: 2)),
      );

      expect(score.consistencyPoints, 30);
      expect(score.completionPoints, 25);
      expect(score.streakPoints, 10);
      expect(score.score, 65);
      expect(score.label, 'Strong');
    });

    test('days with nothing scheduled are ignored', () {
      final score = ProductivityScoreCalculator.calculate(
        _summary(
          days: [
            _day(0, done: 1),
            for (var i = 1; i < 7; i++) _day(i, target: 0),
          ],
          weekRate: 0.5,
        ),
        today: _monday.add(const Duration(days: 6)),
      );

      expect(score.consistencyPoints, 30);
    });

    test('score is always within 0–100', () {
      final score = ProductivityScoreCalculator.calculate(
        _summary(weekRate: 3.5, currentStreak: 999),
        today: _monday,
      );

      expect(score.score, inInclusiveRange(0, 100));
    });
  });

  // ===================================================================
  // ADVANCED INSIGHTS
  // ===================================================================

  group('AdvancedInsightsCalculator', () {
    test('week-over-week up / down / steady', () {
      String first(StatisticsSummary s) =>
          AdvancedInsightsCalculator.calculate(s).first.title;

      expect(first(_summary(weekRate: 0.8, lastWeekRate: 0.5)),
          'Up 30 points this week');
      expect(first(_summary(weekRate: 0.4, lastWeekRate: 0.6)),
          'Down 20 points this week');
      expect(first(_summary(weekRate: 0.5, lastWeekRate: 0.5)),
          'Steady week');
    });

    test('best day, strongest and weakest habits', () {
      final insights = AdvancedInsightsCalculator.calculate(
        _summary(
          days: [_day(0), _day(1, done: 2), for (var i = 2; i < 7; i++) _day(i)],
          weekRate: 0.3,
          performance: [
            _perf('Walk', 0.9),
            _perf('Read', 0.2),
            _perf('Never started', 0, completed: 0),
          ],
        ),
      );
      final titles = insights.map((i) => i.title).toList();

      expect(titles, contains('Best day: Tuesday'));
      expect(titles, contains('Most consistent: Walk'));
      expect(titles, contains('Needs attention: Read'),
          reason: 'habits with no history are not flagged');
    });

    test('a single habit is never flagged as needing attention', () {
      final titles = AdvancedInsightsCalculator.calculate(
        _summary(performance: [_perf('Only', 0.1)]),
      ).map((i) => i.title);

      expect(titles.where((t) => t.startsWith('Needs attention')), isEmpty);
    });

    test('perfect days only when there are some', () {
      bool hasPerfect(StatisticsSummary s) => AdvancedInsightsCalculator
          .calculate(s)
          .any((i) => i.icon == 'perfect_days');

      expect(hasPerfect(_summary()), isFalse);
      expect(hasPerfect(_summary(perfectDaysThisMonth: 3)), isTrue);
    });

    test('nothing scheduled: no week-over-week insight', () {
      final insights = AdvancedInsightsCalculator.calculate(
        _summary(totalTarget: 0),
      );

      expect(insights.where((i) => i.icon.startsWith('trend')), isEmpty);
    });
  });

  // ===================================================================
  // REPORTS
  // ===================================================================

  group('ReportBuilder', () {
    test('weekly report', () {
      final report = ReportBuilder.build(
        _summary(
          days: List.generate(7, (i) => _day(i, done: 2)),
          weekRate: 1,
          lastWeekRate: 0.5,
          currentStreak: 14,
        ),
        ReportPeriod.week,
        referenceDate: _monday,
        today: _monday.add(const Duration(days: 6)),
      );

      expect(report, startsWith('StreakFlow weekly report (Sep 28 – Oct 4)'));
      expect(report, contains('Productivity score: 100/100 (Excellent)'));
      expect(report, contains('Completion: 100% (14/14)'));
      expect(report, contains('Last week: 50%'));
      expect(report, contains('Current streak: 14 days'));
      expect(report, contains('Highlights'));
    });

    test('monthly report uses the selected month', () {
      final report = ReportBuilder.build(
        _summary(perfectDaysThisMonth: 2),
        ReportPeriod.month,
        referenceDate: DateTime(2026, 10, 15),
      );

      expect(report, startsWith('StreakFlow monthly report (October 2026)'));
      expect(report, contains('Completion: 50% (20/40)'));
      expect(report, contains('Last month: 40%'));
      expect(report, contains('Perfect days: 2'));
    });
  });
}
