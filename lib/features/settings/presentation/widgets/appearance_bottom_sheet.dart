import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_color_theme.dart';
import '../../../../core/entitlements/entitlement_provider.dart';
import '../../../../core/entitlements/premium_feature.dart';
import '../../../premium/presentation/premium_gate.dart';
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

                const SizedBox(
                  height: 8,
                ),

                const _ColorThemePicker(),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =====================================================================
// COLOR THEME (Premium themes)
// =====================================================================

class _ColorThemePicker extends ConsumerWidget {
  const _ColorThemePicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final applied = ref.watch(effectiveColorThemeProvider);
    final unlocked = ref
        .watch(featureAccessProvider)
        .canUse(PremiumFeature.premiumThemes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Text(
                'Color theme',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (!unlocked) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.workspace_premium_outlined,
                  size: 18,
                  color: colors.primary,
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              for (final option in AppColorTheme.values)
                _ColorThemeOption(
                  option: option,
                  selected: option == applied,
                  locked: option.isPremium && !unlocked,
                  onTap: () async {
                    if (option.isPremium &&
                        !await PremiumGate.canUse(
                          context,
                          ref,
                          PremiumFeature.premiumThemes,
                        )) {
                      return;
                    }

                    await ref
                        .read(selectedColorThemeProvider.notifier)
                        .select(option);
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ColorThemeOption extends StatelessWidget {
  const _ColorThemeOption({
    required this.option,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  final AppColorTheme option;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      label: locked ? '${option.label}, Premium theme' : option.label,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 56,
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: option.seed,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? colors.onSurface : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.check_rounded, color: Colors.white)
                    : locked
                        ? const Icon(
                            Icons.lock_outline_rounded,
                            color: Colors.white,
                            size: 18,
                          )
                        : null,
              ),
              const SizedBox(height: 4),
              ExcludeSemantics(
                child: Text(
                  option.label,
                  style: Theme.of(context).textTheme.labelSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
