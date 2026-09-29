import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ads/banner_ad_slot.dart';
import '../../domain/enums/shell_tab.dart';
import '../provider/navigation_provider.dart';

/// Banner for a page hosted in [MainShell]'s IndexedStack.
///
/// All shell tabs are built at once, so the banner only requests an ad
/// once [tab] is actually the visible tab.
class ShellTabBannerAd extends ConsumerWidget {
  const ShellTabBannerAd({
    super.key,
    required this.tab,
  });

  final ShellTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(navigationProvider) == tab;

    return BannerAdSlot(
      active: isVisible,
    );
  }
}
