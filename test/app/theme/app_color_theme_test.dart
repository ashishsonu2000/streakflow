import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streak_calculator_flutter/app/theme/app_color_theme.dart';
import 'package:streak_calculator_flutter/app/theme/app_colors.dart';
import 'package:streak_calculator_flutter/core/entitlements/entitlement_provider.dart';
import 'package:streak_calculator_flutter/core/storage/shared_preferences_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> container([Map<String, Object> prefs = const {}]) async {
    SharedPreferences.setMockInitialValues(prefs);
    final instance = await SharedPreferences.getInstance();
    final c = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(instance)],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('Classic is free and uses the original StreakFlow seed', () {
    expect(AppColorTheme.classic.isPremium, isFalse);
    expect(AppColorTheme.classic.seed, AppColors.primary);
    expect(
      AppColorTheme.values.where((t) => t != AppColorTheme.classic),
      everyElement(predicate<AppColorTheme>((t) => t.isPremium)),
    );
  });

  test('defaults to Classic; unknown saved values fall back to Classic',
      () async {
    expect((await container()).read(effectiveColorThemeProvider),
        AppColorTheme.classic);
    expect(
      (await container({'color_theme_v1': 'removed_theme'}))
          .read(selectedColorThemeProvider),
      AppColorTheme.classic,
    );
  });

  test('free user: saved premium theme is not applied', () async {
    final c = await container({'color_theme_v1': 'ocean'});

    expect(c.read(selectedColorThemeProvider), AppColorTheme.ocean);
    expect(c.read(effectiveColorThemeProvider), AppColorTheme.classic);
  });

  test('premium user: selection is applied and persisted', () async {
    final c = await container();
    c.read(entitlementProvider.notifier).debugOverride(Entitlement.premium);

    await c.read(selectedColorThemeProvider.notifier).select(AppColorTheme.berry);

    expect(c.read(effectiveColorThemeProvider), AppColorTheme.berry);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('color_theme_v1'), 'berry');
  });

  test('premium lapses: falls back to Classic, returns when renewed',
      () async {
    final c = await container({'color_theme_v1': 'midnight'});
    final entitlement = c.read(entitlementProvider.notifier);

    entitlement.debugOverride(Entitlement.premium);
    expect(c.read(effectiveColorThemeProvider), AppColorTheme.midnight);

    entitlement.debugOverride(Entitlement.free);
    expect(c.read(effectiveColorThemeProvider), AppColorTheme.classic);

    entitlement.debugOverride(Entitlement.premium);
    expect(c.read(effectiveColorThemeProvider), AppColorTheme.midnight);
  });
}
