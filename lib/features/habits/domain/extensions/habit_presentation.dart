import 'package:flutter/material.dart';

import '../models/habit.dart';

extension HabitPresentation on Habit {
  IconData get icon => IconData(
        iconCodePoint,
        fontFamily: 'MaterialIcons',
      );

  Color get color => Color(colorValue);
}
