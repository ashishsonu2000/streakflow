enum Difficulty {
  easy(
    label: 'Easy',
    xpReward: 5,
    multiplier: 1.0,
  ),
  medium(
    label: 'Medium',
    xpReward: 10,
    multiplier: 1.5,
  ),
  hard(
    label: 'Hard',
    xpReward: 20,
    multiplier: 2.0,
  );

  const Difficulty({
    required this.label,
    required this.xpReward,
    required this.multiplier,
  });

  final String label;
  final int xpReward;
  final double multiplier;
}
