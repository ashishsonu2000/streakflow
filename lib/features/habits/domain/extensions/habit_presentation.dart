import 'package:flutter/material.dart';

import '../../../../core/ui/icons/habit_icon_resolver.dart';
import '../models/habit.dart';

extension HabitPresentation on Habit {
  IconData get icon => habitIconFromCodePoint(iconCodePoint);

  Color get color => Color(colorValue);
}
