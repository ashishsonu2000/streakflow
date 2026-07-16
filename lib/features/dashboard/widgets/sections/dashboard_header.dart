import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.greeting,
    required this.userName,
  });

  final String greeting;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "👋 $greeting",
          style: text.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          userName,
          style: text.displaySmall,
        ),
        const SizedBox(height: 4),
        Text(
          "Welcome back!",
          style: text.bodyMedium,
        ),
      ],
    );
  }
}
