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
      showAppBar: false,

      child: Container(
        color: const Color(0xFFF0F5FA),

        child: SafeArea(
          bottom: false,

          child: RefreshIndicator(
            color: const Color(0xFF2563EB),
            backgroundColor:
            const Color(0xFFF8FAFC),

            onRefresh: () async {
              ref.invalidate(
                statisticsProvider,
              );

              await ref.read(
                statisticsProvider.future,
              );
            },

            child: statisticsAsync.when(
              // =====================================================
              // LOADING
              // =====================================================

              loading: () {
                return ListView(
                  physics:
                  const AlwaysScrollableScrollPhysics(),

                  padding:
                  const EdgeInsets.fromLTRB(
                    16,
                    24,
                    16,
                    140,
                  ),

                  children: const [
                    SizedBox(
                      height: 280,
                      child: Center(
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color:
                          Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                );
              },

              // =====================================================
              // ERROR
              // =====================================================

              error: (
                  error,
                  stack,
                  ) {
                return ListView(
                  physics:
                  const AlwaysScrollableScrollPhysics(),

                  padding:
                  const EdgeInsets.fromLTRB(
                    16,
                    80,
                    16,
                    140,
                  ),

                  children: [
                    _StatisticsMessageCard(
                      icon:
                      Icons.error_outline_rounded,
                      iconColor:
                      const Color(0xFFDC2626),
                      iconBackground:
                      const Color(0xFFFEF2F2),
                      title:
                      'Failed to load statistics',
                      message:
                      'Something went wrong while loading your statistics.',
                      action: FilledButton.icon(
                        onPressed: () {
                          ref.invalidate(
                            statisticsProvider,
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor:
                          const Color(
                            0xFF2563EB,
                          ),
                          foregroundColor:
                          Colors.white,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.refresh_rounded,
                        ),
                        label:
                        const Text('Retry'),
                      ),
                    ),
                  ],
                );
              },

              // =====================================================
              // DATA
              // =====================================================

              data: (statistics) {
                if (statistics
                    .overview
                    .totalCompletions ==
                    0) {
                  return ListView(
                    physics:
                    const AlwaysScrollableScrollPhysics(),

                    padding:
                    const EdgeInsets.fromLTRB(
                      16,
                      70,
                      16,
                      140,
                    ),

                    children: const [
                      _StatisticsMessageCard(
                        icon:
                        Icons.insights_rounded,
                        iconColor:
                        Color(0xFF2563EB),
                        iconBackground:
                        Color(0xFFEFF6FF),
                        title:
                        'No statistics yet',
                        message:
                        'Complete a habit to generate your analytics and progress insights.',
                      ),
                    ],
                  );
                }

                return ListView(
                  physics:
                  const AlwaysScrollableScrollPhysics(),

                  padding:
                  const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    140,
                  ),

                  children: [
                    StatisticsBody(
                      statistics: statistics,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// MESSAGE CARD
// =====================================================================

class _StatisticsMessageCard
    extends StatelessWidget {
  const _StatisticsMessageCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFE),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFBDD4F2),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A)
                .withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // =========================================================
          // ICON
          // =========================================================

          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 28,
              color: iconColor,
            ),
          ),

          const SizedBox(height: 18),

          // =========================================================
          // TITLE
          // =========================================================

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          // =========================================================
          // MESSAGE
          // =========================================================

          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
              height: 1.45,
            ),
          ),

          if (action != null) ...[
            const SizedBox(height: 20),
            action!,
          ],
        ],
      ),
    );
  }
}