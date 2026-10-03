import 'package:flutter/material.dart';

/// Shared icons used throughout the application.
///
/// Prevents random icon usage across screens.
abstract final class AppIcons {
  AppIcons._();

  // Navigation
  static const dashboard = Icons.dashboard_outlined;
  static const habits = Icons.check_circle_outline;
  static const statistics = Icons.bar_chart_outlined;
  static const calendar = Icons.calendar_month_outlined;
  static const achievements = Icons.emoji_events_outlined;
  static const settings = Icons.settings_outlined;

  // Actions
  static const add = Icons.add;
  static const edit = Icons.edit_outlined;
  static const delete = Icons.delete_outline;
  static const archive = Icons.archive_outlined;
  static const restore = Icons.unarchive_outlined;
  static const save = Icons.save_outlined;
  static const search = Icons.search;
  static const filter = Icons.filter_alt_outlined;
  static const sort = Icons.sort;
  static const close = Icons.close;
  static const check = Icons.check;

  // Habit
  static const reminder = Icons.notifications_active_outlined;
  static const target = Icons.flag_outlined;
  static const streak = Icons.local_fire_department_outlined;
  static const completed = Icons.task_alt_outlined;

  // Status
  static const success = Icons.check_circle_outline;
  static const warning = Icons.warning_amber_outlined;
  static const error = Icons.error_outline;
  static const info = Icons.info_outline;

  // Misc
  static const empty = Icons.inbox_outlined;
  static const loading = Icons.hourglass_top;
}
