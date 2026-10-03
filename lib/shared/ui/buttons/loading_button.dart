import 'package:flutter/material.dart';

import 'primary_button.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.label,
    required this.loading,
    this.icon,
    this.onPressed,
  });

  final String label;
  final bool loading;
  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: label,
      icon: icon,
      isLoading: loading,
      onPressed: onPressed,
    );
  }
}
