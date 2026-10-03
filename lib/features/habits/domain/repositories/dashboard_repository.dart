import '../../../dashboard/domain/models/dashboard_summary.dart';

abstract interface class DashboardRepository {
  Future<DashboardSummary> getSummary();
}
