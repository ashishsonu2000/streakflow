import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The app's SharedPreferences instance, loaded once in main() and
/// injected with an override so it can be read synchronously.
///
/// Null when not injected (widget tests, or if loading failed); callers
/// must then fall back to defaults.
final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) {
  return null;
});
