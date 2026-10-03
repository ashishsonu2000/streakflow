import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class PagePadding extends StatelessWidget {
  const PagePadding({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: child,
    );
  }
}
