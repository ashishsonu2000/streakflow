import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';

class InsightCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const InsightCard({
    super.key,
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(.15),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: text.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: text.bodyMedium,
          ),
        ],
      ),
    );
  }
}
