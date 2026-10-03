import 'package:flutter/foundation.dart';

/// Thin wrapper around [debugPrint] that is a no-op in release builds.
///
/// `debugPrint` alone still prints in release mode (it only throttles
/// output), so call sites that want development-only diagnostics
/// should go through here instead of calling `debugPrint` directly.
class AppLogger {
  const AppLogger._();

  static void log(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
}
