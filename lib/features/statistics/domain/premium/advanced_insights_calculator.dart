import 'package:intl/intl.dart';

import '../models/habit_performance.dart';
import '../models/insight.dart';
import '../models/statistics_summary.dart';

/// StreakFlow Premium insights, derived from the existing statistics.
/// Basic insights (StatisticsSummary.insights) stay free.
///
/// Insight.icon keys: trend_up, trend_down, trend_flat, best_day,
/// strongest_habit, needs_attention, perfect_days.
abstract final class AdvancedInsightsCalculator {
  /// A habit below this completion rate is flagged as needing attention.
  static const attentionThreshold = 0.5;

  static List<Insight> calculate(StatisticsSummary summary) {
    final insights = <Insight>[];

    final weekly = summary.weekly;
    final monthly = summary.monthly;

    // -----------------------------------------------------------------
    // Week over week
    // -----------------------------------------------------------------

    if (weekly.totalTarget > 0) {
      final change =
          ((weekly.completionRate - weekly.previousWeekCompletionRate) * 100)
              .round();

      insights.add(
        change > 0
            ? Insight(
                title: 'Up $change points this week',
                description: 'Completion rose to ${_pct(weekly.completionRate)} '
                    'from ${_pct(weekly.previousWeekCompletionRate)} last week.',
                icon: 'trend_up',
              )
            : change < 0
                ? Insight(
                    title: 'Down ${-change} points this week',
                    description:
                        'Completion is ${_pct(weekly.completionRate)}, compared '
                        'with ${_pct(weekly.previousWeekCompletionRate)} last '
                        'week.',
                    icon: 'trend_down',
                  )
                : Insight(
                    title: 'Steady week',
                    description: 'Completion is holding at '
                        '${_pct(weekly.completionRate)}.',
                    icon: 'trend_flat',
                  ),
      );
    }

    // -----------------------------------------------------------------
    // Best day of the week
    // -----------------------------------------------------------------

    final best = weekly.bestDay;
    if (best.targetHabits > 0 && best.completedHabits > 0) {
      insights.add(
        Insight(
          title: 'Best day: ${DateFormat.EEEE().format(best.date)}',
          description: 'You completed ${best.completedHabits} of '
              '${best.targetHabits} habits (${_pct(best.completionRate)}).',
          icon: 'best_day',
        ),
      );
    }

    // -----------------------------------------------------------------
    // Strongest / weakest habit
    // -----------------------------------------------------------------

    final ranked = [...summary.performance]
      ..sort((a, b) => b.completionRate.compareTo(a.completionRate));

    final tracked = ranked.where(_hasHistory).toList();

    if (tracked.isNotEmpty) {
      final strongest = tracked.first;
      insights.add(
        Insight(
          title: 'Most consistent: ${strongest.title}',
          description: '${_pct(strongest.completionRate)} completion, best '
              'streak ${strongest.bestStreak} '
              '${strongest.bestStreak == 1 ? 'day' : 'days'}.',
          icon: 'strongest_habit',
        ),
      );
    }

    if (tracked.length > 1) {
      final weakest = tracked.last;
      if (weakest.completionRate < attentionThreshold) {
        insights.add(
          Insight(
            title: 'Needs attention: ${weakest.title}',
            description: 'Only ${_pct(weakest.completionRate)} completion. '
                'Try a reminder or a smaller daily target.',
            icon: 'needs_attention',
          ),
        );
      }
    }

    // -----------------------------------------------------------------
    // Perfect days this month
    // -----------------------------------------------------------------

    if (monthly.perfectDays > 0) {
      insights.add(
        Insight(
          title: '${monthly.perfectDays} perfect '
              '${monthly.perfectDays == 1 ? 'day' : 'days'} this month',
          description: 'Days where you completed every scheduled habit.',
          icon: 'perfect_days',
        ),
      );
    }

    return insights;
  }

  static bool _hasHistory(HabitPerformance p) =>
      p.totalCompleted > 0 || p.completionRate > 0;

  static String _pct(double rate) => '${(rate * 100).round()}%';
}
