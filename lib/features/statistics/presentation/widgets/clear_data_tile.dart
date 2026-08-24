import 'package:flutter/material.dart';

class ClearDataTile extends StatelessWidget {
  const ClearDataTile({
    super.key,
  });

  Future<void> _confirm(
      BuildContext context,
      ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Clear all data?',
          ),
          content: const Text(
            'All habits, logs, statistics, achievements, and profile data will be deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (result == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Coming soon',
          ),
        ),
      );
    }
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return ListTile(
      leading: const Icon(
        Icons.delete_outline,
      ),
      title: const Text(
        'Clear All Data',
      ),
      subtitle: const Text(
        'Reset the application',
      ),
      onTap: () {
        _confirm(
          context,
        );
      },
    );
  }
}