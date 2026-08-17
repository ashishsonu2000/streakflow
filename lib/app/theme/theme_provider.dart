import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/profile/presentation/providers/profile_provider.dart';
import '../../features/profile/domain/models/app_theme_mode.dart';

final themeProvider = Provider<ThemeMode>(
      (ref) {
    final profile = ref.watch(
      profileProvider,
    );

    return profile.when(
      loading: () => ThemeMode.system,
      error: (_, __) => ThemeMode.system,
      data: (profile) {
        switch (profile.themeMode) {
          case AppThemeMode.light:
            return ThemeMode.light;

          case AppThemeMode.dark:
            return ThemeMode.dark;

          case AppThemeMode.system:
            return ThemeMode.system;
        }
      },
    );
  },
);