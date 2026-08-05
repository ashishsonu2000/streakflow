import '../../../../core/ui/analytics/analytics_card_model.dart';
import '../../../calendar/domain/models/calendar_view_model.dart';

class DashboardAnalytics {
  const DashboardAnalytics({
    required this.cards,
    required this.calendar,
  });

  final List<AnalyticsCardModel> cards;
  final CalendarViewModel calendar;
}
