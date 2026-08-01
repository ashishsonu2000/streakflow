import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../habits/presentation/pages/archived_habits_page.dart';
import '../widgets/rebuild_statistics_tile.dart';
import '../widgets/settings_navigation_tile.dart';
import '../widgets/settings_section.dart';
import '../widgets/version_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SettingsSection(
            title: 'Habit Management',
            children: [
              SettingsNavigationTile(
                icon: Icons.archive_outlined,
                title: 'Archived Habits',
                subtitle: 'View archived habits',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ArchivedHabitsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          if (!kReleaseMode)
            const SettingsSection(
              title: 'Developer',
              children: [
                RebuildStatisticsTile(),
              ],
            ),
          SettingsSection(
            title: 'Preferences',
            children: [
              SettingsNavigationTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Coming Soon',
              ),
              const Divider(height: 1),
              SettingsNavigationTile(
                icon: Icons.palette_outlined,
                title: 'Appearance',
                subtitle: 'Coming Soon',
              ),
            ],
          ),
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
