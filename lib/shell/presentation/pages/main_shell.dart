import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/dashboard/presentation/pages/dashboard_page.dart';

import '../../../features/habits/presentation/pages/habits_page.dart';
import '../../../features/habits/presentation/pages/settings_page.dart';
import '../../../features/habits/presentation/pages/statistics_page.dart';

import '../provider/shell_provider.dart';
import '../widgets/app_navigation.dart';

class MainShell extends ConsumerWidget {
  const MainShell({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(shellProvider);

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          DashboardPage(),
          HabitsPage(),
          StatisticsPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: const AppNavigation(),
    );
  }
}
