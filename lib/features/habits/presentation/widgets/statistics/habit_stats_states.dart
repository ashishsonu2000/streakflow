import 'package:flutter/material.dart';

// =====================================================================
// LOADING
// =====================================================================

class HabitStatsLoadingCard extends StatelessWidget {
  const HabitStatsLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Loading statistics…',
            style: theme
                .textTheme
                .bodyMedium
                ?.copyWith(
              color:
              colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// STATISTICS ERROR
// =====================================================================

class HabitStatsErrorCard
    extends StatelessWidget {
  const HabitStatsErrorCard({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 42,
            color: colors.onErrorContainer,
          ),

          const SizedBox(height: 12),

          Text(
            'Unable to load statistics',
            style: theme
                .textTheme
                .titleMedium
                ?.copyWith(
              fontWeight:
              FontWeight.w800,
              color:
              colors.onErrorContainer,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '$error',
            textAlign: TextAlign.center,
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color:
              colors.onErrorContainer,
            ),
          ),

          const SizedBox(height: 16),

          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// ERROR STATE
// =====================================================================

class HabitStatsErrorState extends StatelessWidget {
  const HabitStatsErrorState({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: colors.error,
            ),

            const SizedBox(height: 16),

            Text(
              'Unable to load habit',
              style: theme
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight:
                FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '$error',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label:
              const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// EMPTY STATE
// =====================================================================

class HabitStatsEmptyState extends StatelessWidget {
  const HabitStatsEmptyState({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              Icons.insights_rounded,
              size: 58,
              color: colors.primary,
            ),

            const SizedBox(height: 16),

            Text(
              title,
              textAlign: TextAlign.center,
              style: theme
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight:
                FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color:
                colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
