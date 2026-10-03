import 'package:flutter/material.dart';

class ImportTile extends StatelessWidget {
  const ImportTile({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(
      BuildContext context,
      ) {
    return ListTile(
      leading: const Icon(
        Icons.file_upload_outlined,
      ),
      title: const Text(
        'Import Data',
      ),
      subtitle: const Text(
        'Restore a backup file',
      ),
      trailing: const Icon(
        Icons.chevron_right,
      ),
      onTap: onTap,
    );
  }
}