import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';

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
                subtitle: 'Coming Soon',
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

          const SettingsSection(
            title: 'About',
            children: [
              VersionTile(),
            ],
          ),
        ],
      ),
    );
  }
}