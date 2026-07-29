import 'package:flutter/material.dart';

import 'Insight_type.dart';

class InsightItem {
  const InsightItem(
      {required this.title,
      required this.message,
      required this.type,
      required this.icon,
      required this.color});

  final String title;
  final String message;
  final InsightType type;
  final IconData icon;
  final Color color;
}
