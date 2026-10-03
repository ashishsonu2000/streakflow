import 'package:flutter_riverpod/flutter_riverpod.dart';

final shellProvider = NotifierProvider<ShellNotifier, int>(
  ShellNotifier.new,
);

class ShellNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void changeTab(int index) {
    state = index;
  }

  void goHome() {
    state = 0;
  }

  void goHabits() {
    state = 1;
  }

  void goStatistics() {
    state = 2;
  }

  void goSettings() {
    state = 3;
  }
}
