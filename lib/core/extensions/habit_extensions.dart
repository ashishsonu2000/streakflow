import 'package:flutter/widgets.dart';

import '../../features/habits/domain/models/habit.dart';

extension HabitUiExtension on Habit {
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  Color get color => Color(colorValue);
}
