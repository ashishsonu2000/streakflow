/// Standard animation durations.
///
/// Keep all animations consistent.
abstract final class AppDuration {
  AppDuration._();

  static const fast = Duration(milliseconds: 150);

  static const normal = Duration(milliseconds: 250);

  static const slow = Duration(milliseconds: 350);

  static const pageTransition = Duration(milliseconds: 300);

  static const snackbar = Duration(seconds: 3);
}
