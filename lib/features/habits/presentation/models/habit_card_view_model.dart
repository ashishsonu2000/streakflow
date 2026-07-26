import 'package:flutter/material.dart';

import '../../../../core/ui/chips/status_chip.dart';
import '../../../../core/ui/metadata/app_metadata_row.dart';

class HabitCardViewModel {
  const HabitCardViewModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconCodePoint,
    required this.iconColor,
    required this.status,
    required this.progress,
    required this.progressLabel,
    required this.streakLabel,
    required this.completedToday,
    required this.metadata,
  });

  final String id;

  final String title;

  final String description;

  final int iconCodePoint;

  final Color iconColor;

  final AppStatus status;

  final double progress;

  final String progressLabel;

  final String streakLabel;

  final bool completedToday;

  final List<MetadataItem> metadata;
}
