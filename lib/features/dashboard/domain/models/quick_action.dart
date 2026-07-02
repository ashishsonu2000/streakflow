import 'package:flutter/material.dart';

import 'quick_action_type.dart';

class QuickAction {
  final String title;
  final IconData icon;
  final QuickActionType type;

  const QuickAction({
    required this.title,
    required this.icon,
    required this.type,
  });
}
