import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../shared/pickers/color_picker.dart';
import '../../../../shared/pickers/color_picker_tile.dart';
import '../../../../shared/pickers/icon_picker.dart';
import '../../../../shared/pickers/icon_picker_tile.dart';
import '../../../../shared/ui/layouts/layouts.dart';

import '../provider/habit_form_provider.dart';

class HabitAppearanceSection extends ConsumerWidget {
  const HabitAppearanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitFormProvider).valueOrNull;

    if (state == null) {
      return const SizedBox.shrink();
    }

    final notifier = ref.read(habitFormProvider.notifier);

    return AppSection(
      title: 'Appearance',
      subtitle: 'Choose an icon and color.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconPickerTile(
            selectedIcon: state.iconCodePoint,
            onChanged: notifier.setIcon,
          ),
          const SizedBox(height: AppSpacing.xl),
          ColorPickerTile(
            selectedColor: state.colorValue,
            onChanged: notifier.setColor,
          ),
        ],
      ),
    );
  }
}
