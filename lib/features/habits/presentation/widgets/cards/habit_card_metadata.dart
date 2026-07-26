import 'package:flutter/material.dart';

import '../../../../../core/ui/metadata/app_metadata_row.dart';
import '../../../domain/models/habit.dart';

class HabitCardMetadata extends StatelessWidget {
  const HabitCardMetadata({
    super.key,
    required this.habit,
  });

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return AppMetadataRow(
      items: [
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
