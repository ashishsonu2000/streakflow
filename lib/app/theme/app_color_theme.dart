import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/entitlements/entitlement_provider.dart';
import '../../core/entitlements/premium_feature.dart';
import '../../core/storage/shared_preferences_provider.dart';
import 'app_colors.dart';

/// Seed-color themes. Classic is the original StreakFlow look and is
/// free; the others are StreakFlow Premium themes. Each works in light
/// and dark mode (Material 3 ColorScheme.fromSeed).
enum AppColorTheme {
  classic('Classic', AppColors.primary, isPremium: false),
  ocean('Ocean', Color(0xFF0277BD)),
  forest('Forest', Color(0xFF2E7D32)),
  sunset('Sunset', Color(0xFFE65100)),
  berry('Berry', Color(0xFFAD1457)),
  midnight('Midnight', Color(0xFF4527A0));

  const AppColorTheme(this.label, this.seed, {this.isPremium = true});

  final String label;
  final Color seed;
  final bool isPremium;

  static AppColorTheme fromName(String? name) => AppColorTheme.values
      .firstWhere((t) => t.name == name, orElse: () => AppColorTheme.classic);
}

/// The theme the user picked (persisted in SharedPreferences; no
/// database change).
class ColorThemeNotifier extends Notifier<AppColorTheme> {
  static const _key = 'color_theme_v1';

  @override
  AppColorTheme build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return AppColorTheme.fromName(prefs?.getString(_key));
  }

  Future<void> select(AppColorTheme theme) async {
    state = theme;
    await ref.read(sharedPreferencesProvider)?.setString(_key, theme.name);
  }
}

final selectedColorThemeProvider =
    NotifierProvider<ColorThemeNotifier, AppColorTheme>(
  ColorThemeNotifier.new,
);

/// The theme actually applied. A Premium theme falls back to Classic
/// when Premium is not active (e.g. subscription lapsed); the choice is
/// kept and returns automatically if Premium is renewed.
final effectiveColorThemeProvider = Provider<AppColorTheme>((ref) {
  final selected = ref.watch(selectedColorThemeProvider);
  final canUsePremiumThemes =
      ref.watch(featureAccessProvider).canUse(PremiumFeature.premiumThemes);

  return !selected.isPremium || canUsePremiumThemes
      ? selected
      : AppColorTheme.classic;
});
