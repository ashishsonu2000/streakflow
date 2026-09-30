import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../habits/presentation/provider/habit_providers.dart';
import '../../domain/services/csv_exporter.dart';

/// Premium: exports all habits (active and archived) and the full
/// completion history as two CSV files and opens the share sheet.
///
/// Callers must check PremiumFeature.csvExport first.
final csvExportProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final repository = ref.read(habitRepositoryProvider);

    final active = await repository.getAll();
    final archived = await repository.watchArchived().first;
    final habits = [...active, ...archived];
    final logs = await repository.getLogs();

    final directory = await getTemporaryDirectory();
    final stamp = DateTime.now().toIso8601String().substring(0, 10);

    final habitsFile = File('${directory.path}/streakflow_habits_$stamp.csv');
    final historyFile =
        File('${directory.path}/streakflow_history_$stamp.csv');

    // UTF-8 BOM so Excel opens non-ASCII habit names correctly.
    const bom = '﻿';
    await habitsFile.writeAsString('$bom${CsvExporter.habitsCsv(habits)}');
    await historyFile
        .writeAsString('$bom${CsvExporter.historyCsv(logs, habits)}');

    await SharePlus.instance.share(
      ShareParams(
        subject: 'StreakFlow export',
        files: [
          XFile(habitsFile.path, mimeType: 'text/csv'),
          XFile(historyFile.path, mimeType: 'text/csv'),
        ],
      ),
    );
  };
});
