import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/quick_action.dart';
import '../../domain/models/quick_action_type.dart';

final dashboardActionsProvider = Provider<List<QuickAction>>((ref) {
  return const [
    QuickAction(
      title: "Add Habit",
      icon: Icons.add_circle_outline,
      type: QuickActionType.addHabit,
    ),
    QuickAction(
      title: "Calendar",
      icon: Icons.calendar_month,
      type: QuickActionType.calendar,
    ),
    QuickAction(
      title: "Statistics",
      icon: Icons.bar_chart,
      type: QuickActionType.statistics,
    ),
    QuickAction(
      title: "Settings",
      icon: Icons.settings,
      type: QuickActionType.settings,
    ),
  ];
});
