import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/core/billing/play_billing_gateway.dart';

void main() {
  group('periodLabel (ISO-8601 billing periods from Google Play)', () {
    test('single units', () {
      expect(PlayBillingMapping.periodLabel('P1M'), 'per month');
      expect(PlayBillingMapping.periodLabel('P1Y'), 'per year');
      expect(PlayBillingMapping.periodLabel('P1W'), 'per week');
    });

    test('multiple units', () {
      expect(PlayBillingMapping.periodLabel('P3M'), 'every 3 months');
      expect(PlayBillingMapping.periodLabel('P6M'), 'every 6 months');
    });

    test('unknown format yields an empty label, not a crash', () {
      expect(PlayBillingMapping.periodLabel(''), '');
      expect(PlayBillingMapping.periodLabel('P1Y2M'), '');
    });
  });

  test('plan titles for the configured base plans', () {
    expect(PlayBillingMapping.planTitle('monthly'), 'Monthly');
    expect(PlayBillingMapping.planTitle('yearly'), 'Yearly');
    expect(PlayBillingMapping.planTitle('quarterly'), 'Quarterly');
  });

  test('monthly is listed before yearly', () {
    final ids = ['yearly', 'other', 'monthly']
      ..sort((a, b) => PlayBillingMapping.planOrder(a)
          .compareTo(PlayBillingMapping.planOrder(b)));

    expect(ids, ['monthly', 'yearly', 'other']);
  });
}
