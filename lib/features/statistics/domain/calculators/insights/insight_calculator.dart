import '../../engine/calculator.dart';

import '../../engine/statistics_context.dart';
import '../../models/insight.dart';

class InsightCalculator
    implements Calculator<StatisticsContext, List<Insight>> {
  const InsightCalculator();

  @override
  List<Insight> calculate(
    StatisticsContext context,
  ) {
    final insights = <Insight>[];

    if (context.completedLogs.isEmpty) {
      insights.add(
        const Insight(
          title: 'Start your journey',
          description: 'Complete your first habit to unlock statistics.',
          icon: 'rocket_launch',
        ),
      );

      return insights;
    }

    final completionRate = context.logs.isEmpty
        ? 0.0
        : context.completedLogs.length / context.logs.length;

    if (completionRate >= 0.80) {
      insights.add(
        const Insight(
          title: 'Excellent consistency',
          description: 'You are completing more than 80% of your habits.',
          icon: 'emoji_events',
        ),
      );
    }

    if (completionRate < 0.50) {
      insights.add(
        const Insight(
          title: 'Room for improvement',
          description: 'Try focusing on fewer habits to build consistency.',
          icon: 'trending_up',
        ),
      );
    }

    return insights;
  }
}
