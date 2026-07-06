import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/provider/statistics_provider.dart';
import 'presentation/widgets/statistics_header.dart';
import 'presentation/widgets/statistics_progress_card.dart';
import 'presentation/widgets/statistics_summary_cards.dart';
import 'presentation/widgets/weekly_trend_chart.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statisticsAsync = ref.watch(
      statisticsProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
      ),
      body: statisticsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, s) => Center(
          child: Text(e.toString()),
        ),
        data: (statistics) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const StatisticsHeader(),
                const SizedBox(height: 24),
                StatisticsSummaryCards(
                  statistics: statistics,
                ),
                const SizedBox(height: 24),
                StatisticsProgressCard(
                  statistics: statistics,
                ),
                const SizedBox(height: 24),
                WeeklyTrendChart(
                  statistics: statistics,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
