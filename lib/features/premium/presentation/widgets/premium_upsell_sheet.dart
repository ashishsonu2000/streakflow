import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/entitlements/premium_feature.dart';

/// Explains why a Premium feature is locked and offers the Premium
/// page. Never blocks: "Not now" always returns to the app.
Future<void> showPremiumUpsell(
  BuildContext context, {
  required PremiumFeature feature,
  String? message,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (sheetContext) => _PremiumUpsellSheet(
      feature: feature,
      message: message,
      onSeePremium: () {
        Navigator.of(sheetContext).pop();
        context.push(AppRoutes.premium);
      },
    ),
  );
}

class _PremiumUpsellSheet extends StatelessWidget {
  const _PremiumUpsellSheet({
    required this.feature,
    required this.onSeePremium,
    this.message,
  });

  final PremiumFeature feature;
  final String? message;
  final VoidCallback onSeePremium;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.workspace_premium_rounded,
                color: colors.onPrimaryContainer,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              feature.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message ??
                  '${feature.description}\n'
                      'Available with StreakFlow Premium.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onSeePremium,
                icon: const Icon(Icons.workspace_premium_outlined),
                label: const Text('See StreakFlow Premium'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Not now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
