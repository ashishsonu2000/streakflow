import 'package:flutter/material.dart';

import '../../../../../core/ui/cards/premium_card.dart';
import '../../../domain/models/weekly_progress_view_model.dart';

class PremiumWeeklyCard extends StatelessWidget {
  const PremiumWeeklyCard({super.key, required this.weekly});

  final WeeklyProgressViewModel weekly;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Weekly Progress",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // 🔥 Animated Progress
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: weekly.completionRate),
            duration: const Duration(milliseconds: 800),
            builder: (_, value, __) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation(
                    Color(0xFF6366F1),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metric("Completed", "${weekly.completed}/${weekly.target}"),
              _metric("XP", "${weekly.totalXP}"),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metric("Active Days", "${weekly.activeDays}/7"),
              Text(
                "+${weekly.changePercentage.toStringAsFixed(1)}%",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}