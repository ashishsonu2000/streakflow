import 'package:intl/intl.dart';

import '../models/statistics_summary.dart';
import 'advanced_insights_calculator.dart';
import 'productivity_score_calculator.dart';

enum ReportPeriod { week, month }

/// StreakFlow Premium: plain-text weekly / monthly report for sharing.
/// Pure (no I/O) and built only from existing statistics.
abstract final class ReportBuilder {
  static String build(
    StatisticsSummary summary,
    ReportPeriod period, {
    required DateTime referenceDate,
    DateTime? today,
  }) {
    final buffer = StringBuffer();

    switch (period) {
      case ReportPeriod.week:
        final weekly = summary.weekly;
        final days = weekly.days.map((d) => d.date).toList()..sort();
        final range = days.isEmpty
            ? ''
            : ' (${_short(days.first)} – ${_short(days.last)})';

        final score = ProductivityScoreCalculator.calculate(
          summary,
          today: today,
        );

        buffer
          ..writeln('StreakFlow weekly report$range')
          ..writeln()
          ..writeln('Productivity score: ${score.score}/100 (${score.label})')
          ..writeln('Completion: ${_pct(weekly.completionRate)} '
              '(${weekly.totalCompleted}/${weekly.totalTarget})')
          ..writeln('Last week: ${_pct(weekly.previousWeekCompletionRate)}')
          ..writeln('Active days: ${weekly.activeDays}')
          ..writeln('XP earned: ${weekly.totalXP}');

      case ReportPeriod.month:
        final monthly = summary.monthly;

        buffer
          ..writeln('StreakFlow monthly report '
              '(${DateFormat.yMMMM().format(referenceDate)})')
          ..writeln()
          ..writeln('Completion: ${_pct(monthly.monthlyCompletionRate)} '
              '(${monthly.totalCompleted}/${monthly.totalScheduled})')
          ..writeln('Last month: ${_pct(monthly.previousMonthCompletionRate)}')
          ..writeln('Perfect days: ${monthly.perfectDays}')
          ..writeln('XP earned: ${monthly.totalXP}');
    }

    buffer
      ..writeln('Current streak: ${summary.overview.currentStreak} days')
      ..writeln('Best streak: ${summary.overview.bestStreak} days');

    final insights = AdvancedInsightsCalculator.calculate(summary);
    if (insights.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('Highlights');
      for (final insight in insights.take(4)) {
        buffer.writeln('• ${insight.title}');
      }
    }

    return buffer.toString().trimRight();
  }

  static String _pct(double rate) => '${(rate * 100).round()}%';

  static String _short(DateTime d) => DateFormat.MMMd().format(d);
}
