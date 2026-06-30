import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/app_theme.dart';

class StreakCalculatorApp extends StatelessWidget {
  const StreakCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Streak Calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
