import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';

import '../../../statistics/presentation/widgets/generate_test_data_tile.dart';
import '../widgets/appearance_bottom_sheet.dart';
import '../widgets/rebuild_statistics_tile.dart';
import '../widgets/settings_navigation_tile.dart';
import '../widgets/version_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  // ===============================================================
  // APPEARANCE
  // ===============================================================

  void _showAppearanceSheet(
      BuildContext context,
      ) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,

      // =============================================================
      // APP BAR
      // =============================================================

      appBar: AppBar(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,

        title: Text(
          'Settings',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colors.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // =============================================================
      // BODY
      // =============================================================

      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const ClampingScrollPhysics(),
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
                icon: Icons.archive_outlined,
                title: 'Archived Habits',
                subtitle: 'View archived habits',
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
                icon: Icons.emoji_events_outlined,
                title: 'Achievements',
                subtitle: 'View your milestones and rewards',
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
                icon: Icons.person_outline_rounded,
                title: 'Profile',
                subtitle: 'Manage your profile',
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
                icon: Icons.backup_outlined,
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
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'How your data is handled',
                  onTap: () {
                    context.push(
                      AppRoutes.privacy,
                    );
                  },
                ),

                _SettingsDivider(),

                SettingsNavigationTile(
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  subtitle: 'Terms of using Streak Calculator',
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
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Habit reminders',
                  onTap: () {
                    context.push(
                      '/settings/notifications',
                    );
                  },
                ),

                _SettingsDivider(),

                SettingsNavigationTile(
                  icon: Icons.palette_outlined,
                  title: 'Appearance',
                  subtitle: 'Light • Dark • System',
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

                _SettingsDivider(),

                SettingsNavigationTile(
                  icon: Icons.info_outline_rounded,
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

            // =========================================================
            // DEVELOPER
            // =============================================================

            if (!kReleaseMode) ...[
              const SizedBox(height: 14),

              _SettingsGroup(
                title: 'Developer',
                child: Column(
                  children: const [
                    RebuildStatisticsTile(),
                    _SettingsDivider(),
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
                icon: Icons.notifications_active_outlined,
                title: 'Notification Test',
                subtitle: 'Schedule a test reminder',
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final content = child ??
        Column(
          children: children ?? const [],
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 4,
            bottom: 7,
          ),
          child: Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: colors.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),

        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colors.outlineVariant,
            ),
            boxShadow: theme.brightness == Brightness.dark
                ? [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.18,
                ),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ]
                : [
              BoxShadow(
                color: colors.primary.withValues(
                  alpha: 0.035,
                ),
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

// =====================================================================
// THEME-AWARE DIVIDER
// =====================================================================

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Divider(
      height: 1,
      thickness: 1,
      color: colors.outlineVariant,
    );
  }
}