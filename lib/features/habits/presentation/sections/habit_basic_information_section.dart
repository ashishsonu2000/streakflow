import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../shared/ui/layouts/layouts.dart';

import '../widgets/habit_description_field.dart';
import '../widgets/habit_title_field.dart';

class HabitBasicInformationSection extends StatelessWidget {
  const HabitBasicInformationSection({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.titleFocusNode,
    required this.descriptionFocusNode,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;

  final FocusNode titleFocusNode;
  final FocusNode descriptionFocusNode;

  @override
  Widget build(BuildContext context) {
    return AppSection(
      title: 'Basic Information',
      subtitle: 'Give your habit a meaningful name and description.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HabitTitleField(
            controller: titleController,
            focusNode: titleFocusNode,
          ),
          const SizedBox(height: AppSpacing.lg),
          HabitDescriptionField(
            controller: descriptionController,
            focusNode: descriptionFocusNode,
          ),
        ],
      ),
    );
  }
}
