import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/calculators/streak_calculator.dart';

final streakCalculatorProvider = Provider(
  (_) => StreakCalculator(),
);
