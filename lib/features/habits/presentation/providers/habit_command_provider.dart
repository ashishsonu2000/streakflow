import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/habit_command_notifier.dart';

final habitCommandNotifierProvider =
    AsyncNotifierProvider<HabitCommandNotifier, void>(
  HabitCommandNotifier.new,
);
