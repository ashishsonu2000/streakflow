import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../widgets/dashboard_body.dart';
import '../providers/dashboard_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final colors = Theme.of(context).colorScheme;

    return dashboardAsync.when(
      data: (dashboard) {
        return Scaffold(
          backgroundColor: colors.surface,
          body: SafeArea(
            child: DashboardBody(
              dashboard: dashboard,
            ),
          ),
        );
      },

      loading: () {
        return AppScaffold(
          title: 'Dashboard',
          child: Center(
            child: CircularProgressIndicator(
              color: colors.primary,
            ),
          ),
        );
      },

      error: (error, stackTrace) {
        return AppScaffold(
          title: 'Dashboard',
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Unable to load dashboard.\n\n$error',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        );
      },
    );
  }
}