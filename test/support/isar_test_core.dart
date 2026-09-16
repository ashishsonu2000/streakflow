import 'dart:ffi';
import 'dart:io';

import 'package:isar_community/src/native/isar_core.dart';

/// Registers Isar's native binary for [Abi.current()] so tests that open
/// a real Isar database work outside a full Flutter app (where the
/// isar_community_flutter_libs plugin normally handles this).
///
/// `flutter test` runs on the desktop host VM, not a real
/// Android/iOS/web target, so the plugin's native asset registration
/// never happens - the library has to be located and loaded manually.
/// Only desktop platforms (the ones `flutter test` actually runs on)
/// are supported here.
///
/// Call this once from a `setUpAll` in any test that constructs an
/// [IsarService]/opens a real Isar database.
Future<void> initializeIsarTestCore() async {
  final library = File(_resolveLibraryPath());

  if (!library.existsSync()) {
    throw StateError(
      'Isar native library was not found:\n'
      '${library.path}\n'
      'Run `flutter pub get` first so isar_community_flutter_libs is '
      'downloaded into the pub cache.',
    );
  }

  await initializeCoreBinary(
    libraries: {
      Abi.current(): library.path,
    },
  );
}

String _resolveLibraryPath() {
  final pubCacheRoot = _pubCacheRoot();

  final packageDir = 'isar_community_flutter_libs-3.3.2';

  if (Platform.isWindows) {
    return _join([pubCacheRoot, 'hosted', 'pub.dev', packageDir, 'windows', 'libisar.dll']);
  }

  if (Platform.isMacOS) {
    return _join([pubCacheRoot, 'hosted', 'pub.dev', packageDir, 'macos', 'libisar.dylib']);
  }

  if (Platform.isLinux) {
    return _join([pubCacheRoot, 'hosted', 'pub.dev', packageDir, 'linux', 'libisar.so']);
  }

  throw UnsupportedError(
    'initializeIsarTestCore does not support ${Platform.operatingSystem}.',
  );
}

String _pubCacheRoot() {
  final explicit = Platform.environment['PUB_CACHE'];

  if (explicit != null && explicit.isNotEmpty) {
    return explicit;
  }

  if (Platform.isWindows) {
    final localAppData = Platform.environment['LOCALAPPDATA'];

    if (localAppData == null) {
      throw StateError(
        'Neither PUB_CACHE nor LOCALAPPDATA is set - cannot locate the '
        'pub cache.',
      );
    }

    return _join([localAppData, 'Pub', 'Cache']);
  }

  final home = Platform.environment['HOME'];

  if (home == null) {
    throw StateError(
      'Neither PUB_CACHE nor HOME is set - cannot locate the pub cache.',
    );
  }

  return _join([home, '.pub-cache']);
}

String _join(List<String> parts) => parts.join(Platform.pathSeparator);
