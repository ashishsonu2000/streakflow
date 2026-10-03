import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import 'icon_picker.dart';

class IconPickerSheet extends StatelessWidget {
  const IconPickerSheet({
    super.key,
    required this.selectedIcon,
  });

  final int selectedIcon;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Icon',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            Flexible(
              child: SingleChildScrollView(
                child: IconPicker(
                  selectedIcon: selectedIcon,
                  onIconSelected: (icon) {
                    Navigator.pop(context, icon);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
