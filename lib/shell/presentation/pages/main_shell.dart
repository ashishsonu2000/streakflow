import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/dashboard/dashboard_page.dart';
import '../../../features/habits/presentation/pages/habits_page.dart';
import '../../../features/habits/presentation/pages/settings_page.dart';
import '../../../features/statistics/statistics_page.dart';

import '../provider/shell_provider.dart';
import '../widgets/app_navigation.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(shellProvider);

    final pages = <Widget>[
      const DashboardPage(),
      const HabitsPage(),
      const StatisticsPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: const AppNavigation(),
    );
  }
}
