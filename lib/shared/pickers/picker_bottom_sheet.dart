import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class PickerBottomSheet extends StatelessWidget {
  const PickerBottomSheet({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}
