import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/enums/shell_tab.dart';

class NavigationNotifier extends Notifier<ShellTab> {
  @override
  ShellTab build() {
    return ShellTab.home;
  }

  void goTo(
      ShellTab tab,
      ) {
    state = tab;
  }

  void goDashboard() {
    goTo(
      ShellTab.home,
    );
  }

  void goHabits() {
    goTo(
      ShellTab.habits,
    );
  }

  void goCalendar() {
    goTo(
      ShellTab.calendar,
    );
  }

  void goStatistics() {
    goTo(
      ShellTab.statistics,
    );
  }

  void goSettings() {
    goTo(
      ShellTab.settings,
    );
  }
}

final navigationProvider =
NotifierProvider<
    NavigationNotifier,
    ShellTab
>(
  NavigationNotifier.new,
);