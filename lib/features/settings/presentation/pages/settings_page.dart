import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';

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
      backgroundColor:
      const Color(0xFFF9FBFE),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return const AppearanceBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF0F5FA),

      appBar: AppBar(
        backgroundColor:
        const Color(0xFFF0F5FA),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        bottom: false,
        child: ListView(
          physics:
          const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            16,
            4,
            16,
            140,
          ),
          children: [
            // =========================================================
            // HABIT MANAGEMENT
            // =========================================================

            _SettingsGroup(
              title: 'Habit Management',
              child: SettingsNavigationTile(
                icon:
                Icons.archive_outlined,
                title: 'Archived Habits',
                subtitle:
                'View archived habits',
                onTap: () {
                  context.push(
                    AppRoutes.archivedHabits,
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // =========================================================
            // ACHIEVEMENTS
            // =========================================================

            _SettingsGroup(
              title: 'Achievements',
              child: SettingsNavigationTile(
                icon:
                Icons.emoji_events_outlined,
                title: 'Achievements',
                subtitle:
                'View your milestones and rewards',
                onTap: () {
                  context.push(
                    AppRoutes.achievements,
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // =========================================================
            // PROFILE
            // =========================================================

            _SettingsGroup(
              title: 'Profile',
              child: SettingsNavigationTile(
                icon:
                Icons.person_outline_rounded,
                title: 'Profile',
                subtitle:
                'Manage your profile',
                onTap: () {
                  context.push(
                    AppRoutes.profile,
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // =========================================================
            // BACKUP & RESTORE
            // =========================================================

            _SettingsGroup(
              title: 'Backup & Restore',
              child: SettingsNavigationTile(
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
            ),

            const SizedBox(height: 14),

            // =========================================================
            // LEGAL & PRIVACY
            // =========================================================

            _SettingsGroup(
              title: 'Legal & Privacy',
              children: [
                SettingsNavigationTile(
                  icon:
                  Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle:
                  'How your data is handled',
                  onTap: () {
                    context.push(
                      AppRoutes.privacy,
                    );
                  },
                ),
                const Divider(
                  height: 1,
                  color: Color(0xFFE2E8F0),
                ),
                SettingsNavigationTile(
                  icon:
                  Icons.description_outlined,
                  title: 'Terms & Conditions',
                  subtitle:
                  'Terms of using Streak Calculator',
                  onTap: () {
                    context.push(
                      AppRoutes.terms,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 14),

            // =========================================================
            // PREFERENCES
            // =========================================================

            _SettingsGroup(
              title: 'Preferences',
              children: [
                SettingsNavigationTile(
                  icon:
                  Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle:
                  'Habit reminders',
                  onTap: () {
                    context.push(
                      '/settings/notifications',
                    );
                  },
                ),
                const Divider(
                  height: 1,
                  color: Color(0xFFE2E8F0),
                ),
                SettingsNavigationTile(
                  icon:
                  Icons.palette_outlined,
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

            const SizedBox(height: 14),

            // =========================================================
            // ABOUT
            // =========================================================

            _SettingsGroup(
              title: 'About',
              children: [
                const VersionTile(),
                const Divider(
                  height: 1,
                  color: Color(0xFFE2E8F0),
                ),
                SettingsNavigationTile(
                  icon:
                  Icons.info_outline_rounded,
                  title: 'About',
                  subtitle:
                  'Application information',
                  onTap: () {
                    context.push(
                      AppRoutes.about,
                    );
                  },
                ),
              ],
            ),

            // =========================================================
            // DEVELOPER
            // =========================================================

            if (!kReleaseMode) ...[
              const SizedBox(height: 14),

              _SettingsGroup(
                title: 'Developer',
                child: Column(
                  children: const [
                    RebuildStatisticsTile(),
                    Divider(
                      height: 1,
                      color: Color(0xFFE2E8F0),
                    ),
                    GenerateTestDataTile(),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 14),

            // =========================================================
            // NOTIFICATION TEST
            // =========================================================

            _SettingsGroup(
              title: 'Testing',
              child: SettingsNavigationTile(
                icon:
                Icons.notifications_active_outlined,
                title: 'Notification Test',
                subtitle:
                'Schedule a test reminder',
                onTap: () {
                  context.push(
                    '/notification-test',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// SETTINGS GROUP
// =====================================================================

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({
    required this.title,
    this.child,
    this.children,
  });

  final String title;
  final Widget? child;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    final content = child ??
        Column(
          children: children ?? [],
        );

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 4,
            bottom: 7,
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF334155),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),

        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FBFE),
            borderRadius:
            BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFD7E3F1),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E3A8A)
                    .withValues(alpha: 0.035),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: content,
        ),
      ],
    );
  }
}