import 'package:flutter/material.dart';


import '../../../core/ui/icons/habit_icon_resolver.dart';
import '../../features/habits/domain/models/habit.dart';

extension HabitUiExtension on Habit {
  IconData get icon =>
      habitIconFromCodePoint(iconCodePoint);

  Color get color =>
      Color(colorValue);
}