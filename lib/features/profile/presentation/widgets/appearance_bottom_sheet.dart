import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/app_theme_mode.dart';
import '../providers/profile_provider.dart';

class AppearanceBottomSheet
    extends ConsumerWidget {
  const AppearanceBottomSheet({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final profile =
    ref.watch(profileProvider);

    return profile.when(
      loading: () => const SizedBox(
        height: 200,
        child: Center(
          child:
          CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const SizedBox(),
      data: (profile) {
        return SafeArea(
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.settings,
                ),
                title:
                const Text('System'),
                trailing:
                profile.themeMode ==
                    AppThemeMode
                        .system
                    ? const Icon(
                  Icons.check,
                )
                    : null,
                onTap: () async {
                  await ref
                      .read(
                    profileProvider
                        .notifier,
                  )
                      .updateTheme(
                    AppThemeMode
                        .system,
                  );

                  if (context.mounted) {
                    Navigator.pop(
                      context,
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.light_mode,
                ),
                title:
                const Text('Light'),
                trailing:
                profile.themeMode ==
                    AppThemeMode
                        .light
                    ? const Icon(
                  Icons.check,
                )
                    : null,
                onTap: () async {
                  await ref
                      .read(
                    profileProvider
                        .notifier,
                  )
                      .updateTheme(
                    AppThemeMode
                        .light,
                  );

                  if (context.mounted) {
                    Navigator.pop(
                      context,
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.dark_mode,
                ),
                title:
                const Text('Dark'),
                trailing:
                profile.themeMode ==
                    AppThemeMode
                        .dark
                    ? const Icon(
                  Icons.check,
                )
                    : null,
                onTap: () async {
                  await ref
                      .read(
                    profileProvider
                        .notifier,
                  )
                      .updateTheme(
                    AppThemeMode.dark,
                  );

                  if (context.mounted) {
                    Navigator.pop(
                      context,
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}