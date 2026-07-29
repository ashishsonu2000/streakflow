import 'package:flutter/material.dart';

import 'hero_stat_item.dart';

class HeroStats extends StatelessWidget {
  final int completed;
  final int target;
  final int best;

  const HeroStats({
    super.key,
    required this.completed,
    required this.target,
    required this.best,
    required int total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        HeroStatItem(
          label: "Completed",
          value: completed.toString(),
        ),
        HeroStatItem(
          label: "Target",
          value: target.toString(),
        ),
        HeroStatItem(
          label: "Best",
          value: best.toString(),
        ),
      ],
    );
  }
}
