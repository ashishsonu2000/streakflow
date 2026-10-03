import 'package:flutter/material.dart';

import '../../../domain/models/statistic_tile.dart';
import '../cards/statistic_tile_card.dart';

class StatisticGrid extends StatelessWidget {
  const StatisticGrid({
    super.key,
    required this.tiles,
  });

  final List<StatisticTileModel> tiles;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 700 ? 4 : 2;

        return GridView.builder(
          itemCount: tiles.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
          ),
          itemBuilder: (_, index) {
            return StatisticTileCard(
              model: tiles[index],
            );
          },
        );
      },
    );
  }
}
