import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'isar_service.dart';

/// Singleton IsarService
final isarServiceProvider = Provider<IsarService>((ref) {
  final service = IsarService();

  ref.onDispose(() async {
    await service.close();
  });

  return service;
});
