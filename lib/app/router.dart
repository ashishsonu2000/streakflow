import 'package:go_router/go_router.dart';

import '../features/calendar/presentation/pages/calendar_page.dart';
import '../features/habits/domain/models/habit.dart';
import '../features/habits/domain/models/habit_form_arguments.dart';
import '../features/habits/presentation/pages/archived_habits_page.dart';
import '../features/habits/presentation/pages/habit_detail_page.dart';
import '../features/habits/presentation/pages/habit_form_page.dart';
import '../shell/presentation/pages/main_shell.dart';
import 'routes.dart';

final router = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const MainShell(),
    ),
    GoRoute(
      path: AppRoutes.calendar,
      name: 'calendar',
      builder: (context, state) {
        return const CalendarPage();
      },
    ),
    GoRoute(
      path: AppRoutes.habitForm,
      name: 'habit-form',
      builder: (context, state) {
        final arguments = state.extra as HabitFormArguments?;

        return HabitFormPage(
          arguments: arguments,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.habitDetail,
      name: 'habit-detail',
      builder: (context, state) {
        final habit = state.extra as Habit;

        return HabitDetailPage(
          habit: habit,
        );
      },
    ),
    GoRoute(
      path: '/settings/archived-habits',
      name: 'archived-habits',
      builder: (_, __) => const ArchivedHabitsPage(),
    ),
  ],
);
