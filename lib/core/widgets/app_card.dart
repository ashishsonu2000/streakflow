import 'package:flutter/material.dart';

import '../../app/theme/app_dimensions.dart';

class AppCard extends StatelessWidget {
  final Widget child;

  final EdgeInsets? padding;

  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      child: Padding(
        padding: padding ?? AppDimensions.cardPadding,
        child: child,
      ),
    );

    if (onTap == null) {
      return card;
    }

    return InkWell(
      borderRadius: AppDimensions.cardRadius,
      onTap: onTap,
      child: card,
    );
  }
}
