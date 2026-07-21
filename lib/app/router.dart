import 'package:go_router/go_router.dart';

import '../features/habits/domain/models/habit.dart';

import '../features/habits/presentation/pages/habit_detail_page.dart';
import '../shell/presentation/pages/main_shell.dart';
import 'routes.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const MainShell(),
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
    ],
  );
}
