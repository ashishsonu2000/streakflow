import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/core/ui/icons/habit_icon_resolver.dart';
import 'package:streak_calculator_flutter/features/habits/domain/models/habit_form_state.dart';
import 'package:streak_calculator_flutter/features/habits/presentation/widgets/habit_icons.dart';

void main() {
  test('every icon offered by the habit form displays as itself', () {
    for (final icon in HabitIcons.icons) {
      expect(
        habitIconFromCodePoint(icon.codePoint),
        icon,
        reason: 'code point 0x${icon.codePoint.toRadixString(16)}',
      );
    }
  });

  test('habits saved with the old default icon (0xe318) still show a tick',
      () {
    expect(habitIconFromCodePoint(0xe318), Icons.task_alt);
  });

  test('a new habit defaults to the tick icon', () {
    expect(HabitFormState().iconCodePoint, Icons.task_alt.codePoint);
  });
}
