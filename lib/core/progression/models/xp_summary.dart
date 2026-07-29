import 'package:flutter/foundation.dart';

@immutable
class XpSummary {
  const XpSummary({
    required this.totalXp,
    required this.todayXp,
    required this.weekXp,
    required this.monthXp,
  });

  final int totalXp;

  final int todayXp;

  final int weekXp;

  final int monthXp;
}
