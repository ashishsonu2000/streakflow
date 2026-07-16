import 'dashboard_metric_type.dart';

class AnalyticsCardModel {
  const AnalyticsCardModel({
    required this.type,
    required this.title,
    required this.value,
    this.subtitle,
    this.trend,
    this.positiveTrend = true,
  });

  /// Metric type
  final DashboardMetricType type;

  /// Card title
  final String title;

  /// Main value
  final String value;

  /// Optional subtitle
  final String? subtitle;

  /// Example:
  /// +2 this week
  /// +10 XP
  /// Today
  final String? trend;

  /// Controls trend color/icon
  final bool positiveTrend;

  AnalyticsCardModel copyWith({
    DashboardMetricType? type,
    String? title,
    String? value,
    String? subtitle,
    String? trend,
    bool? positiveTrend,
  }) {
    return AnalyticsCardModel(
      type: type ?? this.type,
      title: title ?? this.title,
      value: value ?? this.value,
      subtitle: subtitle ?? this.subtitle,
      trend: trend ?? this.trend,
      positiveTrend: positiveTrend ?? this.positiveTrend,
    );
  }
}
