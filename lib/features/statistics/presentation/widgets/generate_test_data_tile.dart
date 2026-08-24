import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenerateTestDataTile extends ConsumerWidget {
  const GenerateTestDataTile({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    return ListTile(
      leading: const Icon(
        Icons.science_outlined,
      ),
      title: const Text(
        'Generate Test Data',
      ),
      subtitle: const Text(
        'Populate habits with sample statistics',
      ),
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text(
              'Coming soon',
            ),
          ),
        );
      },
    );
  }
}