import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'isar_service.dart';

/// Singleton IsarService
final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService.instance;
});
