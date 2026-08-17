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
    final statisticsAsync = ref.watch(
      statisticsProvider,
    );

    return AppScaffold(
      title: 'Statistics',
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(
            statisticsProvider,
          );

          await ref.read(
            statisticsProvider.future,
          );
        },
        child: statisticsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (
              error,
              stack,
              ) =>
              Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Failed to load statistics',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        ref.invalidate(
                          statisticsProvider,
                        );
                      },
                      icon: const Icon(
                        Icons.refresh_rounded,
                      ),
                      label: const Text(
                        'Retry',
                      ),
                    ),
                  ],
                ),
              ),
          data: (statistics) {
            return StatisticsBody(
              statistics: statistics,
            );
          },
        ),
      ),
    );
  }
}