import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../shared/ui/buttons/buttons.dart';

import '../provider/habit_form_provider.dart';

class SaveHabitButton extends ConsumerWidget {
  const SaveHabitButton({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitFormProvider).valueOrNull;

    if (state == null) {
      return const SizedBox.shrink();
    }

    return PrimaryButton(
      label: state.isEditing ? 'Update Habit' : 'Create Habit',
      icon: state.isEditing ? AppIcons.save : AppIcons.add,
      isLoading: state.isSaving,
      onPressed: () async {
        if (!formKey.currentState!.validate()) {
          return;
        }

        final success = await ref.read(habitFormProvider.notifier).save();

        if (!context.mounted) return;

        if (success) {
          Navigator.pop(context);
        }
      },
    );
  }
}
