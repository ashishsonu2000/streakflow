import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_scaffold.dart';
import 'presentation/providers/dashboard_provider.dart';
import 'widgets/dashboard_body.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(
      dashboardViewModelProvider,
    );

    return dashboardAsync.when(
      data: (dashboard) {
        return AppScaffold(
          title: "Dashboard",
          showAppBar: false,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // TODO: Open Add Habit Sheet
            },
            child: const Icon(Icons.add),
          ),
          child: DashboardBody(
            dashboard: dashboard,
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Dashboard Error\n\n$error",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
