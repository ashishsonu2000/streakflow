import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../providers/achievements_provider.dart';
import '../widgets/achievement_section.dart';
import '../widgets/achievement_summary_card.dart';

class AchievementsPage extends ConsumerWidget {
  const AchievementsPage({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final achievements =
    ref.watch(achievementProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Achievements',
        ),
      ),
      body: achievements.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text(
            e.toString(),
          ),
        ),
        data: (items) {
          final unlocked = items
              .where((e) => e.unlocked)
              .length;

          final streak = items
              .where(
                (e) =>
            e.category == 'Streak',
          )
              .toList();

          final xp = items
              .where(
                (e) => e.category == 'XP',
          )
              .toList();

          final completion = items
              .where(
                (e) =>
            e.category ==
                'Completion',
          )
              .toList();

          final special = items
              .where(
                (e) =>
            e.category ==
                'Special',
          )
              .toList();

          return ListView(
            padding:
            const EdgeInsets.all(16),
            children: [
              AchievementSummaryCard(
                unlocked: unlocked,
                total: items.length,
              ),
              const SizedBox(height: 24),
              AchievementSection(
                title: '🔥 Streak',
                achievements: streak,
              ),
              AchievementSection(
                title: '⭐ XP',
                achievements: xp,
              ),
              AchievementSection(
                title: '🏅 Completion',
                achievements: completion,
              ),
              AchievementSection(
                title: '🎯 Special',
                achievements: special,
              ),
            ],
          );
        },
      ),
    );
  }
}