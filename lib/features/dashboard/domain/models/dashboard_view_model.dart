import '../../../../core/ui/analytics/analytics_card_model.dart';
import '../../../calendar/domain/models/calendar_view_model.dart';

import 'dashboard_section.dart';
import 'hero_view_model.dart';
import 'user_summary.dart';

class DashboardViewModel {
  const DashboardViewModel({
    required this.user,
    required this.hero,
    required this.analyticsCards,
    required this.calendar,
    required this.sections,
  });

  final UserSummary user;

  final HeroViewModel hero;

  final List<AnalyticsCardModel> analyticsCards;

  final CalendarViewModel calendar;

  final DashboardSections sections;
}
