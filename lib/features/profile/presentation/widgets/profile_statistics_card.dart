import 'package:flutter/material.dart';

class ProfileStatisticsCard
    extends StatelessWidget {
  const ProfileStatisticsCard({
    super.key,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalXP,
  });

  final int currentStreak;

  final int bestStreak;

  final int totalXP;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
        const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceAround,
          children: [
            _item(
              context,
              'Current',
              '$currentStreak',
            ),
            _item(
              context,
              'Best',
              '$bestStreak',
            ),
            _item(
              context,
              'XP',
              '$totalXP',
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(
      BuildContext context,
      String title,
      String value,
      ) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .headlineSmall,
        ),
        Text(title),
      ],
    );
  }
}