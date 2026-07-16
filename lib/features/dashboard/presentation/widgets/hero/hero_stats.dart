import 'package:flutter/material.dart';

import 'hero_stat_item.dart';

class HeroStats extends StatelessWidget {
  const HeroStats({
    super.key,
    required this.completed,
    required this.total,
    required this.best,
  });

  final int completed;
  final int total;
  final int best;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HeroStatItem(
          title: "Today",
          value: "$completed/$total",
        ),
        const SizedBox(width: 14),
        HeroStatItem(
          title: "Best",
          value: "$best",
        ),
        const SizedBox(width: 14),
        HeroStatItem(
          title: "XP",
          value: "$total",
        ),
      ],
    );
  }
}
