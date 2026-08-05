import 'analytics_metric_type.dart';

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

  final AnalyticsMetricType type;

  final String title;

  final String value;

  final String? subtitle;

  final String? trend;

  final double? progress;

  final bool positiveTrend;

  AnalyticsCardModel copyWith({
    AnalyticsMetricType? type,
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
