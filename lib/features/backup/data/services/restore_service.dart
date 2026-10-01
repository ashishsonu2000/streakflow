import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../../domain/services/backup_codec.dart';

class RestoreService {
  const RestoreService();

  /// Lets the user pick a backup file and decodes it.
  ///
  /// Returns null when no file was picked. Throws
  /// [BackupFormatException] when the file is not a usable backup.
  Future<BackupContents?> pickBackup() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'json',
      ],
    );

    if (result.isEmpty) {
      return null;
    }

    final path = result.single.path;

    if (path == null) {
      return null;
    }

    final Object? json;

    try {
      json = jsonDecode(
        await File(path).readAsString(),
      );
    } on FormatException {
      throw const BackupFormatException(
        'This file is not a StreakFlow backup (invalid JSON).',
      );
    } on FileSystemException {
      throw const BackupFormatException('The file could not be read.');
    }

    return BackupCodec.decode(json);
  }
}
