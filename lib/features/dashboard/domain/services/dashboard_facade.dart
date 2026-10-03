import '../models/dashboard_view_model.dart';

abstract class DashboardFacade {
  Future<DashboardViewModel> loadDashboard();
}
