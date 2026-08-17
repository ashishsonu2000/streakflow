import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../features/calendar/presentation/pages/calendar_page.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../../features/habits/presentation/pages/habits_page.dart';
import '../../../features/settings/presentation/pages/settings_page.dart';
import '../../../features/statistics/presentation/pages/statistics_page.dart';

import '../provider/navigation_provider.dart';
import '../widgets/app_bottom_navigation.dart';

class MainShell extends ConsumerWidget {
  const MainShell({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final currentTab = ref.watch(
      navigationProvider,
    );

    return Scaffold(
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
      bottomNavigationBar:
      const AppBottomNavigation(),
    );
  }
}