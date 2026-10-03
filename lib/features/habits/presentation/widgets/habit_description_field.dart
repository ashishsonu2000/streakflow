import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/habit_form_provider.dart';

class HabitDescriptionField extends ConsumerWidget {
  const HabitDescriptionField({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      maxLines: 4,
      minLines: 3,
      maxLength: 250,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Describe your habit...',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      onChanged: ref.read(habitFormProvider.notifier).setDescription,
    );
  }
}
