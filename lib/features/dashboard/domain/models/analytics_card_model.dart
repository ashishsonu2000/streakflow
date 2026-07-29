import 'dashboard_metric_type.dart';

class AnalyticsCardModel {
  const AnalyticsCardModel({
    required this.type,
    required this.title,
    required this.value,
    this.subtitle,
    this.trend,
    this.progress,
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

  /// Optional trend text
  final String? trend;

  /// Progress value (0.0 - 1.0)
  final double? progress;

  /// Controls trend color/icon
  final bool positiveTrend;

  AnalyticsCardModel copyWith({
    DashboardMetricType? type,
    String? title,
    String? value,
    String? subtitle,
    String? trend,
    double? progress,
    bool? positiveTrend,
  }) {
    return AnalyticsCardModel(
      type: type ?? this.type,
      title: title ?? this.title,
      value: value ?? this.value,
      subtitle: subtitle ?? this.subtitle,
      trend: trend ?? this.trend,
      progress: progress ?? this.progress,
      positiveTrend: positiveTrend ?? this.positiveTrend,
    );
  }
}
