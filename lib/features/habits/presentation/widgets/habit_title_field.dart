import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/habit_form_provider.dart';

class HabitTitleField extends ConsumerWidget {
  const HabitTitleField({
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
      textInputAction: TextInputAction.next,
      maxLength: 60,
      decoration: const InputDecoration(
        labelText: 'Habit Title',
        hintText: 'Morning Run',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.edit_outlined),
      ),
      validator: (value) {
        final text = value?.trim() ?? '';

        if (text.isEmpty) {
          return 'Please enter a habit title';
        }

        if (text.length < 2) {
          return 'Title is too short';
        }

        return null;
      },
      onChanged: ref.read(habitFormProvider.notifier).setTitle,
    );
  }
}
