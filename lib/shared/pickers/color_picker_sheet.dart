import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import 'color_picker.dart';

class ColorPickerSheet extends StatelessWidget {
  const ColorPickerSheet({
    super.key,
    required this.selectedColor,
  });

  final int selectedColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Color',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            ColorPicker(
              selectedColor: selectedColor,
              onColorSelected: (color) {
                Navigator.pop(context, color);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
