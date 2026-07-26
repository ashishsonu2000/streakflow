import 'package:flutter/material.dart';

class AppActionBar extends StatelessWidget {
  const AppActionBar({
    super.key,
    required this.primary,
    required this.secondary,
    this.height = 46,
    this.spacing = 12,
  });

  final Widget primary;
  final Widget secondary;
  final double height;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: height,
            child: primary,
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          child: SizedBox(
            height: height,
            child: secondary,
          ),
        ),
      ],
    );
  }
}
