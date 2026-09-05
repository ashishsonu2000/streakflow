import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/profile/domain/models/app_theme_mode.dart';
import '../features/profile/presentation/providers/profile_provider.dart';
import 'router.dart' as AppRouter;
import 'theme/app_theme.dart';

class StreakCalculatorApp extends ConsumerWidget {
  const StreakCalculatorApp({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final profileAsync = ref.watch(
      profileProvider,
    );

    // -------------------------------------------------------------
    // Resolve the user's saved appearance preference.
    //
    // While the profile is loading or unavailable, fall back to
    // the device/system theme.
    // -------------------------------------------------------------

    final themeMode = profileAsync.maybeWhen(
      data: (profile) => _toThemeMode(
        profile.themeMode,
      ),
      orElse: () => ThemeMode.system,
    );

    return MaterialApp.router(
      title: 'Streak Calculator',

      debugShowCheckedModeBanner: false,

      // -----------------------------------------------------------
      // THEMES
      // -----------------------------------------------------------

      theme: AppTheme.lightTheme,

      darkTheme: AppTheme.darkTheme,

      // IMPORTANT:
      // This now follows the user's saved Appearance selection.
      themeMode: themeMode,

      // -----------------------------------------------------------
      // ROUTER
      // -----------------------------------------------------------

      routerConfig: AppRouter.router,
    );
  }

  // ===============================================================
  // APP THEME MODE → FLUTTER THEME MODE
  // ===============================================================

  ThemeMode _toThemeMode(
      AppThemeMode mode,
      ) {
    switch (mode) {
      case AppThemeMode.system:
        return ThemeMode.system;

      case AppThemeMode.light:
        return ThemeMode.light;

      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }
}