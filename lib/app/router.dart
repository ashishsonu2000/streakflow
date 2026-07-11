import 'package:go_router/go_router.dart';

import '../../features/habits/domain/models/habit_form_arguments.dart';
import '../../features/habits/presentation/pages/habit_form_page.dart';
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
        path: AppRoutes.habitForm,
        name: 'habit-form',
        builder: (context, state) {
          return HabitFormPage(
            arguments: const HabitFormArguments(),
          );
        },
      ),
    ],
  );
}
