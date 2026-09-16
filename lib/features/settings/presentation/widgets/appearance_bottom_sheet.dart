import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../profile/domain/models/app_theme_mode.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class AppearanceBottomSheet extends ConsumerWidget {
  const AppearanceBottomSheet({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final profile = ref.watch(
      profileProvider,
    );

    return profile.when(
      loading: () => const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => SizedBox(
        height: 200,
        child: Center(
          child: Text(
            error.toString(),
          ),
        ),
      ),
      data: (user) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(
              16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Appearance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                RadioGroup<AppThemeMode>(
                  groupValue: user.themeMode,
                  onChanged: (value) async {
                    if (value == null) {
                      return;
                    }

                    await ref
                        .read(
                      profileProvider.notifier,
                    )
                        .updateTheme(
                      value,
                    );

                    if (context.mounted) {
                      Navigator.pop(
                        context,
                      );
                    }
                  },
                  child: const Column(
                    children: [
                      RadioListTile<AppThemeMode>(
                        title: Text(
                          'System',
                        ),
                        value: AppThemeMode.system,
                      ),

                      RadioListTile<AppThemeMode>(
                        title: Text(
                          'Light',
                        ),
                        value: AppThemeMode.light,
                      ),

                      RadioListTile<AppThemeMode>(
                        title: Text(
                          'Dark',
                        ),
                        value: AppThemeMode.dark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}