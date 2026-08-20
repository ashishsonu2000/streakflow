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


          if (items.every((item) => !item.unlocked)) {
            return const Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 72,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'No achievements unlocked',
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Keep completing habits to unlock rewards.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }


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
              if (items.every((item) => !item.unlocked)) ...[
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          size: 64,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No achievements unlocked yet',
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Complete habits to unlock rewards.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                AchievementSummaryCard(
                  unlocked: unlocked,
                  total: items.length,
                ),
              ],
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