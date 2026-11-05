import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streak_calculator_flutter/core/storage/shared_preferences_provider.dart';
import 'package:streak_calculator_flutter/features/dashboard/presentation/providers/dashboard_tips_provider.dart';
import 'package:streak_calculator_flutter/features/settings/domain/services/rate_app_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  ProviderContainer container() {
    final c = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(c.dispose);
    return c;
  }

  group('dashboard tips', () {
    test('start at the first tip on a new install', () {
      expect(container().read(dashboardTipsProvider), 0);
    });

    test('next tip is remembered across restarts', () async {
      await container().read(dashboardTipsProvider.notifier).next();
      expect(container().read(dashboardTipsProvider), 1);
    });

    test('hidden after the last tip', () async {
      final c = container();
      for (var i = 0; i < dashboardTips.length; i++) {
        await c.read(dashboardTipsProvider.notifier).next();
      }
      expect(c.read(dashboardTipsProvider), isNull);
      expect(container().read(dashboardTipsProvider), isNull);
    });

    test('closing hides them for good', () async {
      await container().read(dashboardTipsProvider.notifier).dismiss();
      expect(container().read(dashboardTipsProvider), isNull);
    });

    test('never shown without stored preferences', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      expect(c.read(dashboardTipsProvider), isNull);
    });
  });

  group('rating prompt after a streak milestone', () {
    bool should(int from, int to) => RateAppService.shouldPromptForMilestone(
          prefs: prefs,
          previousStreak: from,
          streak: to,
        );

    test('asks when the streak reaches 7 days', () {
      expect(should(6, 7), isTrue);
    });

    test('does not ask below 7 days or when the streak did not grow', () {
      expect(should(5, 6), isFalse);
      expect(should(7, 7), isFalse);
      expect(should(8, 7), isFalse);
    });

    test('asks later if the 7th day was skipped (e.g. level-up)', () {
      expect(should(7, 8), isTrue);
    });

    test('asks only once per install', () async {
      await prefs.setBool(RateAppService.milestonePromptKey, true);
      expect(should(6, 7), isFalse);
    });

    test('never asks without stored preferences', () {
      expect(
        RateAppService.shouldPromptForMilestone(
          prefs: null,
          previousStreak: 6,
          streak: 7,
        ),
        isFalse,
      );
    });
  });
}
