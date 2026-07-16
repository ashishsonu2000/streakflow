import 'package:flutter/material.dart';

import '../design/app_breakpoints.dart';
import '../theme/app_spacing.dart';

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 4,
    this.largeDesktopColumns = 4,
    this.mobileAspectRatio = 1.2,
    this.tabletAspectRatio = 1.5,
    this.desktopAspectRatio = 1.65,
    this.largeDesktopAspectRatio = 1.75,
    this.spacing = AppSpacing.lg,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  final List<Widget> children;

  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final int largeDesktopColumns;

  final double mobileAspectRatio;
  final double tabletAspectRatio;
  final double desktopAspectRatio;
  final double largeDesktopAspectRatio;

  final double spacing;

  final bool shrinkWrap;

  final ScrollPhysics physics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth;

        late final int columns;
        late final double aspectRatio;

        if (width >= AppBreakpoints.largeDesktop) {
          columns = largeDesktopColumns;
          aspectRatio = largeDesktopAspectRatio;
        } else if (width >= AppBreakpoints.desktop) {
          columns = desktopColumns;
          aspectRatio = desktopAspectRatio;
        } else if (width >= AppBreakpoints.tablet) {
          columns = tabletColumns;
          aspectRatio = tabletAspectRatio;
        } else {
          columns = mobileColumns;
          aspectRatio = mobileAspectRatio;
        }

        return GridView.builder(
          shrinkWrap: shrinkWrap,
          primary: false,
          physics: physics,
          itemCount: children.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (_, index) => children[index],
        );
      },
    );
  }
}
