import 'package:flutter/material.dart';

/// Resolves a persisted Material icon code point.
///
/// Habit icons are stored as integer code points in the database.
/// Flutter requires IconData's codePoint to be a compile-time constant,
/// so persisted values must be mapped back to the original const IconData.
IconData habitIconFromCodePoint(int codePoint) {
  for (final icon in habitPickerIcons) {
    if (icon.codePoint == codePoint) {
      return icon;
    }
  }

  return Icons.task_alt;
}

/// Canonical set of icons available for habits.
///
/// Keep this list synchronized with the icons displayed by IconPicker.
const List<IconData> habitPickerIcons = [
  Icons.favorite,
  Icons.favorite_border,
  Icons.fitness_center,
  Icons.directions_run,
  Icons.self_improvement,
  Icons.sports_gymnastics,
  Icons.water_drop,
  Icons.local_fire_department,
  Icons.restaurant,
  Icons.fastfood,
  Icons.local_cafe,
  Icons.bedtime,
  Icons.nightlight_round,
  Icons.menu_book,
  Icons.school,
  Icons.work_outline,
  Icons.code,
  Icons.laptop_mac,
  Icons.phone_android,
  Icons.computer,
  Icons.brush,
  Icons.music_note,
  Icons.headphones,
  Icons.camera_alt,
  Icons.photo,
  Icons.travel_explore,
  Icons.flight_takeoff,
  Icons.hiking,
  Icons.directions_bike,
  Icons.pets,
  Icons.spa,
  Icons.eco,
  Icons.yard,
  Icons.park,
  Icons.celebration,
  Icons.star,
  Icons.lightbulb_outline,
  Icons.psychology,
  Icons.auto_awesome,
  Icons.task_alt,
];