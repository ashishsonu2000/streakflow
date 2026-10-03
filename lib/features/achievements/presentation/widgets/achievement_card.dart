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

            Text(
              '${achievement.currentValue}/${achievement.targetValue}',
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
            : Icon(
                achievement.unlocked
                    ? Icons.lock_open
                    : Icons.lock,
              ),
      ),
    );
  }
}