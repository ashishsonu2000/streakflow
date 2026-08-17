class XPTrend {
  const XPTrend({
    required this.date,
    required this.xp,
    required this.cumulativeXp,
  });

  final DateTime date;

  final int xp;

  final int cumulativeXp;
}