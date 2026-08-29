import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

class StreakCalculatorApp extends ConsumerWidget {
  const StreakCalculatorApp({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    return MaterialApp.router(
      title: 'Streak Flow',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      themeMode: ref.watch(themeProvider),

      routerConfig: router,
    );
  }
}