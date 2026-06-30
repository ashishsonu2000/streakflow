import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/dashboard_summary.dart';
import '../domain/repository/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository();
});

final dashboardProvider = Provider<DashboardSummary>((ref) {
  return ref.read(dashboardRepositoryProvider).loadDashboard();
});
