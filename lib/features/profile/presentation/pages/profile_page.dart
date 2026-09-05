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
    // =============================================================
    // PROFILE
    // =============================================================

    final profileAsync = ref.watch(
      profileProvider,
    );

    // =============================================================
    // STATISTICS
    // =============================================================
    //
    // statisticsProvider is a FutureProvider.family.
    //
    // Therefore we must provide a StatisticsQuery.
    //
    // For the Profile page we only need the current/default
    // statistics snapshot.
    //

    final statisticsAsync = ref.watch(
      statisticsProvider(
        const StatisticsQuery(),
      ),
    );

    // =============================================================
    // PROFILE STATE
    // =============================================================

    return profileAsync.when(
      // -----------------------------------------------------------
      // LOADING
      // -----------------------------------------------------------

      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),

      // -----------------------------------------------------------
      // ERROR
      // -----------------------------------------------------------

      error: (error, stack) => Scaffold(
        body: Center(
          child: Text(
            error.toString(),
          ),
        ),
      ),

      // -----------------------------------------------------------
      // DATA
      // -----------------------------------------------------------

      data: (profile) {
        return statisticsAsync.when(
          // =======================================================
          // STATISTICS LOADING
          // =======================================================

          loading: () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),

          // =======================================================
          // STATISTICS ERROR
          // =======================================================

          error: (error, stack) => Scaffold(
            body: Center(
              child: Text(
                error.toString(),
              ),
            ),
          ),

          // =======================================================
          // STATISTICS DATA
          // =======================================================

          data: (summary) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Profile',
                ),
              ),

              // ===================================================
              // BODY
              // ===================================================

              body: ListView(
                padding: const EdgeInsets.all(
                  16,
                ),
                children: [
                  // ===============================================
                  // PROFILE HEADER
                  // ===============================================

                  ProfileHeader(
                    profile: profile,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ===============================================
                  // STATISTICS
                  // ===============================================

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

                  // ===============================================
                  // PREFERENCES
                  // ===============================================

                  ProfilePreferencesSection(
                    notificationsEnabled:
                    profile
                        .notificationsEnabled,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ===============================================
                  // ACTIONS
                  // ===============================================

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