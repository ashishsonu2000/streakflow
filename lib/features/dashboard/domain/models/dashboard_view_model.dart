import 'dashboard_analytics.dart';
import 'dashboard_section.dart';
import 'hero_view_model.dart';
import 'user_summary.dart';

class DashboardViewModel {
  const DashboardViewModel({
    required this.user,
    required this.hero,
    required this.analytics,
    required this.sections,
  });

  final UserSummary user;

  final HeroViewModel hero;

  final DashboardAnalytics analytics;

  final DashboardSections sections;
}
