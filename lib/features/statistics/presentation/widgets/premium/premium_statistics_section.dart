import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/entitlements/premium_feature.dart';
import '../../../../../core/ui/insights/insight_item.dart';
import '../../../../../core/ui/insights/insights_list.dart';
import '../../../../premium/presentation/premium_gate.dart';
import '../../../domain/models/insight.dart';
import '../../../domain/models/statistics_summary.dart';
import '../../../domain/premium/advanced_insights_calculator.dart';
import '../../../domain/premium/productivity_score_calculator.dart';
import '../../../domain/premium/report_builder.dart';

/// StreakFlow Premium analytics on the Statistics page: productivity
/// score, advanced insights and shareable reports. Shown only to
/// Premium users (see PremiumStatisticsTeaser for Free).
class PremiumStatisticsSection extends StatelessWidget {
  const PremiumStatisticsSection({
    super.key,
    required this.statistics,
    required this.referenceDate,
  });

  final StatisticsSummary statistics;
  final DateTime referenceDate;

  @override
  Widget build(BuildContext context) {
    final score = ProductivityScoreCalculator.calculate(statistics);
    final insights = AdvancedInsightsCalculator.calculate(statistics);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ScoreCard(score: score),
        if (insights.isNotEmpty) ...[
          const SizedBox(height: 12),
          InsightsList(
            insights: insights.map((i) => _toItem(context, i)).toList(),
          ),
        ],
        const SizedBox(height: 12),
        _ReportActions(
          statistics: statistics,
          referenceDate: referenceDate,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  static InsightItem _toItem(BuildContext context, Insight insight) {
    final colors = Theme.of(context).colorScheme;

    final (icon, color) = switch (insight.icon) {
      'trend_up' => (Icons.trending_up_rounded, Colors.green.shade600),
      'trend_down' => (Icons.trending_down_rounded, colors.error),
      'best_day' => (Icons.event_available_rounded, colors.primary),
      'strongest_habit' => (Icons.emoji_events_outlined, Colors.amber.shade700),
      'needs_attention' => (Icons.flag_outlined, Colors.orange.shade700),
      'perfect_days' => (Icons.verified_outlined, Colors.green.shade600),
      _ => (Icons.trending_flat_rounded, colors.secondary),
    };

    return InsightItem(
      title: insight.title,
      message: insight.description,
      icon: icon,
      color: color,
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.score});

  final ProductivityScore score;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.speed_rounded, color: colors.primary),
                const SizedBox(width: 8),
                Text(
                  'Productivity score',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.workspace_premium_outlined,
                  size: 18,
                  color: colors.primary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Semantics(
              label: 'Productivity score ${score.score} out of 100, '
                  '${score.label}',
              excludeSemantics: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${score.score}',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.primary,
                    ),
                  ),
                  Text(
                    ' / 100',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      score.label,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Part(
              label: 'Completion',
              points: score.completionPoints,
              max: ProductivityScore.maxCompletion,
            ),
            _Part(
              label: 'Consistency',
              points: score.consistencyPoints,
              max: ProductivityScore.maxConsistency,
            ),
            _Part(
              label: 'Streak',
              points: score.streakPoints,
              max: ProductivityScore.maxStreak,
            ),
          ],
        ),
      ),
    );
  }
}

class _Part extends StatelessWidget {
  const _Part({
    required this.label,
    required this.points,
    required this.max,
  });

  final String label;
  final int points;
  final int max;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(label, style: theme.textTheme.bodySmall),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: max == 0 ? 0 : points / max,
                minHeight: 6,
              ),
            ),
          ),
          SizedBox(
            width: 52,
            child: Text(
              '$points/$max',
              textAlign: TextAlign.end,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportActions extends StatelessWidget {
  const _ReportActions({
    required this.statistics,
    required this.referenceDate,
  });

  final StatisticsSummary statistics;
  final DateTime referenceDate;

  Future<void> _share(ReportPeriod period) {
    return SharePlus.instance.share(
      ShareParams(
        subject: period == ReportPeriod.week
            ? 'My StreakFlow weekly report'
            : 'My StreakFlow monthly report',
        text: ReportBuilder.build(
          statistics,
          period,
          referenceDate: referenceDate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _share(ReportPeriod.week),
            icon: const Icon(Icons.summarize_outlined, size: 18),
            label: const Text('Weekly report'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _share(ReportPeriod.month),
            icon: const Icon(Icons.calendar_month_outlined, size: 18),
            label: const Text('Monthly report'),
          ),
        ),
      ],
    );
  }
}

/// Free users: one quiet card after the free statistics.
class PremiumStatisticsTeaser extends ConsumerWidget {
  const PremiumStatisticsTeaser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Icon(Icons.speed_rounded, color: colors.primary),
          title: const Text('Productivity score & reports'),
          subtitle: const Text(
            'Your weekly score, deeper insights and shareable reports '
            'with StreakFlow Premium.',
          ),
          trailing: Icon(
            Icons.workspace_premium_outlined,
            color: colors.primary,
          ),
          onTap: () => PremiumGate.canUse(
            context,
            ref,
            PremiumFeature.productivityScore,
          ),
        ),
      ),
    );
  }
}
