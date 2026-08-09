import 'package:flutter/material.dart';
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
    this.icon = Icons.analytics, // ✅ DEFAULT FIX
    this.color = const Color(0xFF4CAF50),
  });

  final AnalyticsMetricType type;
  final String title;
  final String value;
  final String? subtitle;
  final String? trend;
  final double? progress;
  final bool positiveTrend;

  final IconData icon; // ✅ SAFE
  final Color color;

  AnalyticsCardModel copyWith({
    AnalyticsMetricType? type,
    String? title,
    String? value,
    String? subtitle,
    String? trend,
    double? progress,
    bool? positiveTrend,
    IconData? icon,
    Color? color,
  }) {
    return AnalyticsCardModel(
      type: type ?? this.type,
      title: title ?? this.title,
      value: value ?? this.value,
      subtitle: subtitle ?? this.subtitle,
      trend: trend ?? this.trend,
      progress: progress ?? this.progress,
      positiveTrend: positiveTrend ?? this.positiveTrend,
      icon: icon ?? this.icon,   // ✅ FIX
      color: color ?? this.color,
    );
  }
}