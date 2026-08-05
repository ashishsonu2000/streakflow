import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class AppSection extends StatelessWidget {
  const AppSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  final Widget child;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.only(
            bottom: AppSpacing.xxl,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: title,
            subtitle: subtitle,
            actionText: actionText,
            onAction: onAction,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(
            height: AppSpacing.lg,
          ),
          child,
        ],
      ),
    );
  }
}
