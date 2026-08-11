import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/dashboard_body.dart';
import '../providers/dashboard_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);

    return dashboardAsync.when(
      data: (dashboard) {
        return DashboardBody(
          dashboard: dashboard,
        );
      },

      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),

      error: (error, stackTrace) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Unable to load dashboard.\n\n$error',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}