import 'package:flutter_test/flutter_test.dart';
import 'package:streak_calculator_flutter/features/dashboard/presentation/widgets/activity/activity_time_formatter.dart';

void main() {
  String at(DateTime date, DateTime now) =>
      ActivityTimeFormatter.format(date, now: now);

  final morning = DateTime(2026, 10, 3, 8);
  final lateNight = DateTime(2026, 10, 3, 23);

  test('same day: minutes and hours ago', () {
    expect(at(morning, morning), 'Just now');
    expect(at(DateTime(2026, 10, 3, 7, 30), morning), '30 min ago');
    expect(at(DateTime(2026, 10, 3, 1), lateNight), '22 hr ago');
  });

  test('previous calendar day is Yesterday, even a few hours ago', () {
    // 23:00 yesterday, now 08:00: 9 hours, but yesterday.
    expect(at(DateTime(2026, 10, 2, 23), morning), 'Yesterday');
    expect(at(DateTime(2026, 10, 2, 1), lateNight), 'Yesterday');
  });

  test('two calendar days back is not Yesterday', () {
    // 23:00 two days ago, now 08:00: only 33 hours.
    expect(at(DateTime(2026, 10, 1, 23), morning), '2 days ago');
  });

  test('older activity counts calendar days', () {
    expect(at(DateTime(2026, 9, 3, 12), morning), '30 days ago');
  });

  test('across a month boundary', () {
    expect(at(DateTime(2026, 9, 30, 20), DateTime(2026, 10, 1, 6)),
        'Yesterday');
  });
}
