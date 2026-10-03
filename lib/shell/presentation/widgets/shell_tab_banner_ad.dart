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
    this.padding = const EdgeInsets.only(top: 16),
  });

  final ShellTab tab;

  /// Use extra bottom padding on pages whose content ends close to the
  /// navigation bar, so ad buttons never sit next to it.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(navigationProvider) == tab;

    return BannerAdSlot(
      active: isVisible,
      padding: padding,
    );
  }
}
