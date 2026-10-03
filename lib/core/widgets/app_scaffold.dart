import 'package:flutter/material.dart';

import '../../app/theme/app_dimensions.dart';

class AppScaffold extends StatelessWidget {
  final String title;

  final Widget child;

  final Widget? floatingActionButton;

  final bool showAppBar;

  final PreferredSizeWidget? appBar;

  final Widget? bottomNavigationBar;

  final List<Widget>? actions;

  const AppScaffold({
    super.key,
    required this.title,
    required this.child,
    this.showAppBar = true,
    this.appBar,
    this.bottomNavigationBar,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? appBar ??
              AppBar(
                title: Text(title),
                actions: actions,
              )
          : null,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.pagePadding,
          child: child,
        ),
      ),
    );
  }
}
