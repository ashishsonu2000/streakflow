import 'package:flutter/material.dart';

import '../../../../../shared/ui/cards/app_card.dart';

class CompletionRateCard extends StatelessWidget {
  const CompletionRateCard({
    super.key,
    required this.completionRate,
  });

  /// Value between 0.0 and 1.0
  final double completionRate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final percent = (completionRate * 100).round();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Completion Rate",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: completionRate,
              ),
              duration: const Duration(milliseconds: 900),
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 130,
                      width: 130,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 10,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${(value * 100).round()}%",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          percent >= 80
                              ? "Excellent"
                              : percent >= 60
                                  ? "Good"
                                  : "Keep Going",
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
