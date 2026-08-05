import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_scaffold.dart';

import '../provider/statistics_provider.dart';
import '../widgets/common/statistics_body.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final statistics = ref.watch(
      statisticsProvider,
    );

    return AppScaffold(
      title: 'Statistics',
      child: statistics.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text(
            e.toString(),
          ),
        ),
        data: (summary) => StatisticsBody(
          statistics: summary,
        ),
      ),
    );
  }
}
