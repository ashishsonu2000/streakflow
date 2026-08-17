import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../providers/profile_provider.dart';

class ProfileActionsSection extends ConsumerWidget {
  const ProfileActionsSection({
    super.key,
  });

  Future<void> _reset(
      BuildContext context,
      WidgetRef ref,
      ) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Reset onboarding?',
              ),
              content: const Text(
                'You will need to complete onboarding again.',
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
                    'Reset',
                  ),
                ),
              ],
            );
          },
        ) ??
            false;

    if (!confirmed) {
      return;
    }

    await ref
        .read(
      profileProvider.notifier,
    )
        .resetOnboarding();

    if (!context.mounted) {
      return;
    }

    context.go(
      AppRoutes.appStart,
    );
  }

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.edit_outlined,
            ),
            title: const Text(
              'Edit Profile',
            ),
            subtitle: const Text(
              'Edit your preferences',
            ),
            onTap: () {
              context.push(
                AppRoutes.editProfile,
              );
            },
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.restart_alt_outlined,
            ),
            title: const Text(
              'Reset Onboarding',
            ),
            subtitle: const Text(
              'Start over',
            ),
            onTap: () {
              _reset(
                context,
                ref,
              );
            },
          ),
        ],
      ),
    );
  }
}