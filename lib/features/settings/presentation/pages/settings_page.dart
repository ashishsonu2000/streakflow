import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';

import '../../../achievements/presentation/widgets/test_achievement_tile.dart';
import '../../../statistics/presentation/widgets/generate_test_data_tile.dart';
import '../widgets/appearance_bottom_sheet.dart';
import '../widgets/rebuild_statistics_tile.dart';
import '../widgets/settings_navigation_tile.dart';
import '../widgets/settings_section.dart';
import '../widgets/version_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  void _showAppearanceSheet(
      BuildContext context,
      ) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return const AppearanceBottomSheet();
      },
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
      ),
      body: ListView(
        children: [
          // =========================================================
          // HABIT MANAGEMENT
          // =========================================================

          SettingsSection(
            title: 'Habit Management',
            children: [
              SettingsNavigationTile(
                icon: Icons.archive_outlined,
                title: 'Archived Habits',
                subtitle: 'View archived habits',
                onTap: () {
                  context.push(
                    AppRoutes.archivedHabits,
                  );
                },
              ),
            ],
          ),

          // =========================================================
          // ACHIEVEMENTS
          // =========================================================

          SettingsSection(
            title: 'Achievements',
            children: [
              SettingsNavigationTile(
                icon: Icons.emoji_events_outlined,
                title: 'Achievements',
                subtitle:
                'View your milestones and rewards',
                onTap: () {
                  context.push(
                    AppRoutes.achievements,
                  );
                },
              ),
            ],
          ),

          // =========================================================
          // PROFILE
          // =========================================================

          SettingsSection(
            title: 'Profile',
            children: [
              SettingsNavigationTile(
                icon: Icons.person_outline,
                title: 'Profile',
                subtitle:
                'Manage your profile',
                onTap: () {
                  context.push(
                    AppRoutes.profile,
                  );
                },
              ),
            ],
          ),

          // =========================================================
          // DEVELOPER
          // =========================================================

          if (!kReleaseMode)
            const SettingsSection(
              title: 'Developer',
              children: [
                RebuildStatisticsTile(),
                Divider(
                  height: 1,
                ),
                GenerateTestDataTile(),
              ],
            ),

          // =========================================================
          // Backup and restore data
          // =========================================================

          SettingsSection(
            title: 'Backup & Restore',
            children: [
              SettingsNavigationTile(
                icon:
                Icons.backup_outlined,
                title: 'Export',
                  subtitle:
                  'Protect your habits and restore them anytime',
                onTap: () {
                  context.push(
                    AppRoutes.backup,
                  );
                },
              ),


              const Divider(
                height: 1,
              ),


            ],
          ),



          // =========================================================
          // PREFERENCES
          // =========================================================

          SettingsSection(
            title: 'Preferences',
            children: [
              SettingsNavigationTile(
                icon:
                Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Habit reminders',
                onTap: () {
                  context.push('/settings/notifications');
                },
              ),

              const Divider(
                height: 1,
              ),

              SettingsNavigationTile(
                icon: Icons.palette_outlined,
                title: 'Appearance',
                subtitle:
                'Light • Dark • System',
                onTap: () {
                  _showAppearanceSheet(
                    context,
                  );
                },
              ),
            ],
          ),


          // =========================================================
          // ABOUT
          // =========================================================

          SettingsSection(
            title: 'About',
            children: [
              const VersionTile(),

              const Divider(
                height: 1,
              ),

              SettingsNavigationTile(
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'Application information',
                onTap: () {
                  context.push(
                    AppRoutes.about,
                  );
                },
              ),
            ],
          ),

          SettingsNavigationTile(
            icon: Icons.notifications_outlined,
            title: 'Notification Test',
            subtitle: 'Schedule a test reminder',
            onTap: () {
              context.push(
                '/notification-test',
              );
            },
          ),
        ],


      ),
    );
  }
}