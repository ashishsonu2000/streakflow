import 'package:flutter/material.dart';

import 'hero_stat_item.dart';

class HeroStats extends StatelessWidget {
  const HeroStats({
    super.key,
    required this.completed,
    required this.total,
    required this.best,
    required this.target,
  });

  final int completed;
  final int total;
  final int best;
  final int target;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: HeroStatItem(
            value: '$completed',
            label: 'Completed',
          ),
        ),

        _divider(),

        Expanded(
          child: HeroStatItem(
            value: '$target',
            label: 'Target',
          ),
        ),

        _divider(),

        Expanded(
          child: HeroStatItem(
            value: '$best',
            label: 'Best',
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white.withValues(alpha: 0.12),
    );
  }
}