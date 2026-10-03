import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entitlements/premium_feature.dart';
import '../../../premium/presentation/premium_gate.dart';
import '../../domain/models/achievement.dart';

class AchievementCard extends ConsumerWidget {
  const AchievementCard({
    super.key,
    required this.achievement,
  });

  final Achievement achievement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        onTap: achievement.premiumLocked
            ? () => PremiumGate.canUse(
                  context,
                  ref,
                  PremiumFeature.advancedAchievements,
                )
            : null,
        leading: CircleAvatar(
          child: Icon(
            achievement.icon,
          ),
        ),
        title: Text(
          achievement.title,
        ),
        subtitle: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              achievement.description,
            ),

            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: achievement.progress,
            ),

            const SizedBox(height: 4),

            // Progress keeps counting past the target (a 29-day best
            // streak against a 3-day goal), so don't show "29/3".
            Text(
              achievement.unlocked
                  ? 'Unlocked'
                  : '${achievement.currentValue}/${achievement.targetValue}',
            ),
          ],
        ),
        trailing: achievement.premiumLocked
            ? Tooltip(
                message: 'StreakFlow Premium',
                child: Icon(
                  Icons.workspace_premium_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : achievement.unlocked
                ? const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    semanticLabel: 'Unlocked',
                  )
                : const Icon(
                    Icons.lock_outline_rounded,
                    semanticLabel: 'Locked',
                  ),
      ),
    );
  }
}