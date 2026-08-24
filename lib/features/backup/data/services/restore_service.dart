import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../../domain/models/restore_preview.dart';



class RestoreService {
  const RestoreService();

  Future<RestorePreview?> pickAndPreview() async {
    final result =
    await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'json',
      ],
    );

    if (result == null) {
      return null;
    }

    final path =
        result.files.single.path;

    if (path == null) {
      return null;
    }

    final file = File(
      path,
    );

    final json =
    jsonDecode(
      await file.readAsString(),
    );

    return RestorePreview(
      version:
      json['version'] ??
          'Unknown',
      exportedAt: DateTime.parse(
        json['exportedAt'],
      ),
      profileName:
      json['profile']['name'] ??
          'Unknown',
      habitCount:
      (json['habits'] as List)
          .length,
      logCount:
      (json['logs'] as List)
          .length,
    );
  }
}