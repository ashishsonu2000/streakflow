import 'package:streak_calculator_flutter/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../shared/ui/buttons/buttons.dart';

import '../../../dashboard/presentation/providers/dashboard_provider.dart';
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
      label: state.isEditing
          ? 'Update Habit'
          : 'Create Habit',
      icon: state.isEditing
          ? AppIcons.save
          : AppIcons.add,
      isLoading: state.isSaving,

      onPressed: () async {
        AppLogger.log('========== FLOW 1: SAVE BUTTON ==========');

        final invalidFields =
            formKey.currentState!.validateGranularly();

        if (invalidFields.isNotEmpty) {
          AppLogger.log('FLOW 1: Form validation FAILED');

          // The fields sit at the top of a long form; bring the first
          // error into view so the user sees why nothing happened.
          final firstContext = invalidFields.first.context;

          if (firstContext.mounted) {
            await Scrollable.ensureVisible(
              firstContext,
              alignment: 0.2,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }

          return;
        }

        AppLogger.log('FLOW 1: Form validation PASSED');

        final success = await ref
            .read(habitFormProvider.notifier)
            .save();

        AppLogger.log(
          'FLOW 1: save() returned = $success',
        );

        if (!context.mounted) return;

        if (success) {
          ref.invalidate(dashboardProvider);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
