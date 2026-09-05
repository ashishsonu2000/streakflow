import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/statistics_period.dart';



final statisticsPeriodProvider =
StateProvider<StatisticsPeriod>(
      (ref) => StatisticsPeriod.today,
);