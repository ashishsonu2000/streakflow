import 'package:flutter/foundation.dart';

@immutable
class StreakResult {
  const StreakResult({
    required this.current,
    required this.best,
  });

  final int current;
  final int best;
}
