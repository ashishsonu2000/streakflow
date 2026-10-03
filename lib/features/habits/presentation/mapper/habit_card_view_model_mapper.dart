import 'package:flutter/material.dart';

import '../../../../core/ui/chips/status_chip.dart';

import '../../../../core/ui/metadata/app_metadata_row.dart';
import '../../domain/models/analytics/habit_analytics.dart';
import '../../domain/models/habit.dart';
import '../models/habit_card_view_model.dart';

class HabitCardViewModelMapper {
  HabitCardViewModel map(
    Habit habit,
    HabitAnalytics analytics,
  ) {
    return HabitCardViewModel(
      id: habit.id,
      title: habit.title,
      description: habit.description,
      iconCodePoint: habit.iconCodePoint,
      iconColor: Color(habit.colorValue),
      status: habit.archived ? AppStatus.archived : AppStatus.active,
      progress: analytics.todayProgress,
      progressLabel: '${analytics.todayPercent}% completed',
      streakLabel: '${analytics.currentStreak} day streak',
      completedToday: analytics.completedToday > 0,
      metadata: [
        MetadataItem(
          icon: Icons.category_outlined,
          label: habit.category.name,
        ),
        MetadataItem(
          icon: Icons.repeat,
          label: habit.frequency.name,
        ),
        MetadataItem(
          icon: Icons.flag_outlined,
          label: '${habit.targetPerDay}/day',
        ),
      ],
    );
  }
}
