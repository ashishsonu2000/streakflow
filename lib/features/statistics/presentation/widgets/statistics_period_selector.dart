import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/statistics_period.dart';
import '../provider/statistics_period_provider.dart';



class StatisticsPeriodSelector extends ConsumerWidget {
  const StatisticsPeriodSelector({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final selected =
    ref.watch(statisticsPeriodProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: SegmentedButton<StatisticsPeriod>(
        showSelectedIcon: false,
        segments: const [
          ButtonSegment(
            value: StatisticsPeriod.today,
            label: Text('Today'),
          ),
          ButtonSegment(
            value: StatisticsPeriod.week,
            label: Text('Week'),
          ),
          ButtonSegment(
            value: StatisticsPeriod.month,
            label: Text('Month'),
          ),
          ButtonSegment(
            value: StatisticsPeriod.year,
            label: Text('Year'),
          ),
        ],
        selected: {selected},
        onSelectionChanged: (selection) {
          if (selection.isEmpty) {
            return;
          }

          ref
              .read(
            statisticsPeriodProvider.notifier,
          )
              .state = selection.first;
        },
      ),
    );
  }
}