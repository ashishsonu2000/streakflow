import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../statistics/presentation/provider/statistics_provider.dart';

import '../providers/profile_provider.dart';

import '../widgets/profile_actions_section.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_preferences_section.dart';
import '../widgets/profile_statistics_card.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final profileAsync = ref.watch(
      profileProvider,
    );

    final statisticsAsync = ref.watch(
      statisticsProvider,
    );

    return profileAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => Scaffold(
        body: Center(
          child: Text(
            e.toString(),
          ),
        ),
      ),
      data: (profile) {
        return statisticsAsync.when(
          loading: () => const Scaffold(
            body: Center(
              child:
              CircularProgressIndicator(),
            ),
          ),
          error: (e, _) => Scaffold(
            body: Center(
              child: Text(
                e.toString(),
              ),
            ),
          ),
          data: (summary) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Profile',
                ),
              ),
              body: ListView(
                padding:
                const EdgeInsets.all(
                  16,
                ),
                children: [
                  ProfileHeader(
                    profile: profile,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  ProfileStatisticsCard(
                    currentStreak:
                    summary
                        .overview
                        .currentStreak,
                    bestStreak:
                    summary
                        .overview
                        .bestStreak,
                    totalXP:
                    summary
                        .overview
                        .totalXP,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  ProfilePreferencesSection(
                    notificationsEnabled:
                    profile
                        .notificationsEnabled,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  const ProfileActionsSection(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}