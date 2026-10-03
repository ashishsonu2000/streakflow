import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ads/ad_providers.dart';
import 'settings_navigation_tile.dart';

/// "Ad privacy choices" entry point required by Google's User
/// Messaging Platform for users in regulated regions (EEA/UK, some US
/// states). Renders nothing when UMP reports it is not required.
class AdPrivacyOptionsTile extends ConsumerWidget {
  const AdPrivacyOptionsTile({
    super.key,
    this.leading,
  });

  /// Optional widget shown above the tile (e.g. a group divider), so
  /// the divider disappears together with the tile.
  final Widget? leading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final required = ref.watch(
      adsControllerProvider.select(
        (state) => state.privacyOptionsRequired,
      ),
    );

    if (!required) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) leading!,
        SettingsNavigationTile(
          icon: Icons.ads_click_outlined,
          title: 'Ad Privacy Choices',
          subtitle: 'Review or change your ad consent',
          onTap: () async {
            final messenger = ScaffoldMessenger.of(context);

            final error = await ref
                .read(adsControllerProvider.notifier)
                .showPrivacyOptions();

            if (error != null) {
              messenger.showSnackBar(
                SnackBar(
                  content: Text(error),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
