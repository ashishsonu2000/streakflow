import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ads/ad_providers.dart';
import '../../../core/billing/premium_store.dart';
import '../../../features/notifications/presentation/providers/reminder_entitlement_sync.dart';
import '../../../features/calendar/presentation/pages/calendar_page.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../../features/habits/presentation/pages/habits_page.dart';
import '../../../features/settings/presentation/pages/settings_page.dart';
import '../../../features/statistics/presentation/pages/statistics_page.dart';

import '../provider/navigation_provider.dart';
import '../widgets/app_bottom_navigation.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({
    super.key,
  });

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  @override
  void initState() {
    super.initState();

    // Ads start only once the user reaches the main app (never during
    // splash or onboarding). Fire-and-forget: consent + SDK startup
    // run in the background and never block the UI; failures simply
    // leave ads unavailable.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Re-verify Premium with Google Play (restore on reinstall,
        // detect expiry). Never blocks; offline keeps the cached state.
        ref.read(premiumStoreProvider.notifier).initialize();

        // Reschedule reminders once after updates that change how they
        // are scheduled (e.g. the timezone fix).
        ref.read(reminderEntitlementSyncProvider);

        ref.read(adsControllerProvider.notifier).initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(navigationProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: IndexedStack(
        index: currentTab.index,
        children: const [
          DashboardPage(),
          HabitsPage(),
          CalendarPage(),
          StatisticsPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigation(),
    );
  }
}