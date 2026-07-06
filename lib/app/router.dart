import 'package:go_router/go_router.dart';

import '../shell/presentation/pages/main_shell.dart';
import 'routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainShell(),
      ),
    ],
  );
}
